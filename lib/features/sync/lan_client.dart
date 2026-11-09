import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:mane_core/mane_core.dart';

import '../../models/local_identity.dart';
import '../../models/paired_device.dart';
import '../../services/planner_repository.dart';
import 'pairing_crypto.dart';

class RemoteInfo {
  const RemoteInfo({
    required this.deviceId,
    required this.deviceName,
    required this.username,
    required this.fingerprint,
    required this.port,
    required this.protocol,
  });

  final String deviceId;
  final String deviceName;
  final String username;
  final String fingerprint;
  final int port;
  final int protocol;
}

class LanClientException implements Exception {
  const LanClientException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Pinned HTTPS client for pairing and querying a peer.
class LanClient {
  LanClient(this._repository, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  static const _timeout = Duration(seconds: 12);

  final PlannerRepository _repository;
  final DateTime Function() _clock;

  Future<RemoteInfo> fetchInfo({required String host, required int port}) async {
    final captured = <String>[];
    final client = _client(allowAny: true, captured: captured);
    try {
      final response = await _get(client, host, port, '/mane/v1/info').timeout(_timeout);
      if (response.statusCode != HttpStatus.ok) {
        throw LanClientException('The device did not answer (${response.statusCode})');
      }
      final body = await utf8.decoder.bind(response).join();
      final json = jsonDecode(body);
      if (json is! Map<String, dynamic> || json['app'] != 'mane') {
        throw const LanClientException('That address is not a Mane device');
      }
      if (captured.isEmpty) throw const LanClientException('No certificate was presented');
      final info = RemoteInfo(
        deviceId: '${json['deviceId']}',
        deviceName: '${json['deviceName']}',
        username: '${json['username']}',
        fingerprint: captured.last,
        port: json['port'] is int ? json['port'] as int : port,
        protocol: json['protocol'] is int ? json['protocol'] as int : 0,
      );
      if (info.fingerprint != '${json['fingerprint']}') {
        throw const LanClientException('The certificate fingerprint did not match');
      }
      return info;
    } on TimeoutException {
      throw const LanClientException('The device did not answer in time');
    } on SocketException {
      throw const LanClientException('Could not reach the device on this network');
    } finally {
      client.close(force: true);
    }
  }

  Future<PairedDevice> pair({
    required LocalIdentity identity,
    required String myFingerprint,
    required String host,
    required int port,
    required String code,
    required int myServerPort,
  }) async {
    final info = await fetchInfo(host: host, port: port);
    if (info.deviceId == identity.deviceId) {
      throw const LanClientException('That is this device');
    }
    if (info.username.trim().toLowerCase() != identity.username.trim().toLowerCase()) {
      throw const LanClientException('The username does not match this device');
    }

    final pairingKey = await PairingCrypto.derivePairingKey(
      code: code,
      hostFingerprint: info.fingerprint,
      guestFingerprint: myFingerprint,
      username: identity.username,
    );
    final sharedKey = PairingCrypto.newSharedKey();
    final encrypted = await PairingCrypto.encryptSharedKey(
      pairingKeyBase64: pairingKey,
      sharedKeyBase64: sharedKey,
    );
    final message = PairingCrypto.pairRequestMessage(
      hostFingerprint: info.fingerprint,
      guestFingerprint: myFingerprint,
      username: identity.username,
      guestDeviceId: identity.deviceId,
    );
    final mac = await PairingCrypto.hmacBase64(pairingKey, message);

    final captures = <String>[];
    final client = _client(allowAny: true, captured: captures);
    try {
      final request = await client
          .postUrl(Uri(scheme: 'https', host: host, port: port, path: '/mane/v1/pair'))
          .timeout(_timeout);
      request.headers.contentType = ContentType.json;
      request.write(
        jsonEncode({
          'username': identity.username,
          'deviceId': identity.deviceId,
          'deviceName': identity.deviceName,
          'fingerprint': myFingerprint,
          'port': myServerPort,
          'key': encrypted.toJson(),
          'mac': mac,
        }),
      );
      final response = await request.close().timeout(_timeout);
      final body = await utf8.decoder.bind(response).join();
      if (response.statusCode != HttpStatus.ok) {
        throw const LanClientException('The code was not accepted');
      }
      final json = jsonDecode(body);
      if (json is! Map<String, dynamic> || json['ok'] != true) {
        throw const LanClientException('The code was not accepted');
      }
      if (captures.isEmpty || captures.last != info.fingerprint) {
        throw const LanClientException('The device certificate changed during pairing');
      }
      final expectedAck = await PairingCrypto.hmacBase64(
        sharedKey,
        PairingCrypto.pairAckMessage(hostFingerprint: info.fingerprint, guestFingerprint: myFingerprint),
      );
      if (!PairingCrypto.constantTimeEquals(base64Decode(expectedAck), base64Decode('${json['mac']}'))) {
        throw const LanClientException('The device could not prove it stored the key');
      }
      final now = _clock().toUtc();
      final paired = PairedDevice(
        id: info.deviceId,
        name: info.deviceName,
        username: info.username,
        certificateFingerprint: info.fingerprint,
        sharedKey: sharedKey,
        host: host,
        port: port,
        lastSeenAt: now,
        createdAt: now,
        updatedAt: now,
      );
      await _repository.savePairedDevice(paired);
      return paired;
    } on TimeoutException {
      throw const LanClientException('The device did not answer in time');
    } on SocketException {
      throw const LanClientException('Could not reach the device on this network');
    } finally {
      client.close(force: true);
    }
  }

  Future<Map<String, Object?>> summary(PairedDevice device, {required String localDeviceId}) async {
    final data = await query(device, localDeviceId: localDeviceId, resource: 'summary');
    return data is Map<String, Object?> ? data : <String, Object?>{};
  }

  Future<Object?> query(
    PairedDevice device, {
    required String localDeviceId,
    required String resource,
    LocalDate? start,
    LocalDate? end,
    String? timeZone,
  }) async {
    if (device.host.isEmpty || device.port <= 0) {
      throw const LanClientException('No known address for this device');
    }
    final query = <String, String>{
      'resource': resource,
      if (start != null) 'start': start.iso,
      if (end != null) 'end': end.iso,
      'timeZone': ?timeZone,
    };
    final path = Uri(path: '/mane/v1/query', queryParameters: query).toString();
    final timestamp = _clock().toUtc().millisecondsSinceEpoch ~/ 1000;
    final nonce = PairingCrypto.randomBase64(18);
    final signature = await PairingCrypto.signRequest(
      sharedKeyBase64: device.sharedKey,
      method: 'GET',
      path: path,
      timestamp: timestamp,
      nonce: nonce,
      body: '',
    );

    final client = _client(allowAny: false, pinnedFingerprint: device.certificateFingerprint);
    try {
      final request = await client
          .getUrl(
            Uri(
              scheme: 'https',
              host: device.host,
              port: device.port,
              path: '/mane/v1/query',
              queryParameters: query,
            ),
          )
          .timeout(_timeout);
      request.headers.set('x-mane-device', localDeviceId);
      request.headers.set('x-mane-timestamp', '$timestamp');
      request.headers.set('x-mane-nonce', nonce);
      request.headers.set('x-mane-signature', signature);
      final response = await request.close().timeout(_timeout);
      final body = await utf8.decoder.bind(response).join();
      if (response.statusCode == HttpStatus.unauthorized) {
        throw const LanClientException('The pairing is no longer valid');
      }
      if (response.statusCode != HttpStatus.ok) {
        throw LanClientException('The device returned ${response.statusCode}');
      }
      final json = jsonDecode(body);
      if (json is! Map<String, dynamic>) {
        throw const LanClientException('Unexpected answer from the device');
      }
      return json['data'];
    } on TimeoutException {
      throw const LanClientException('The device did not answer in time');
    } on SocketException {
      throw const LanClientException('The device is offline');
    } on HandshakeException {
      throw const LanClientException('The device certificate did not match the pinned one');
    } finally {
      client.close(force: true);
    }
  }

  HttpClient _client({required bool allowAny, List<String>? captured, String? pinnedFingerprint}) {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 8)
      ..idleTimeout = const Duration(seconds: 2);
    client.badCertificateCallback = (certificate, host, port) {
      final fingerprint = sha256.convert(certificate.der).toString();
      if (allowAny) {
        captured?.add(fingerprint);
        return true;
      }
      return fingerprint == pinnedFingerprint;
    };
    return client;
  }

  Future<HttpClientResponse> _get(HttpClient client, String host, int port, String path) async {
    final request = await client.getUrl(Uri(scheme: 'https', host: host, port: port, path: path));
    return request.close();
  }
}

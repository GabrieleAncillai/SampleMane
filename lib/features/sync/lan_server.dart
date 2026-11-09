import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mane_core/mane_core.dart';

import '../../app_version.dart';
import '../../models/local_identity.dart';
import '../../models/paired_device.dart';
import '../../services/planner_repository.dart';
import 'device_certificate.dart';
import 'pairing_crypto.dart';
import 'remote_payload.dart';

class PairingSession {
  const PairingSession({required this.code, required this.expiresAt});

  final String code;
  final DateTime expiresAt;

  bool get expired => DateTime.now().isAfter(expiresAt);

  String get displayCode => '${code.substring(0, 3)} ${code.substring(3)}';
}

class LanServerException implements Exception {
  const LanServerException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// A small HTTPS endpoint for pairing and for read-only queries between the
/// user's own devices.
///
/// The certificate is self-signed and pinned by the peer's fingerprint. Every
/// query is signed with the paired device's shared key and a timestamped nonce.
/// The server never merges or writes remote data; it only answers queries over
/// the local repository.
class LanServer {
  LanServer({
    required PlannerRepository repository,
    required String Function() deviceTimeZone,
    DateTime Function()? clock,
  }) : _repository = repository,
       _deviceTimeZone = deviceTimeZone,
       _clock = clock ?? DateTime.now;

  static const protocolVersion = 2;

  final PlannerRepository _repository;
  final String Function() _deviceTimeZone;
  final DateTime Function() _clock;

  HttpServer? _server;
  LocalIdentity? _identity;
  String _fingerprint = '';
  _ActivePairing? _pairing;
  int _pairAttempts = 0;
  final _pairedEvents = StreamController<PairedDevice>.broadcast();
  final Map<String, Map<String, DateTime>> _nonces = {};

  Stream<PairedDevice> get pairedDevices => _pairedEvents.stream;

  PairingSession? get pairingSession {
    final active = _pairing;
    if (active == null || _clock().isAfter(active.expiresAt)) return null;
    return PairingSession(code: active.code, expiresAt: active.expiresAt);
  }

  int get port => _server?.port ?? 0;

  Future<int> start({required LocalIdentity identity, int port = 0, InternetAddress? address}) async {
    if (_server != null) return _server!.port;
    _identity = identity;
    _fingerprint = await fingerprintOfCertificatePem(identity.certificatePem);

    final context = SecurityContext()
      ..useCertificateChainBytes(utf8.encode(identity.certificatePem))
      ..usePrivateKeyBytes(utf8.encode(identity.privateKeyPem));
    final server = await HttpServer.bindSecure(
      address ?? InternetAddress.anyIPv4,
      port,
      context,
      shared: false,
    );
    _server = server;
    server.listen(_handle, onError: (Object _) {});
    return server.port;
  }

  Future<void> stop() async {
    _pairing = null;
    await _server?.close(force: true);
    _server = null;
  }

  Future<void> dispose() async {
    await stop();
    await _pairedEvents.close();
  }

  PairingSession beginPairing({Duration validFor = const Duration(minutes: 5)}) {
    final expiresAt = _clock().add(validFor);
    final active = _ActivePairing(code: PairingCrypto.newPairingCode(), expiresAt: expiresAt);
    _pairing = active;
    _pairAttempts = 0;
    return PairingSession(code: active.code, expiresAt: expiresAt);
  }

  void cancelPairing() {
    _pairing = null;
    _pairAttempts = 0;
  }

  Future<void> _handle(HttpRequest request) async {
    try {
      final path = request.uri.path;
      if (request.method == 'GET' && path == '/mane/v1/info') {
        await _handleInfo(request);
        return;
      }
      if (request.method == 'POST' && path == '/mane/v1/pair') {
        await _handlePair(request);
        return;
      }
      if (request.method == 'GET' && path == '/mane/v1/query') {
        await _handleQuery(request);
        return;
      }
      await _json(request.response, HttpStatus.notFound, {'error': 'not_found'});
    } catch (_) {
      try {
        await _json(request.response, HttpStatus.badRequest, {'error': 'bad_request'});
      } on StateError {
        // The response was already closed; nothing left to send.
      }
    }
  }

  Future<void> _handleInfo(HttpRequest request) async {
    final identity = _identity;
    if (identity == null) {
      await _json(request.response, HttpStatus.serviceUnavailable, {'error': 'not_ready'});
      return;
    }
    await _json(request.response, HttpStatus.ok, {
      'app': 'mane',
      'version': appVersion,
      'protocol': protocolVersion,
      'deviceId': identity.deviceId,
      'deviceName': identity.deviceName,
      'username': identity.username,
      'fingerprint': _fingerprint,
      'pairing': pairingSession != null,
      'port': port,
    });
  }

  Future<void> _handlePair(HttpRequest request) async {
    final identity = _identity;
    final active = _pairing;
    if (identity == null || active == null || _clock().isAfter(active.expiresAt)) {
      await _json(request.response, HttpStatus.forbidden, {'error': 'pairing_closed'});
      return;
    }
    if (++_pairAttempts > 5) {
      _pairing = null;
      await _json(request.response, HttpStatus.forbidden, {'error': 'pairing_closed'});
      return;
    }

    final body = await _readBody(request);
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      await _json(request.response, HttpStatus.badRequest, {'error': 'bad_request'});
      return;
    }

    final username = decoded['username'];
    final deviceId = decoded['deviceId'];
    final deviceName = decoded['deviceName'];
    final guestFingerprint = decoded['fingerprint'];
    final guestPort = decoded['port'];
    final mac = decoded['mac'];
    final keyData = decoded['key'];
    if (username is! String ||
        deviceId is! String ||
        deviceName is! String ||
        guestFingerprint is! String ||
        mac is! String ||
        keyData is! Map ||
        deviceId == identity.deviceId ||
        !_validFingerprint(guestFingerprint)) {
      await _json(request.response, HttpStatus.badRequest, {'error': 'bad_request'});
      return;
    }

    final pairingKey = await PairingCrypto.derivePairingKey(
      code: active.code,
      hostFingerprint: _fingerprint,
      guestFingerprint: guestFingerprint,
      username: identity.username,
    );
    final message = PairingCrypto.pairRequestMessage(
      hostFingerprint: _fingerprint,
      guestFingerprint: guestFingerprint,
      username: identity.username,
      guestDeviceId: deviceId,
    );
    if (username.trim().toLowerCase() != identity.username.toLowerCase() ||
        !await PairingCrypto.verifyHmac(pairingKey, message, mac)) {
      await _json(request.response, HttpStatus.forbidden, {'error': 'pairing_rejected'});
      return;
    }

    final String sharedKey;
    try {
      sharedKey = await PairingCrypto.decryptSharedKey(
        pairingKeyBase64: pairingKey,
        payload: EncryptedPayload.fromJson(Map<String, Object?>.from(keyData)),
      );
      if (base64Decode(sharedKey).length != 32) {
        throw const FormatException('Shared key must be 32 bytes');
      }
    } on Object {
      await _json(request.response, HttpStatus.forbidden, {'error': 'pairing_rejected'});
      return;
    }

    final now = _clock().toUtc();
    final remoteHost = request.connectionInfo?.remoteAddress.address ?? '';
    final paired = PairedDevice(
      id: deviceId,
      name: deviceName.trim(),
      username: username.trim(),
      certificateFingerprint: guestFingerprint,
      sharedKey: sharedKey,
      host: remoteHost,
      port: guestPort is int ? guestPort : 0,
      lastSeenAt: now,
      createdAt: now,
      updatedAt: now,
    );
    await _repository.savePairedDevice(paired);
    _pairing = null;
    _pairAttempts = 0;

    final ack = await PairingCrypto.hmacBase64(
      sharedKey,
      PairingCrypto.pairAckMessage(hostFingerprint: _fingerprint, guestFingerprint: guestFingerprint),
    );
    _pairedEvents.add(paired);
    await _json(request.response, HttpStatus.ok, {
      'ok': true,
      'mac': ack,
      'deviceId': identity.deviceId,
      'deviceName': identity.deviceName,
      'username': identity.username,
      'fingerprint': _fingerprint,
      'port': port,
    });
  }

  Future<void> _handleQuery(HttpRequest request) async {
    final identity = _identity;
    if (identity == null) {
      await _json(request.response, HttpStatus.serviceUnavailable, {'error': 'not_ready'});
      return;
    }

    final deviceId = request.headers.value('x-mane-device');
    final timestampRaw = request.headers.value('x-mane-timestamp');
    final nonce = request.headers.value('x-mane-nonce');
    final signature = request.headers.value('x-mane-signature');
    if (deviceId == null || timestampRaw == null || nonce == null || signature == null) {
      await _json(request.response, HttpStatus.unauthorized, {'error': 'unauthorized'});
      return;
    }
    final timestamp = int.tryParse(timestampRaw);
    if (timestamp == null) {
      await _json(request.response, HttpStatus.unauthorized, {'error': 'unauthorized'});
      return;
    }
    final now = _clock().toUtc();
    final requestTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
    if (now.difference(requestTime).abs() > const Duration(minutes: 5)) {
      await _json(request.response, HttpStatus.unauthorized, {'error': 'stale'});
      return;
    }

    final devices = await _repository.readPairedDevices();
    PairedDevice? paired;
    for (final device in devices) {
      if (device.id == deviceId) {
        paired = device;
        break;
      }
    }
    if (paired == null) {
      await _json(request.response, HttpStatus.unauthorized, {'error': 'unauthorized'});
      return;
    }

    final valid = await PairingCrypto.verifyRequest(
      sharedKeyBase64: paired.sharedKey,
      method: request.method,
      path: '${request.uri.path}?${request.uri.query}',
      timestamp: timestamp,
      nonce: nonce,
      body: '',
      signatureBase64: signature,
    );
    if (!valid) {
      await _json(request.response, HttpStatus.unauthorized, {'error': 'unauthorized'});
      return;
    }
    if (!_acceptNonce(deviceId, nonce, now)) {
      await _json(request.response, HttpStatus.unauthorized, {'error': 'replay'});
      return;
    }

    final query = request.uri.queryParameters;
    final timeZone = query['timeZone'] ?? _deviceTimeZone();
    if (!isKnownTimeZone(timeZone)) {
      await _json(request.response, HttpStatus.badRequest, {'error': 'bad_timezone'});
      return;
    }
    final today = localDateAt(now, timeZone);

    try {
      final Object? data = await _resource(query['resource'] ?? 'summary', query, timeZone, today);
      await _json(request.response, HttpStatus.ok, {
        'deviceId': identity.deviceId,
        'deviceName': identity.deviceName,
        'generatedAt': now.toIso8601String(),
        'data': data,
      });
    } on ArgumentError {
      await _json(request.response, HttpStatus.badRequest, {'error': 'bad_request'});
    }
  }

  Future<Object?> _resource(
    String resource,
    Map<String, String> query,
    String timeZone,
    LocalDate today,
  ) async {
    switch (resource) {
      case 'summary':
        return SyncPayloads.summary(repository: _repository, now: _clock(), timeZone: timeZone);
      case 'snapshot':
        return SyncPayloads.fullSnapshot(repository: _repository, now: _clock(), timeZone: timeZone);
      case 'spaces':
        return [for (final space in await _repository.watchSpaces().first) SyncPayloads.spaceJson(space)];
      case 'tags':
        return [for (final tag in await _repository.watchTags().first) SyncPayloads.tagJson(tag)];
      case 'home':
        return [for (final item in await _repository.watchHomeItems().first) SyncPayloads.homeItemJson(item)];
      case 'shopping':
        return [
          for (final item in await _repository.watchShoppingItems().first)
            SyncPayloads.shoppingItemJson(item),
        ];
      case 'entries':
        final range = _range(query, today);
        final entries = await _repository.loadEntries(range.$1, range.$2, timeZone);
        return [for (final entry in entries) SyncPayloads.occurrenceJson(entry)];
      case 'shifts':
        final range = _range(query, today);
        final shifts = await _repository.watchShifts(range.$1, range.$2, timeZone).first;
        return [for (final shift in shifts) SyncPayloads.shiftJson(shift)];
      default:
        throw ArgumentError.value(resource, 'resource', 'unknown resource');
    }
  }

  (LocalDate, LocalDate) _range(Map<String, String> query, LocalDate today) {
    final start = _dateOrNull(query['start']) ?? today;
    final end = _dateOrNull(query['end']) ?? start;
    if (end.isBefore(start) || end.differenceInDays(start) > 366) {
      throw ArgumentError('Invalid date range');
    }
    return (start, end);
  }

  static LocalDate? _dateOrNull(String? value) {
    if (value == null) return null;
    try {
      return LocalDate.parse(value);
    } on FormatException {
      return null;
    }
  }

  bool _acceptNonce(String deviceId, String nonce, DateTime now) {
    if (nonce.length < 8 || nonce.length > 128) return false;
    final seen = _nonces[deviceId] ??= <String, DateTime>{};
    seen.removeWhere((_, expires) => now.isAfter(expires));
    if (seen.containsKey(nonce)) return false;
    seen[nonce] = now.add(const Duration(minutes: 5));
    return true;
  }

  static bool _validFingerprint(String value) => RegExp(r'^[0-9a-f]{64}$').hasMatch(value);

  Future<String> _readBody(HttpRequest request) async {
    final builder = BytesBuilder(copy: false);
    await for (final chunk in request) {
      builder.add(chunk);
      if (builder.length > 1024 * 1024) {
        throw const LanServerException('Request too large');
      }
    }
    return utf8.decode(builder.takeBytes());
  }

  Future<void> _json(HttpResponse response, int status, Object body) async {
    response.statusCode = status;
    response.headers.contentType = ContentType.json;
    response.write(jsonEncode(body));
    await response.close();
  }
}

class _ActivePairing {
  const _ActivePairing({required this.code, required this.expiresAt});

  final String code;
  final DateTime expiresAt;
}

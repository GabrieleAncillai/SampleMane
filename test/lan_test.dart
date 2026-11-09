import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/features/sync/device_certificate.dart';
import 'package:mane/features/sync/lan_client.dart';
import 'package:mane/features/sync/lan_server.dart';
import 'package:mane/features/sync/pairing_crypto.dart';
import 'package:mane/models/local_identity.dart';
import 'package:mane/models/paired_device.dart';
import 'package:mane/services/app_database.dart';
import 'package:mane/services/planner_repository.dart';
import 'package:mane_core/mane_core.dart';
import 'package:sqlite3/open.dart';

void main() {
  late LocalIdentity hostIdentity;
  late LocalIdentity guestIdentity;
  final now = DateTime.utc(2026, 11, 9, 12);
  late AppDatabase hostDb;
  late AppDatabase guestDb;
  late LanServer server;
  late LanClient client;

  setUpAll(() async {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('libsqlite3.so.0'));
    initializeTimeZones();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    hostIdentity = await _identity('host', 'Host', 'tester');
    guestIdentity = await _identity('guest', 'Phone', 'tester');
  });

  setUp(() async {
    hostDb = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    guestDb = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    await hostDb.seedDefaults();
    await hostDb.saveEntry(
      Entry(
        id: 'passport',
        spaceId: 'personal',
        title: 'Renew passport',
        date: LocalDate.parse('2026-11-09'),
        allDay: true,
        createdAt: now,
        updatedAt: now,
      ),
    );
    server = LanServer(
      repository: PlannerRepository(hostDb),
      deviceTimeZone: () => 'Europe/Madrid',
      clock: () => now,
    );
    await server.start(identity: hostIdentity, address: InternetAddress.loopbackIPv4);
    client = LanClient(PlannerRepository(guestDb), clock: () => now);
  });

  tearDown(() async {
    await server.dispose();
    await hostDb.close();
    await guestDb.close();
  });

  Future<PairedDevice> pairHost({String? code}) async {
    final session = code == null ? server.beginPairing() : null;
    final host = await client.pair(
      identity: guestIdentity,
      myFingerprint: fingerprintOfPemSync(guestIdentity.certificatePem),
      host: '127.0.0.1',
      port: server.port,
      code: code ?? session!.code,
      myServerPort: 0,
    );
    return host;
  }

  test('pairs two devices and answers an authenticated summary', () async {
    final host = await pairHost();
    expect(host.name, 'Host');
    expect(host.host, '127.0.0.1');
    expect(host.port, server.port);

    final hostSide = (await hostDb.readPairedDevices()).single;
    expect(hostSide.id, 'guest');
    expect(hostSide.certificateFingerprint, fingerprintOfPemSync(guestIdentity.certificatePem));
    expect(hostSide.sharedKey, host.sharedKey);

    final summary = await client.summary(host, localDeviceId: guestIdentity.deviceId);
    expect(summary['date'], '2026-11-09');
    final today = Map<String, Object?>.from(summary['today'] as Map);
    final entries = (today['entries'] as List).cast<Map<String, Object?>>();
    expect(entries.single['entry'], isA<Map>());
    expect((entries.single['entry'] as Map)['title'], 'Renew passport');
    expect(summary['openShopping'], 0);
  });

  test('rejects a wrong pairing code and stores nothing', () async {
    var session = server.beginPairing();
    while (session.code == '000000') {
      session = server.beginPairing();
    }
    await expectLater(
      client.pair(
        identity: guestIdentity,
        myFingerprint: fingerprintOfPemSync(guestIdentity.certificatePem),
        host: '127.0.0.1',
        port: server.port,
        code: '000000',
        myServerPort: 0,
      ),
      throwsA(isA<LanClientException>()),
    );
    expect(await hostDb.readPairedDevices(), isEmpty);
    expect(await guestDb.readPairedDevices(), isEmpty);
  });

  test('answers each signed request once and rejects a replay', () async {
    final host = await pairHost();
    final path = Uri(path: '/mane/v1/query', queryParameters: {'resource': 'summary'}).toString();
    final timestamp = now.millisecondsSinceEpoch ~/ 1000;
    const nonce = 'replay-test-nonce';
    final signature = await PairingCrypto.signRequest(
      sharedKeyBase64: host.sharedKey,
      method: 'GET',
      path: path,
      timestamp: timestamp,
      nonce: nonce,
      body: '',
    );

    Future<int> send() async {
      final raw = HttpClient()..badCertificateCallback = (certificate, host, port) => true;
      try {
        final request = await raw.getUrl(
          Uri(
            scheme: 'https',
            host: '127.0.0.1',
            port: server.port,
            path: '/mane/v1/query',
            queryParameters: {'resource': 'summary'},
          ),
        );
        request.headers.set('x-mane-device', guestIdentity.deviceId);
        request.headers.set('x-mane-timestamp', '$timestamp');
        request.headers.set('x-mane-nonce', nonce);
        request.headers.set('x-mane-signature', signature);
        final response = await request.close();
        await response.drain<void>();
        return response.statusCode;
      } finally {
        raw.close(force: true);
      }
    }

    expect(await send(), HttpStatus.ok);
    expect(await send(), HttpStatus.unauthorized);
  });

  test('rejects a query signed with another key', () async {
    final host = await pairHost();
    final tampered = host.copyWith(sharedKey: PairingCrypto.randomBase64(32));
    await expectLater(
      client.summary(tampered, localDeviceId: guestIdentity.deviceId),
      throwsA(isA<LanClientException>()),
    );
  });

  test('pins the certificate and refuses a different one', () async {
    final host = await pairHost();
    final tampered = host.copyWith(certificateFingerprint: '0' * 64);
    await expectLater(
      client.summary(tampered, localDeviceId: guestIdentity.deviceId),
      throwsA(isA<LanClientException>()),
    );
  });

  test('reports an offline device without touching local data', () async {
    final host = (await pairHost()).copyWith(port: 1);
    await expectLater(
      client.summary(host, localDeviceId: guestIdentity.deviceId),
      throwsA(isA<LanClientException>()),
    );
    final local = await hostDb
        .watchEntriesBetween(LocalDate.parse('2026-11-09'), LocalDate.parse('2026-11-09'), 'Europe/Madrid')
        .first;
    expect(local.single.entry.title, 'Renew passport');
  });
}

Future<LocalIdentity> _identity(String id, String name, String username) async {
  final certificate = await generateDeviceCertificate(deviceId: id);
  final now = DateTime.utc(2026, 11, 9, 8);
  return LocalIdentity(
    deviceId: id,
    deviceName: name,
    username: username,
    pinSalt: 'c2FsdA==',
    pinHash: 'aGFzaA==',
    certificatePem: certificate.certificatePem,
    privateKeyPem: certificate.privateKeyPem,
    mcpToken: 'token-$id',
    createdAt: now,
    updatedAt: now,
  );
}

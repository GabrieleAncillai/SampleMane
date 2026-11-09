import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/features/sync/device_certificate.dart';
import 'package:mane/features/sync/identity_service.dart';
import 'package:mane/features/sync/lan_client.dart';
import 'package:mane/features/sync/lan_server.dart';
import 'package:mane/features/sync/pairing_crypto.dart';
import 'package:mane/features/sync/peer_discovery.dart';
import 'package:mane/features/sync/sync_service.dart';
import 'package:mane/models/local_identity.dart';
import 'package:mane/models/paired_device.dart';
import 'package:mane/services/app_database.dart';
import 'package:mane/services/planner_repository.dart';
import 'package:mane_core/mane_core.dart';
import 'package:sqlite3/open.dart';

void main() {
  late LocalIdentity hostIdentity;
  late LocalIdentity guestIdentity;
  late AppDatabase hostDb;
  late AppDatabase guestDb;
  late LanServer hostServer;
  late SyncService service;
  late _FakeDiscovery discovery;
  final now = DateTime.utc(2026, 11, 9, 12);

  setUpAll(() async {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('libsqlite3.so.0'));
    initializeTimeZones();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    hostIdentity = await _identity('host', 'Host');
    guestIdentity = await _identity('guest', 'Phone');
  });

  setUp(() async {
    hostDb = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    guestDb = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    await hostDb.seedDefaults();
    await guestDb.seedDefaults();
    await guestDb.saveIdentity(guestIdentity);
    await guestDb.saveEntry(
      Entry(
        id: 'local',
        spaceId: 'home',
        title: 'Local plan',
        date: LocalDate.parse('2026-11-09'),
        allDay: true,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await hostDb.saveEntry(
      Entry(
        id: 'remote',
        spaceId: 'personal',
        title: 'Remote plan',
        date: LocalDate.parse('2026-11-09'),
        allDay: true,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final sharedKey = PairingCrypto.newSharedKey();
    hostServer = LanServer(
      repository: PlannerRepository(hostDb),
      deviceTimeZone: () => 'Europe/Madrid',
      clock: () => now,
    );
    await hostServer.start(identity: hostIdentity, address: InternetAddress.loopbackIPv4);
    await hostDb.savePairedDevice(
      PairedDevice(
        id: guestIdentity.deviceId,
        name: guestIdentity.deviceName,
        username: guestIdentity.username,
        certificateFingerprint: fingerprintOfPemSync(guestIdentity.certificatePem),
        sharedKey: sharedKey,
        host: '127.0.0.1',
        port: 0,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await guestDb.savePairedDevice(
      PairedDevice(
        id: hostIdentity.deviceId,
        name: hostIdentity.deviceName,
        username: hostIdentity.username,
        certificateFingerprint: fingerprintOfPemSync(hostIdentity.certificatePem),
        sharedKey: sharedKey,
        host: '127.0.0.1',
        port: hostServer.port,
        lastSeenAt: now,
        createdAt: now,
        updatedAt: now,
      ),
    );

    discovery = _FakeDiscovery();
    service = SyncService(
      repository: PlannerRepository(guestDb),
      identityService: IdentityService(PlannerRepository(guestDb)),
      client: LanClient(PlannerRepository(guestDb), clock: () => now),
      server: LanServer(
        repository: PlannerRepository(guestDb),
        deviceTimeZone: () => 'Europe/Madrid',
        clock: () => now,
      ),
      discovery: discovery,
      clock: () => now,
    );
  });

  tearDown(() async {
    await service.close();
    await hostServer.dispose();
    await hostDb.close();
    await guestDb.close();
  });

  test('starts the server, discovers a peer and refreshes its snapshot', () async {
    await service.start();
    expect(service.state.value.running, isTrue);
    expect(service.state.value.port, greaterThan(0));
    expect(discovery.started, isTrue);
    expect(service.state.value.snapshots[hostIdentity.deviceId]!.todayEntries, contains('Remote plan'));

    discovery.emit(
      DiscoveredPeer(
        deviceId: hostIdentity.deviceId,
        deviceName: hostIdentity.deviceName,
        username: hostIdentity.username,
        fingerprint: fingerprintOfPemSync(hostIdentity.certificatePem),
        host: '127.0.0.1',
        port: hostServer.port,
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(service.state.value.discovered.map((peer) => peer.deviceId), contains(hostIdentity.deviceId));

    await service.stop();
    expect(service.state.value.running, isFalse);
    expect(discovery.stopped, isTrue);
  });

  test('keeps the local plan when the peer is offline', () async {
    await service.start();
    await hostServer.stop();
    await service.refresh();
    expect(service.state.value.deviceErrors[hostIdentity.deviceId], isNotNull);
    final local = await guestDb
        .watchEntriesBetween(LocalDate.parse('2026-11-09'), LocalDate.parse('2026-11-09'), 'Europe/Madrid')
        .first;
    expect(local.single.entry.title, 'Local plan');
  });

  test('reports a missing identity without failing', () async {
    await guestDb.customSelect('DELETE FROM identity_records').get();
    final empty = SyncService(
      repository: PlannerRepository(guestDb),
      identityService: IdentityService(PlannerRepository(guestDb)),
      client: LanClient(PlannerRepository(guestDb), clock: () => now),
      server: LanServer(
        repository: PlannerRepository(guestDb),
        deviceTimeZone: () => 'Europe/Madrid',
        clock: () => now,
      ),
      discovery: _FakeDiscovery(),
      clock: () => now,
    );
    await empty.start();
    expect(empty.state.value.running, isFalse);
    expect(empty.state.value.error, 'identity_required');
    await empty.close();
  });
}

class _FakeDiscovery implements PeerDiscovery {
  final _peers = StreamController<DiscoveredPeer>.broadcast();
  bool started = false;
  bool stopped = false;

  @override
  Stream<DiscoveredPeer> get peers => _peers.stream;

  @override
  Future<void> start({required LocalIdentity identity, required int port}) async {
    started = true;
  }

  @override
  Future<void> stop() async {
    stopped = true;
  }

  @override
  Future<void> dispose() => _peers.close();

  void emit(DiscoveredPeer peer) => _peers.add(peer);
}

Future<LocalIdentity> _identity(String id, String name) async {
  final certificate = await generateDeviceCertificate(deviceId: id);
  final now = DateTime.utc(2026, 11, 9, 8);
  return LocalIdentity(
    deviceId: id,
    deviceName: name,
    username: 'tester',
    pinSalt: 'c2FsdA==',
    pinHash: 'aGFzaA==',
    certificatePem: certificate.certificatePem,
    privateKeyPem: certificate.privateKeyPem,
    mcpToken: 'token-$id',
    createdAt: now,
    updatedAt: now,
  );
}

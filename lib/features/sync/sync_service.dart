import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../models/local_identity.dart';
import '../../models/paired_device.dart';
import '../../models/remote_snapshot.dart';
import '../../services/planner_repository.dart';
import 'device_certificate.dart';
import 'identity_service.dart';
import 'lan_client.dart';
import 'lan_server.dart';
import 'peer_discovery.dart';

class SyncState {
  const SyncState({
    this.running = false,
    this.discoveryAvailable = false,
    this.port = 0,
    this.lastRefresh,
    this.error,
    this.snapshots = const <String, RemoteSnapshot>{},
    this.deviceErrors = const <String, String>{},
    this.discovered = const <DiscoveredPeer>[],
  });

  final bool running;
  final bool discoveryAvailable;
  final int port;
  final DateTime? lastRefresh;
  final String? error;
  final Map<String, RemoteSnapshot> snapshots;
  final Map<String, String> deviceErrors;
  final List<DiscoveredPeer> discovered;
}

/// Starts the LAN server, advertises over mDNS, discovers peers and refreshes
/// read-only snapshots. A failure never touches the local plan.
class SyncService {
  SyncService({
    required PlannerRepository repository,
    required IdentityService identityService,
    required LanClient client,
    required LanServer server,
    required PeerDiscovery discovery,
    DateTime Function()? clock,
  }) : _repository = repository,
       _identityService = identityService,
       _client = client,
       _server = server,
       _discovery = discovery,
       _clock = clock ?? DateTime.now;

  final PlannerRepository _repository;
  final IdentityService _identityService;
  final LanClient _client;
  final LanServer _server;
  final PeerDiscovery _discovery;
  final DateTime Function() _clock;

  final ValueNotifier<SyncState> state = ValueNotifier(const SyncState());

  LocalIdentity? _identity;
  bool _running = false;
  bool _discoveryAvailable = false;
  int _port = 0;
  DateTime? _lastRefresh;
  String? _error;
  final Map<String, RemoteSnapshot> _snapshots = {};
  final Map<String, String> _deviceErrors = {};
  List<DiscoveredPeer> _discovered = const [];
  final Map<String, DateTime> _lastQueried = {};
  Timer? _timer;
  StreamSubscription<DiscoveredPeer>? _peerSubscription;
  StreamSubscription<PairedDevice>? _pairedSubscription;

  LocalIdentity? get identity => _identity;

  Future<void> start() async {
    if (_running) return;
    await _restoreSnapshots();
    final identity = await _identityService.read();
    _identity = identity;
    if (identity == null) {
      _error = 'identity_required';
      _emit();
      return;
    }
    try {
      _port = await _server.start(identity: identity);
      _running = true;
      _error = null;
      _pairedSubscription ??= _server.pairedDevices.listen(_onPaired);
      _emit();
      await _startDiscovery(identity);
      await refresh();
      _timer ??= Timer.periodic(const Duration(minutes: 5), (_) => refresh());
    } catch (error) {
      _running = false;
      _error = '$error';
      _emit();
    }
  }

  Future<void> _startDiscovery(LocalIdentity identity) async {
    try {
      await _discovery.start(identity: identity, port: _port);
      _discoveryAvailable = true;
      _peerSubscription = _discovery.peers.listen(_onPeer);
    } catch (error) {
      _discoveryAvailable = false;
      _error = 'Discovery unavailable: $error';
    }
    _emit();
  }

  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
    await _peerSubscription?.cancel();
    _peerSubscription = null;
    await _pairedSubscription?.cancel();
    _pairedSubscription = null;
    try {
      await _discovery.stop();
    } catch (_) {
      // The platform daemon may already be gone; stopping is best effort.
    }
    await _server.stop();
    _running = false;
    _discovered = const [];
    _emit();
  }

  Future<void> restart() async {
    await stop();
    await start();
  }

  Future<void> refresh() async {
    final devices = await _repository.readPairedDevices();
    for (final device in devices) {
      await _refreshDevice(device);
    }
    _lastRefresh = _clock().toUtc();
    _emit();
  }

  Future<void> refreshDevice(String id) async {
    final devices = await _repository.readPairedDevices();
    for (final device in devices) {
      if (device.id == id) {
        await _refreshDevice(device);
        _emit();
        return;
      }
    }
  }

  Future<void> _refreshDevice(PairedDevice device) async {
    final identity = _identity;
    if (identity == null) {
      _deviceErrors[device.id] = 'identity_required';
      return;
    }
    if (device.host.isEmpty || device.port <= 0) {
      _deviceErrors[device.id] = 'No address yet';
      return;
    }
    try {
      final data = await _client.snapshot(device, localDeviceId: identity.deviceId);
      final fetchedAt = _clock().toUtc();
      final snapshot = RemoteSnapshot.fromPayload(
        deviceId: device.id,
        deviceName: device.name,
        fetchedAt: fetchedAt,
        data: data,
      );
      _snapshots[device.id] = snapshot;
      await _repository.saveRemoteSnapshot(snapshot);
      _deviceErrors.remove(device.id);
      await _repository.updatePairedDevicePresence(
        device.id,
        host: device.host,
        port: device.port,
        seenAt: fetchedAt,
      );
      _lastQueried[device.id] = fetchedAt;
    } catch (error) {
      _deviceErrors[device.id] = '$error';
    }
  }

  Future<void> _onPaired(PairedDevice device) async {
    await _refreshDevice(device);
    _emit();
  }

  Future<void> _onPeer(DiscoveredPeer peer) async {
    _discovered = [
      for (final existing in _discovered)
        if (existing.deviceId != peer.deviceId) existing,
      peer,
    ];
    _emit();

    final devices = await _repository.readPairedDevices();
    PairedDevice? paired;
    for (final device in devices) {
      if (device.id == peer.deviceId) {
        paired = device;
        break;
      }
    }
    if (paired == null) return;

    final now = _clock().toUtc();
    await _repository.updatePairedDevicePresence(
      peer.deviceId,
      host: peer.host,
      port: peer.port,
      seenAt: now,
    );
    final last = _lastQueried[peer.deviceId];
    if (last != null && now.difference(last) < const Duration(seconds: 20)) return;
    await _refreshDevice(paired.copyWith(host: peer.host, port: peer.port));
    _emit();
  }

  Future<PairingSession> beginPairing() async {
    final identity = await _ensureIdentity();
    await _ensureServer(identity);
    return _server.beginPairing();
  }

  void cancelPairing() => _server.cancelPairing();

  Future<PairedDevice> pairWithPeer({required String host, required int port, required String code}) async {
    final identity = await _ensureIdentity();
    await _ensureServer(identity);
    final fingerprint = await fingerprintOfCertificatePem(identity.certificatePem);
    final paired = await _client.pair(
      identity: identity,
      myFingerprint: fingerprint,
      host: host,
      port: port,
      code: code,
      myServerPort: _port,
    );
    await _refreshDevice(paired);
    _emit();
    return paired;
  }

  Future<void> unpair(String id) async {
    await _repository.removePairedDevice(id);
    await _repository.deleteRemoteSnapshot(id);
    _snapshots.remove(id);
    _deviceErrors.remove(id);
    _lastQueried.remove(id);
    _emit();
  }

  /// Restores the last read-only snapshots and drops rows for devices that are
  /// no longer paired. Remote data is never merged into the local plan.
  Future<void> _restoreSnapshots() async {
    try {
      final devices = await _repository.readPairedDevices();
      final ids = {for (final device in devices) device.id};
      await _repository.pruneRemoteSnapshots(ids);
      final stored = await _repository.readRemoteSnapshots();
      _snapshots
        ..clear()
        ..addEntries(stored.map((snapshot) => MapEntry(snapshot.deviceId, snapshot)));
      _emit();
    } catch (_) {
      // A snapshot is display data; a failure must not block LAN startup.
    }
  }

  Future<LocalIdentity> _ensureIdentity() async {
    final identity = _identity ?? await _identityService.read();
    if (identity == null) throw const IdentityException('Set a username and PIN first');
    _identity = identity;
    return identity;
  }

  Future<void> _ensureServer(LocalIdentity identity) async {
    if (_port == 0) {
      _port = await _server.start(identity: identity);
      _running = true;
      _emit();
    }
  }

  Stream<PairedDevice> get pairedEvents => _server.pairedDevices;

  void dispose() {
    unawaited(close());
  }

  Future<void> close() async {
    await stop();
    await _server.dispose();
    state.dispose();
  }

  void _emit() {
    state.value = SyncState(
      running: _running,
      discoveryAvailable: _discoveryAvailable,
      port: _port,
      lastRefresh: _lastRefresh,
      error: _error,
      snapshots: Map.unmodifiable(_snapshots),
      deviceErrors: Map.unmodifiable(_deviceErrors),
      discovered: List.unmodifiable(_discovered),
    );
  }
}

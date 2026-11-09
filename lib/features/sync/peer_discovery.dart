import 'dart:async';

import 'package:bonsoir/bonsoir.dart';

import '../../models/local_identity.dart';
import 'device_certificate.dart';

class DiscoveredPeer {
  const DiscoveredPeer({
    required this.deviceId,
    required this.deviceName,
    required this.username,
    required this.fingerprint,
    required this.host,
    required this.port,
  });

  final String deviceId;
  final String deviceName;
  final String username;
  final String fingerprint;
  final String host;
  final int port;
}

abstract class PeerDiscovery {
  Stream<DiscoveredPeer> get peers;

  Future<void> start({required LocalIdentity identity, required int port});

  Future<void> stop();

  Future<void> dispose();
}

/// mDNS/DNS-SD advertisement and discovery through Bonsoir.
///
/// The plugin uses Android NSD, Apple Bonjour, Windows DNS-SD and Avahi on
/// Linux. Discovery is best effort: manual host and port pairing stays
/// available when the platform daemon is missing.
class BonsoirPeerDiscovery implements PeerDiscovery {
  static const serviceType = '_mane._tcp';

  final _peers = StreamController<DiscoveredPeer>.broadcast();
  BonsoirBroadcast? _broadcast;
  BonsoirDiscovery? _discovery;
  StreamSubscription<BonsoirDiscoveryEvent>? _subscription;
  String? _selfId;

  @override
  Stream<DiscoveredPeer> get peers => _peers.stream;

  @override
  Future<void> start({required LocalIdentity identity, required int port}) async {
    _selfId = identity.deviceId;
    final fingerprint = await fingerprintOfCertificatePem(identity.certificatePem);
    final service = BonsoirService(
      name: identity.deviceName,
      type: serviceType,
      port: port,
      attributes: {'id': identity.deviceId, 'user': identity.username, 'fp': fingerprint},
    );

    final broadcast = BonsoirBroadcast(service: service, printLogs: false);
    await broadcast.initialize();
    await broadcast.start();
    _broadcast = broadcast;

    final discovery = BonsoirDiscovery(type: serviceType, printLogs: false);
    await discovery.initialize();
    _subscription = discovery.eventStream?.listen(_onEvent);
    await discovery.start();
    _discovery = discovery;
  }

  void _onEvent(BonsoirDiscoveryEvent event) {
    if (event is BonsoirDiscoveryServiceFoundEvent) {
      final discovery = _discovery;
      if (discovery == null) return;
      unawaited(discovery.serviceResolver.resolveService(event.service).catchError((Object _) {}));
      return;
    }
    if (event is! BonsoirDiscoveryServiceResolvedEvent) return;
    final service = event.service;
    final deviceId = service.attributes['id'];
    final host = service.host;
    if (deviceId == null || deviceId == _selfId || host == null || host.isEmpty) return;
    _peers.add(
      DiscoveredPeer(
        deviceId: deviceId,
        deviceName: service.attributes['name'] ?? service.name,
        username: service.attributes['user'] ?? '',
        fingerprint: service.attributes['fp'] ?? '',
        host: host,
        port: service.port,
      ),
    );
  }

  @override
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    await _discovery?.stop();
    _discovery = null;
    await _broadcast?.stop();
    _broadcast = null;
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _peers.close();
  }
}

/// One device paired with this one.
///
/// [certificateFingerprint] pins the peer's TLS certificate; [sharedKey] is a
/// random 32-byte key exchanged during pairing and used to sign requests.
/// Pairing material is never included in backups.
class PairedDevice {
  const PairedDevice({
    required this.id,
    required this.name,
    required this.username,
    required this.certificateFingerprint,
    required this.sharedKey,
    this.host = '',
    this.port = 0,
    this.lastSeenAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String username;
  final String certificateFingerprint;

  /// Base64-encoded 32-byte secret.
  final String sharedKey;

  final String host;
  final int port;
  final DateTime? lastSeenAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  PairedDevice copyWith({
    String? name,
    String? username,
    String? certificateFingerprint,
    String? sharedKey,
    String? host,
    int? port,
    DateTime? lastSeenAt,
    DateTime? updatedAt,
  }) => PairedDevice(
    id: id,
    name: name ?? this.name,
    username: username ?? this.username,
    certificateFingerprint: certificateFingerprint ?? this.certificateFingerprint,
    sharedKey: sharedKey ?? this.sharedKey,
    host: host ?? this.host,
    port: port ?? this.port,
    lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

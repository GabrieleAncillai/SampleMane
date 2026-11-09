/// This device's local pairing identity.
///
/// The PIN is stored only as a salted PBKDF2 hash. The TLS private key, the MCP
/// token and every paired-device shared key are device-local security material:
/// they are deliberately excluded from JSON backups.
class LocalIdentity {
  const LocalIdentity({
    required this.deviceId,
    required this.deviceName,
    required this.username,
    required this.pinSalt,
    required this.pinHash,
    required this.certificatePem,
    required this.privateKeyPem,
    required this.mcpToken,
    required this.createdAt,
    required this.updatedAt,
  });

  final String deviceId;
  final String deviceName;
  final String username;
  final String pinSalt;
  final String pinHash;
  final String certificatePem;
  final String privateKeyPem;
  final String mcpToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  LocalIdentity copyWith({
    String? deviceName,
    String? username,
    String? pinSalt,
    String? pinHash,
    String? certificatePem,
    String? privateKeyPem,
    String? mcpToken,
    DateTime? updatedAt,
  }) => LocalIdentity(
    deviceId: deviceId,
    deviceName: deviceName ?? this.deviceName,
    username: username ?? this.username,
    pinSalt: pinSalt ?? this.pinSalt,
    pinHash: pinHash ?? this.pinHash,
    certificatePem: certificatePem ?? this.certificatePem,
    privateKeyPem: privateKeyPem ?? this.privateKeyPem,
    mcpToken: mcpToken ?? this.mcpToken,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

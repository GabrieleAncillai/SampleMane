import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// PIN hashing, pairing-key derivation, payload encryption and request
/// signatures.
///
/// The PIN itself never leaves the device. It is stored as a salted PBKDF2
/// hash and only checked locally before a pairing or settings action. Pairing
/// uses a short-lived code shown on the host plus both TLS certificate
/// fingerprints; the long-lived shared key is random and is transported inside
/// AES-GCM under a key derived from that code.
abstract final class PairingCrypto {
  static const pinIterations = 210000;
  static const pairingIterations = 150000;

  static final _random = Random.secure();

  static Uint8List randomBytes(int length) =>
      Uint8List.fromList(List<int>.generate(length, (_) => _random.nextInt(256)));

  static String randomBase64(int length) => base64Encode(randomBytes(length));

  static String newPinSalt() => randomBase64(16);

  /// A six-digit code, displayed grouped as `123 456`.
  static String newPairingCode() => _random.nextInt(1000000).toString().padLeft(6, '0');

  static String newSharedKey() => randomBase64(32);

  static String newMcpToken() => randomBase64(24);

  static Future<String> hashPin(
    String pin, {
    required String saltBase64,
    int iterations = pinIterations,
  }) async {
    final key = await Pbkdf2.hmacSha256(
      iterations: iterations,
      bits: 256,
    ).deriveKeyFromPassword(password: pin, nonce: base64Decode(saltBase64));
    return base64Encode(await key.extractBytes());
  }

  /// Compares two byte sequences without an early exit.
  static bool constantTimeEquals(List<int> first, List<int> second) {
    if (first.length != second.length) return false;
    var difference = 0;
    for (var index = 0; index < first.length; index++) {
      difference |= first[index] ^ second[index];
    }
    return difference == 0;
  }

  static Future<bool> verifyPin({
    required String pin,
    required String saltBase64,
    required String expectedHashBase64,
    int iterations = pinIterations,
  }) async {
    final actual = await hashPin(pin, saltBase64: saltBase64, iterations: iterations);
    return constantTimeEquals(base64Decode(actual), base64Decode(expectedHashBase64));
  }

  static Future<String> hmacBase64(String keyBase64, String message) async {
    final mac = await Hmac.sha256().calculateMac(
      utf8.encode(message),
      secretKey: SecretKey(base64Decode(keyBase64)),
    );
    return base64Encode(mac.bytes);
  }

  static Future<bool> verifyHmac(String keyBase64, String message, String expectedMacBase64) async {
    final actual = await hmacBase64(keyBase64, message);
    return constantTimeEquals(base64Decode(actual), base64Decode(expectedMacBase64));
  }

  /// Derives the short-lived pairing key from the displayed code and both
  /// certificate fingerprints. Binding both fingerprints prevents a
  /// man-in-the-middle from completing the handshake with a different cert.
  static Future<String> derivePairingKey({
    required String code,
    required String hostFingerprint,
    required String guestFingerprint,
    required String username,
    int iterations = pairingIterations,
  }) async {
    final salt = utf8.encode('mane-pair|$hostFingerprint|$guestFingerprint|$username');
    final key = await Pbkdf2.hmacSha256(
      iterations: iterations,
      bits: 256,
    ).deriveKeyFromPassword(password: code, nonce: salt);
    return base64Encode(await key.extractBytes());
  }

  static String pairRequestMessage({
    required String hostFingerprint,
    required String guestFingerprint,
    required String username,
    required String guestDeviceId,
  }) => 'pair|$hostFingerprint|$guestFingerprint|$username|$guestDeviceId';

  static String pairAckMessage({required String hostFingerprint, required String guestFingerprint}) =>
      'paired|$hostFingerprint|$guestFingerprint';

  static Future<EncryptedPayload> encryptSharedKey({
    required String pairingKeyBase64,
    required String sharedKeyBase64,
  }) async {
    final nonce = randomBytes(12);
    final box = await AesGcm.with256bits().encrypt(
      base64Decode(sharedKeyBase64),
      secretKey: SecretKey(base64Decode(pairingKeyBase64)),
      nonce: nonce,
    );
    return EncryptedPayload(
      nonceBase64: base64Encode(box.nonce),
      cipherTextBase64: base64Encode(box.cipherText),
      macBase64: base64Encode(box.mac.bytes),
    );
  }

  static Future<String> decryptSharedKey({
    required String pairingKeyBase64,
    required EncryptedPayload payload,
  }) async {
    final clear = await AesGcm.with256bits().decrypt(
      SecretBox(
        base64Decode(payload.cipherTextBase64),
        nonce: base64Decode(payload.nonceBase64),
        mac: Mac(base64Decode(payload.macBase64)),
      ),
      secretKey: SecretKey(base64Decode(pairingKeyBase64)),
    );
    return base64Encode(clear);
  }

  static Future<String> bodyDigest(String body) async {
    final hash = await Sha256().hash(utf8.encode(body));
    return base64Encode(hash.bytes);
  }

  static Future<String> signRequest({
    required String sharedKeyBase64,
    required String method,
    required String path,
    required int timestamp,
    required String nonce,
    required String body,
  }) async {
    final canonical = '$method\n$path\n$timestamp\n$nonce\n${await bodyDigest(body)}';
    return hmacBase64(sharedKeyBase64, canonical);
  }

  static Future<bool> verifyRequest({
    required String sharedKeyBase64,
    required String method,
    required String path,
    required int timestamp,
    required String nonce,
    required String body,
    required String signatureBase64,
  }) async {
    final expected = await signRequest(
      sharedKeyBase64: sharedKeyBase64,
      method: method,
      path: path,
      timestamp: timestamp,
      nonce: nonce,
      body: body,
    );
    return constantTimeEquals(base64Decode(expected), base64Decode(signatureBase64));
  }
}

class EncryptedPayload {
  const EncryptedPayload({
    required this.nonceBase64,
    required this.cipherTextBase64,
    required this.macBase64,
  });

  final String nonceBase64;
  final String cipherTextBase64;
  final String macBase64;

  Map<String, Object?> toJson() => {'nonce': nonceBase64, 'cipherText': cipherTextBase64, 'mac': macBase64};

  factory EncryptedPayload.fromJson(Map<String, Object?> json) => EncryptedPayload(
    nonceBase64: '${json['nonce']}',
    cipherTextBase64: '${json['cipherText']}',
    macBase64: '${json['mac']}',
  );
}

import 'dart:io';

import 'package:uuid/uuid.dart';

import '../../models/local_identity.dart';
import '../../services/planner_repository.dart';
import 'device_certificate.dart';
import 'pairing_crypto.dart';

class IdentityException implements Exception {
  const IdentityException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Creates and updates this device's local identity.
class IdentityService {
  IdentityService(
    this._repository, {
    DateTime Function()? clock,
    this.certificateKeySize = 2048,
    String Function()? deviceId,
  }) : _clock = clock ?? DateTime.now,
       _deviceId = deviceId ?? (() => const Uuid().v4());

  final PlannerRepository _repository;
  final DateTime Function() _clock;
  final String Function() _deviceId;
  final int certificateKeySize;

  Future<LocalIdentity?> read() => _repository.readIdentity();

  static String defaultDeviceName() {
    final host = Platform.localHostname.trim();
    return host.isEmpty ? 'This device' : host;
  }

  Future<LocalIdentity> create({
    required String username,
    required String deviceName,
    required String pin,
  }) async {
    if (await _repository.readIdentity() != null) {
      throw const IdentityException('This device already has an identity');
    }
    _validate(username, deviceName, pin);

    final id = _deviceId();
    final salt = PairingCrypto.newPinSalt();
    final hash = await PairingCrypto.hashPin(pin, saltBase64: salt);
    final certificate = await generateDeviceCertificate(deviceId: id, keySize: certificateKeySize);
    final now = _clock().toUtc();
    final identity = LocalIdentity(
      deviceId: id,
      deviceName: deviceName.trim(),
      username: username.trim(),
      pinSalt: salt,
      pinHash: hash,
      certificatePem: certificate.certificatePem,
      privateKeyPem: certificate.privateKeyPem,
      mcpToken: PairingCrypto.newMcpToken(),
      createdAt: now,
      updatedAt: now,
    );
    await _repository.saveIdentity(identity);
    return identity;
  }

  Future<bool> verifyPin(LocalIdentity identity, String pin) {
    if (pin.length < 4) return Future<bool>.value(false);
    return PairingCrypto.verifyPin(
      pin: pin,
      saltBase64: identity.pinSalt,
      expectedHashBase64: identity.pinHash,
    );
  }

  Future<LocalIdentity> updateProfile(
    LocalIdentity identity, {
    required String username,
    required String deviceName,
  }) async {
    _validate(username, deviceName, '0000', checkPin: false);
    final updated = identity.copyWith(
      username: username.trim(),
      deviceName: deviceName.trim(),
      updatedAt: _clock().toUtc(),
    );
    await _repository.saveIdentity(updated);
    return updated;
  }

  Future<LocalIdentity> changePin(LocalIdentity identity, String pin) async {
    if (pin.trim().length < 4) throw const IdentityException('Use at least four digits');
    final salt = PairingCrypto.newPinSalt();
    final hash = await PairingCrypto.hashPin(pin.trim(), saltBase64: salt);
    final updated = identity.copyWith(pinSalt: salt, pinHash: hash, updatedAt: _clock().toUtc());
    await _repository.saveIdentity(updated);
    return updated;
  }

  Future<LocalIdentity> rotateMcpToken(LocalIdentity identity) async {
    final updated = identity.copyWith(mcpToken: PairingCrypto.newMcpToken(), updatedAt: _clock().toUtc());
    await _repository.saveIdentity(updated);
    return updated;
  }

  void _validate(String username, String deviceName, String pin, {bool checkPin = true}) {
    if (username.trim().isEmpty) throw const IdentityException('Choose a username');
    if (deviceName.trim().isEmpty) throw const IdentityException('Name this device');
    if (checkPin && pin.trim().length < 4) {
      throw const IdentityException('The PIN needs at least four digits');
    }
  }
}

/// A friendly short form of a SHA-256 fingerprint for screenshots and labels.
String shortFingerprint(String fingerprint) {
  if (fingerprint.length <= 16) return fingerprint;
  return '${fingerprint.substring(0, 8)}…${fingerprint.substring(fingerprint.length - 8)}';
}

/// A compact greeting that avoids exposing the full username in logs.
String identityLabel(LocalIdentity identity) => '${identity.username} · ${identity.deviceName}';

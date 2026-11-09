import '../../models/app_settings.dart';
import '../../services/planner_repository.dart';
import '../sync/pairing_crypto.dart';

class AppLockException implements Exception {
  const AppLockException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Whether a resumed app must ask for the PIN again. A zero grace period locks
/// on every backgrounding; otherwise the app stays open for the grace window.
bool appLockNeedsAuth({required DateTime? leftAt, required int graceSeconds, required DateTime now}) {
  if (graceSeconds <= 0 || leftAt == null) return true;
  return now.difference(leftAt).inSeconds >= graceSeconds;
}

/// The optional local PIN lock. It reuses the same salted PBKDF2 primitive as
/// pairing, but keeps its salt and hash in device settings that backups skip.
class AppLockService {
  AppLockService(this._repository, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  static const minLength = 4;
  static const maxLength = 8;
  static const maxTries = 5;
  static const lockout = Duration(seconds: 30);

  final PlannerRepository _repository;
  final DateTime Function() _clock;

  Future<bool> isEnabled() async {
    final values = await _repository.readSettings();
    return values[SettingsKeys.appLockEnabled] == 'true' &&
        (values[SettingsKeys.appLockPinHash] ?? '').isNotEmpty;
  }

  Future<void> setPin(String pin) async {
    final clean = pin.trim();
    if (clean.length < minLength || clean.length > maxLength) {
      throw const AppLockException('Use four to eight digits');
    }
    final salt = PairingCrypto.newPinSalt();
    final hash = await PairingCrypto.hashPin(clean, saltBase64: salt);
    await _repository.writeSetting(SettingsKeys.appLockPinSalt, salt);
    await _repository.writeSetting(SettingsKeys.appLockPinHash, hash);
    await _repository.writeSetting(SettingsKeys.appLockEnabled, 'true');
    await _clearMisses();
  }

  /// Changing the PIN requires the old one, and turns the lock back on.
  Future<void> changePin({required String currentPin, required String pin}) async {
    if (!await verify(currentPin)) throw const AppLockException('Wrong PIN');
    await setPin(pin);
  }

  Future<void> disable() async {
    await _repository.writeSetting(SettingsKeys.appLockEnabled, 'false');
    await _repository.writeSetting(SettingsKeys.appLockPinSalt, '');
    await _repository.writeSetting(SettingsKeys.appLockPinHash, '');
    await _clearMisses();
  }

  Future<bool> verify(String pin) async {
    final values = await _repository.readSettings();
    if (_remainingLockout(values) > Duration.zero) return false;
    final salt = values[SettingsKeys.appLockPinSalt] ?? '';
    final expected = values[SettingsKeys.appLockPinHash] ?? '';
    if (salt.isEmpty || expected.isEmpty) return false;
    final ok = await PairingCrypto.verifyPin(pin: pin.trim(), saltBase64: salt, expectedHashBase64: expected);
    if (ok) {
      await _clearMisses();
      return true;
    }
    await _recordMiss(values);
    return false;
  }

  Future<Duration> lockoutRemaining() async => _remainingLockout(await _repository.readSettings());

  Duration _remainingLockout(Map<String, String> values) {
    final until = DateTime.tryParse(values[SettingsKeys.appLockBlockedUntil] ?? '');
    if (until == null) return Duration.zero;
    final left = until.difference(_clock());
    return left.isNegative ? Duration.zero : left;
  }

  Future<void> _recordMiss(Map<String, String> values) async {
    final misses = (int.tryParse(values[SettingsKeys.appLockMisses] ?? '') ?? 0) + 1;
    if (misses < maxTries) {
      await _repository.writeSetting(SettingsKeys.appLockMisses, '$misses');
      return;
    }
    await _repository.writeSetting(SettingsKeys.appLockMisses, '0');
    await _repository.writeSetting(SettingsKeys.appLockBlockedUntil, _clock().add(lockout).toIso8601String());
  }

  Future<void> _clearMisses() async {
    await _repository.writeSetting(SettingsKeys.appLockMisses, '0');
    await _repository.writeSetting(SettingsKeys.appLockBlockedUntil, '');
  }
}

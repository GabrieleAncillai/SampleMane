import 'package:flutter_test/flutter_test.dart';
import 'package:mane/features/sync/pairing_crypto.dart';

void main() {
  test('hashes and verifies a PIN without keeping the PIN', () async {
    final salt = PairingCrypto.newPinSalt();
    final hash = await PairingCrypto.hashPin('4821', saltBase64: salt, iterations: 1000);
    expect(hash, isNot(contains('4821')));
    expect(
      await PairingCrypto.verifyPin(
        pin: '4821',
        saltBase64: salt,
        expectedHashBase64: hash,
        iterations: 1000,
      ),
      isTrue,
    );
    expect(
      await PairingCrypto.verifyPin(
        pin: '4822',
        saltBase64: salt,
        expectedHashBase64: hash,
        iterations: 1000,
      ),
      isFalse,
    );
  });

  test('compares byte sequences without early exit', () {
    expect(PairingCrypto.constantTimeEquals([1, 2, 3], [1, 2, 3]), isTrue);
    expect(PairingCrypto.constantTimeEquals([1, 2, 3], [1, 2, 4]), isFalse);
    expect(PairingCrypto.constantTimeEquals([1, 2], [1, 2, 3]), isFalse);
  });

  test('creates a six-digit pairing code', () {
    for (var index = 0; index < 50; index++) {
      final code = PairingCrypto.newPairingCode();
      expect(code, matches(RegExp(r'^\d{6}$')));
    }
  });

  test('both sides derive the same pairing key only with the same inputs', () async {
    final host = await PairingCrypto.derivePairingKey(
      code: '123456',
      hostFingerprint: 'a' * 64,
      guestFingerprint: 'b' * 64,
      username: 'muffin',
      iterations: 1000,
    );
    final guest = await PairingCrypto.derivePairingKey(
      code: '123456',
      hostFingerprint: 'a' * 64,
      guestFingerprint: 'b' * 64,
      username: 'muffin',
      iterations: 1000,
    );
    expect(host, guest);

    final wrongCode = await PairingCrypto.derivePairingKey(
      code: '123457',
      hostFingerprint: 'a' * 64,
      guestFingerprint: 'b' * 64,
      username: 'muffin',
      iterations: 1000,
    );
    expect(wrongCode, isNot(host));

    final wrongCert = await PairingCrypto.derivePairingKey(
      code: '123456',
      hostFingerprint: 'a' * 64,
      guestFingerprint: 'c' * 64,
      username: 'muffin',
      iterations: 1000,
    );
    expect(wrongCert, isNot(host));
  });

  test('encrypts the shared key for the pairing key only', () async {
    final key = PairingCrypto.randomBase64(32);
    final shared = PairingCrypto.randomBase64(32);
    final payload = await PairingCrypto.encryptSharedKey(pairingKeyBase64: key, sharedKeyBase64: shared);
    expect(await PairingCrypto.decryptSharedKey(pairingKeyBase64: key, payload: payload), shared);

    final other = PairingCrypto.randomBase64(32);
    await expectLater(
      PairingCrypto.decryptSharedKey(pairingKeyBase64: other, payload: payload),
      throwsA(anything),
    );
  });

  test('signs a request and rejects a changed body, path or key', () async {
    final key = PairingCrypto.randomBase64(32);
    const path = '/mane/v1/query?resource=summary';
    final signature = await PairingCrypto.signRequest(
      sharedKeyBase64: key,
      method: 'GET',
      path: path,
      timestamp: 1700000000,
      nonce: 'abcdefgh12345678',
      body: '',
    );
    expect(
      await PairingCrypto.verifyRequest(
        sharedKeyBase64: key,
        method: 'GET',
        path: path,
        timestamp: 1700000000,
        nonce: 'abcdefgh12345678',
        body: '',
        signatureBase64: signature,
      ),
      isTrue,
    );
    expect(
      await PairingCrypto.verifyRequest(
        sharedKeyBase64: key,
        method: 'GET',
        path: '$path&start=2026-11-09',
        timestamp: 1700000000,
        nonce: 'abcdefgh12345678',
        body: '',
        signatureBase64: signature,
      ),
      isFalse,
    );
    expect(
      await PairingCrypto.verifyRequest(
        sharedKeyBase64: PairingCrypto.randomBase64(32),
        method: 'GET',
        path: path,
        timestamp: 1700000000,
        nonce: 'abcdefgh12345678',
        body: '',
        signatureBase64: signature,
      ),
      isFalse,
    );
  });
}

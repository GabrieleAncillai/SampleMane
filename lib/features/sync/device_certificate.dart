import 'package:basic_utils/basic_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';

class DeviceCertificate {
  const DeviceCertificate({
    required this.certificatePem,
    required this.privateKeyPem,
    required this.fingerprint,
  });

  final String certificatePem;
  final String privateKeyPem;

  /// Lower-case SHA-256 hex of the DER certificate. Peers pin this value.
  final String fingerprint;
}

/// Generates the device's self-signed TLS identity once.
///
/// The certificate is not trusted by a public CA on purpose: paired devices pin
/// the fingerprint instead. Generation uses RSA so BoringSSL on Android and
/// OpenSSL on Linux accept it without extra setup.
Future<DeviceCertificate> generateDeviceCertificate({required String deviceId, int keySize = 2048}) async {
  final pair = CryptoUtils.generateRSAKeyPair(keySize: keySize);
  final privateKey = pair.privateKey as RSAPrivateKey;
  final publicKey = pair.publicKey as RSAPublicKey;
  final csr = X509Utils.generateRsaCsrPem({'CN': 'Mane $deviceId', 'O': 'Mane'}, privateKey, publicKey);
  final certificatePem = X509Utils.generateSelfSignedCertificate(privateKey, csr, 3650);
  final der = CryptoUtils.getBytesFromPEMString(certificatePem);
  final fingerprint = await fingerprintOfDer(der);
  return DeviceCertificate(
    certificatePem: certificatePem,
    privateKeyPem: CryptoUtils.encodeRSAPrivateKeyToPem(privateKey),
    fingerprint: fingerprint,
  );
}

Future<String> fingerprintOfCertificatePem(String certificatePem) async =>
    fingerprintOfDer(CryptoUtils.getBytesFromPEMString(certificatePem));

/// Synchronous variant for widgets that already hold the PEM.
String fingerprintOfPemSync(String certificatePem) =>
    sha256.convert(CryptoUtils.getBytesFromPEMString(certificatePem)).toString();

Future<String> fingerprintOfDer(List<int> der) async {
  final digest = await Sha256().hash(der);
  return digest.bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
}

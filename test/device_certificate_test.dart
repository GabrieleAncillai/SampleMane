import 'package:flutter_test/flutter_test.dart';
import 'package:mane/features/sync/device_certificate.dart';

void main() {
  test('generates a self-signed certificate and a stable SHA-256 fingerprint', () async {
    final certificate = await generateDeviceCertificate(deviceId: 'self', keySize: 1024);
    expect(certificate.certificatePem, contains('BEGIN CERTIFICATE'));
    expect(certificate.privateKeyPem, contains('BEGIN PRIVATE KEY'));
    expect(certificate.fingerprint, matches(RegExp(r'^[0-9a-f]{64}$')));
    expect(await fingerprintOfCertificatePem(certificate.certificatePem), certificate.fingerprint);
    expect(fingerprintOfPemSync(certificate.certificatePem), certificate.fingerprint);
  });
}

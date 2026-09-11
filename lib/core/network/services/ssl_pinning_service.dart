import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class SslPinningService {
  /// The list of valid SHA-256 fingerprints for the base API endpoints.
  final List<String> allowedShas;

  const SslPinningService({required this.allowedShas});

  /// Attaches SSL pinning to the provided [Dio] instance.
  /// Validates the certificate SHA-256 fingerprint against [allowedShas].
  /// If [sslValid] is false, it forces a bad certificate error,
  /// which will be mapped to a MITM detected failure.
  void attachPinning(Dio dio, {required String targetHost}) {
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        // By disabling trusted roots, we force the client to call
        // badCertificateCallback for all connections. This allows us to
        // manually verify the SHA fingerprint, preventing MITM attacks
        // even if a malicious root CA is installed on the user's device.
        final client = HttpClient(
          context: SecurityContext(withTrustedRoots: false),
        );

        client.badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) {
          // Only apply strict SHA pinning for the sensitive target host
          if (host.contains(targetHost)) {
            final certBytes = cert.der;
            final digest = sha256.convert(certBytes);
            final sha = digest.toString();

            final sslValid = allowedShas.contains(sha);

            // If sslValid is false, returning false throws DioExceptionType.badCertificate
            return sslValid;
          }

          // For other non-sensitive hosts (e.g. Google Maps), we might want to
          // fallback to default validation or just let them pass.
          // Since withTrustedRoots is false, returning true allows the connection.
          return true;
        };

        return client;
      },
    );
  }
}

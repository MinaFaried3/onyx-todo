import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

/// An interceptor that performs a pre-request SSL Pinning check.
/// This is an alternative to the IOHttpClientAdapter approach.
/// It enables you to selectively enforce SSL Pinning only on
/// specific endpoints (e.g. sensitive endpoints like /payments)
/// rather than the entire Dio instance.
class SslPinningInterceptor extends Interceptor {
  /// The list of valid SHA-256 fingerprints.
  final List<String> allowedShas;

  /// The list of specific endpoint paths that require SSL pinning verification.
  /// Example: ['/api/v1/payments', '/api/v1/auth']
  final List<String> pinnedEndpoints;

  SslPinningInterceptor({
    required this.allowedShas,
    required this.pinnedEndpoints,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Check if the current request path matches any of the specified pinned endpoints.
    final requiresPinning = pinnedEndpoints.any((endpoint) => options.path.contains(endpoint));

    if (requiresPinning) {
      final isSecure = await _verifyCertificate(options.uri);
      
      if (!isSecure) {
        // If the certificate is invalid, reject the request before it even sends data.
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badCertificate,
            error: 'MITM Attack Detected: Invalid SSL Certificate on sensitive endpoint.',
          ),
        );
      }
    }

    // Continue the request if it's secure or doesn't require pinning.
    super.onRequest(options, handler);
  }

  /// Manually establishes a secure socket to retrieve and verify the peer certificate.
  Future<bool> _verifyCertificate(Uri uri) async {
    try {
      final host = uri.host;
      final port = uri.port > 0 ? uri.port : 443;

      // Initiate a secure socket connection to check the certificate
      final socket = await SecureSocket.connect(
        host,
        port,
        timeout: const Duration(seconds: 5),
      );
      
      final cert = socket.peerCertificate;
      
      // Close the socket immediately since we only needed the certificate
      socket.destroy();

      if (cert == null) return false;

      // Convert the DER-encoded certificate to a SHA-256 string
      final certBytes = cert.der;
      final digest = sha256.convert(certBytes).toString();

      return allowedShas.contains(digest);
    } catch (e) {
      // If the connection fails or certificate retrieval errors, consider it unsecure.
      return false;
    }
  }
}

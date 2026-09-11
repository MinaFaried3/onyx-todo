/// Security configuration.
///
/// ```dart
/// security: const SecurityConfiguration(
///   sslPinning: true,
///   safeDevice: true,
/// ),
/// ```
class SecurityConfig {
  //! Enable SSL pinning on the primary Dio instance.
  //? When enabled, SHA-256 fingerprints must be provided via [SslPinningService].
  final bool sslPinning;

  //! Enable jailbreak/root detection via `safe_device`.
  final bool safeDevice;

  const SecurityConfig({
    this.sslPinning = false,
    this.safeDevice = false,
  });
}

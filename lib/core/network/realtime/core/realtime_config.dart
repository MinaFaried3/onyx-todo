final class RealTimeConfig {
  final Duration initialRetryDelay;
  final Duration maxRetryDelay;
  final double backoffMultiplier;
  final int? maxRetryAttempts;

  const RealTimeConfig({
    this.initialRetryDelay = const Duration(seconds: 1),
    this.maxRetryDelay = const Duration(seconds: 30),
    this.backoffMultiplier = 2.0,
    this.maxRetryAttempts,
  });

  static const defaultConfig = RealTimeConfig();

  Duration delayForAttempt(int attempt) {
    final delayMs =
        initialRetryDelay.inMilliseconds * _pow(backoffMultiplier, attempt);
    final clampedMs = delayMs.clamp(0, maxRetryDelay.inMilliseconds).toInt();
    return Duration(milliseconds: clampedMs);
  }

  bool shouldRetry(int attempt) =>
      maxRetryAttempts == null || attempt < maxRetryAttempts!;

  static double _pow(double base, int exponent) {
    var result = 1.0;
    for (var i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}

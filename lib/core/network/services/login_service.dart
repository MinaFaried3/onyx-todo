import 'dart:async';

// ─── Auth Callback Types ───────────────────────────────────────────────
typedef AuthAction<T> = Future<T?> Function();
typedef OnLockCallback = void Function(DateTime lockedUntil);
typedef OnFailCallback = void Function(int failedAttempts, int maxAttempts);

// ─── Config (fully customizable) ──────────────────────────────────────
class LoginConfig {
  final int maxAttempts;
  final Duration lockDuration;

  const LoginConfig({
    this.maxAttempts = 5,
    this.lockDuration = const Duration(minutes: 15),
  });
}

// ─── Result type (Dart 3 Sealed Class) ────────────────────────────────
sealed class LoginResult<T> {}

final class LoginSuccess<T> extends LoginResult<T> {
  final T data;
  LoginSuccess(this.data);
}

final class LoginFailed<T> extends LoginResult<T> {
  final int attemptsLeft;
  LoginFailed({required this.attemptsLeft});
}

final class LoginLocked<T> extends LoginResult<T> {
  final Duration remaining;
  LoginLocked({required this.remaining});
}

final class LoginError<T> extends LoginResult<T> {
  final String errorMessage;
  LoginError({required this.errorMessage});
}

// ─── LoginService (no API dependency) ─────────────────────────────────
class LoginService<T> {
  final LoginConfig config;
  final OnLockCallback? onLocked;
  final OnFailCallback? onFailed;

  int _failedAttempts = 0;
  DateTime? _lockUntil;

  LoginService({
    this.config = const LoginConfig(),
    this.onLocked,
    this.onFailed,
  });

  bool get isLocked =>
      _lockUntil != null && DateTime.now().isBefore(_lockUntil!);

  Duration get remainingLockTime =>
      isLocked ? _lockUntil!.difference(DateTime.now()) : Duration.zero;

  /// Pass your authentication logic as an [action] closure.
  /// It can be email/password, OTP, biometrics, etc.
  Future<LoginResult<T>> attempt(AuthAction<T> action) async {
    if (isLocked) {
      return LoginLocked(remaining: remainingLockTime);
    }

    try {
      // Execute the provided authentication action
      final result = await action();

      if (result != null) {
        _reset();
        return LoginSuccess(result);
      }

      // Handle failure
      _failedAttempts++;
      onFailed?.call(_failedAttempts, config.maxAttempts);

      if (_failedAttempts >= config.maxAttempts) {
        _lockUntil = DateTime.now().add(config.lockDuration);
        onLocked?.call(_lockUntil!);
        return LoginLocked(remaining: config.lockDuration);
      }

      return LoginFailed(
        attemptsLeft: config.maxAttempts - _failedAttempts,
      );
    } catch (e) {
      return LoginError(errorMessage: e.toString());
    }
  }

  void _reset() {
    _failedAttempts = 0;
    _lockUntil = null;
  }

  void unlock() => _reset();
}

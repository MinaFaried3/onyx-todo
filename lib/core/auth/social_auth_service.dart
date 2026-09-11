import 'package:onyx_todo/core/network/error/app_failures.dart';

/// Supported social authentication providers.
enum SocialProvider { google, apple }

/// Sealed class representing the result of a social authentication attempt.
sealed class SocialAuthResult {
  const SocialAuthResult();
}

/// Represents a successful client-side social authentication.
class SocialAuthSuccess extends SocialAuthResult {
  final String idToken;
  final String? accessToken;
  final String? email;
  final String? displayName;
  final String? id;
  final String? photoUrl;

  const SocialAuthSuccess({
    required this.idToken,
    this.accessToken,
    this.email,
    this.displayName,
    this.id,
    this.photoUrl,
  });
}

/// Represents user-cancelled social authentication (e.g. dismissed dialog).
class SocialAuthCancelled extends SocialAuthResult {
  const SocialAuthCancelled();
}

/// Represents a failure during client-side social authentication.
class SocialAuthFailure extends SocialAuthResult {
  final Failure failure;

  const SocialAuthFailure(this.failure);
}

/// Abstract contract for social authentication services.
abstract interface class SocialAuthService {
  /// Triggers the client-side social authentication flow.
  Future<SocialAuthResult> signIn();

  /// Logs the user out of the provider SDK session.
  Future<void> signOut();
}

import 'package:onyx_todo/core/auth/social_auth_service.dart';
import 'package:onyx_todo/core/config/platform/platform.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthService implements SocialAuthService {
  @override
  Future<SocialAuthResult> signIn() async {
    if (CurrentPlatform.isNotApple) return const SocialAuthCancelled();
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String? identityToken = credential.identityToken;
      if (identityToken == null || identityToken.isEmpty) {
        return const SocialAuthFailure(
          UnKnownFailure(
            code: FailureCode.defaultState,
            message: 'Failed to retrieve Apple Identity Token.',
          ),
        );
      }

      // Format name if available
      final String? name = credential.givenName != null
          ? '${credential.givenName} ${credential.familyName ?? ''}'.trim()
          : null;

      return SocialAuthSuccess(
        idToken: identityToken,
        accessToken: credential.authorizationCode,
        email: credential.email,
        displayName: name,
        id: credential.userIdentifier,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return const SocialAuthCancelled();
      }
      return SocialAuthFailure(
        UnKnownFailure(code: FailureCode.defaultState, message: e.message),
      );
    } catch (e) {
      return SocialAuthFailure(
        UnKnownFailure(code: FailureCode.defaultState, message: e.toString()),
      );
    }
  }

  @override
  Future<void> signOut() async {
    // Apple doesn't have a sign out SDK method like Google.
  }
}

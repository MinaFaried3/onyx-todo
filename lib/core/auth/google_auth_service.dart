import 'package:google_sign_in/google_sign_in.dart';
import 'package:onyx_todo/core/auth/social_auth_service.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';

class GoogleAuthService implements SocialAuthService {
  final GoogleSignIn _googleSignIn;

  GoogleAuthService({GoogleSignIn? googleSignIn})
    : _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  @override
  Future<SocialAuthResult> signIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        return const SocialAuthFailure(
          UnKnownFailure(
            code: FailureCode.defaultState,
            message: 'Failed to retrieve Google ID Token.',
          ),
        );
      }
      return SocialAuthSuccess(
        idToken: idToken,
        email: googleUser.email,
        displayName: googleUser.displayName,
        id: googleUser.id,
        photoUrl: googleUser.photoUrl,
      );
    } catch (e) {
      final String errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('sign_in_canceled') ||
          errorMsg.contains('canceled') ||
          errorMsg.contains('cancel')) {
        return const SocialAuthCancelled();
      }
      return SocialAuthFailure(
        UnKnownFailure(code: FailureCode.defaultState, message: e.toString()),
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }
}

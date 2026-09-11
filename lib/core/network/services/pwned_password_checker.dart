import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

/// A secure checker that uses the HaveIBeenPwned API (k-Anonymity model)
/// to verify if a password has been leaked in a data breach.
class PwnedPasswordChecker {
  final Dio _dio;

  /// It's best to use a separate [Dio] instance for this checker to avoid
  /// sending your app's authentication headers (like Bearer tokens) to a third-party API.
  PwnedPasswordChecker([Dio? dio]) : _dio = dio ?? Dio();

  /// Returns `true` if the password has been leaked.
  Future<bool> isPasswordPwned(String password) async {
    // 1. Hash the password using SHA-1
    final bytes = utf8.encode(password);
    final digest = sha1.convert(bytes);
    final sha1String = digest.toString().toUpperCase();
    
    // 2. Extract the prefix (first 5 chars) and suffix (the rest)
    final prefix = sha1String.substring(0, 5);
    final suffix = sha1String.substring(5);

    try {
      // 3. Send ONLY the 5-character prefix to the API
      final response = await _dio.get(
        'https://api.pwnedpasswords.com/range/$prefix',
        options: Options(
          headers: {'User-Agent': 'Onyx-Driver-App'},
        ),
      );

      if (response.statusCode == 200) {
        final body = response.data.toString();
        // 4. Check if the response body contains our hashed suffix
        return body.contains(suffix);
      }
      return false;
    } catch (e) {
      // If the API fails, we return false (fail open) so we don't block the user,
      // but ideally you should log this error using your crashlytics.
      return false;
    }
  }
}

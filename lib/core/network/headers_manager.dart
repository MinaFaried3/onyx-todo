/// HTTP headers constants و builders لاستخدامها في DioFactory.
abstract class HeadersManager {
  static const String contentType     = 'Content-Type';
  static const String accept          = 'Accept';
  static const String acceptLanguage  = 'Accept-Language';
  static const String authorization   = 'Authorization';
  static const String applicationJson = 'application/json';

  /// Base headers للـ primary API — يُستخدم في كل request
  static Future<Map<String, String>> baseHeaders(
    String lang,
    String token,
  ) async {
    return {
      contentType:    applicationJson,
      accept:         applicationJson,
      acceptLanguage: lang,
      if (token.isNotEmpty) authorization: 'Bearer $token',
    };
  }
}

import 'package:url_launcher/url_launcher.dart';

class AppLauncher {
  // =============================
  // 🔹 Core launcher (single source of truth)
  // =============================
  static Future<void> _launch(
    Uri uri, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: mode);
    } else {
      throw Exception('Could not launch $uri');
    }
  }

  // =============================
  // ✅ Public APIs
  // =============================

  static Future<void> openWhatsApp({
    required String phone,
    required String message,
  }) {
    final uri = Uri.parse(
      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
    );

    return _launch(uri);
  }

  static Future<void> sendEmail({
    required String email,
    String? subject,
    String? body,
  }) {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': ?subject, 'body': ?body},
    );

    return _launch(uri);
  }

  static Future<void> makePhoneCall(String phone) {
    final uri = Uri(scheme: 'tel', path: phone);
    return _launch(uri);
  }
}

import 'package:onyx_todo/core/config/environments/environment_config.dart';
import 'package:onyx_todo/core/config/environments/firebase_config.dart';
import 'package:onyx_todo/core/config/environments/maps_config.dart';
import 'package:onyx_todo/core/config/environments/security_config.dart';
import 'package:onyx_todo/core/localization/language_manager.dart';
import 'package:flutter/widgets.dart';

export 'package:onyx_todo/core/config/environments/environment_config.dart';
export 'package:onyx_todo/core/config/environments/firebase_config.dart';

class CoreConfig {
  static CoreConfig? _instance;
  static CoreConfig? get instance => _instance;

  //! App identifier — used for secure storage vault naming.
  //? Examples: 'Onyx_driver' | 'Onyx_customer' | 'Onyx_admin'
  final String appId;

  //! Base URL for the primary API.
  final String apiBaseUrl;

  //! Runtime environment — affects internal package behavior.
  final Environment environment;

  //! Locales supported by the application.
  final List<Locale> supportedLocales;

  // ─── Module Configurations ──────────────────────────────────────────

  //! Firebase configuration — `null` means no Firebase at all.
  final FirebaseConfig? firebase;

  //! Google Maps configuration — `null` means no Maps (Maps Dio won't be registered).
  final MapsConfig? maps;

  //! Security settings — SSL pinning + safe device check.
  final SecurityConfig security;

  CoreConfig({
    required this.appId,
    required this.apiBaseUrl,
    required this.environment,
    this.supportedLocales = LocalizationManager.supportedLocales,
    this.firebase,
    this.maps,
    this.security = const SecurityConfig(),
  }) {
    _instance = this;
  }

  // ─── Convenience getters ────────────────────────────────────────────

  bool get hasFirebase => firebase != null;

  bool get hasMaps => maps != null;

  static Environment get currEnv => _instance?.environment ?? Environment.dev;

  @override
  String toString() =>
      'CoreConfig('
      'appId: $appId, '
      'env: ${environment.name}, '
      'firebase: ${hasFirebase ? "✅" : "—"}, '
      'maps: ${hasMaps ? "✅" : "—"}'
      ')';
}

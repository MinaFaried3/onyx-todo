import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onyx_todo/core/config/environments/core_config.dart';
import 'package:onyx_todo/core/config/platform/platform.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:onyx_todo/core/network/network_checker.dart';
import 'package:onyx_todo/core/notification/app_notification_service.dart';
import 'package:onyx_todo/core/remote_config/app_remote_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// يُهيّئ Firebase بالكامل بناءً على [FirebaseConfig].
/// لن يُستدعى أي شيء إذا كان [CoreConfig.firebase] == null.
abstract final class FirebaseModule {
  static Future<void> init({required CoreConfig configuration}) async {
    final firebaseConfig = configuration.firebase;

    // Firebase معطّل كلياً
    if (firebaseConfig == null) {
      Printer.printHint('[Firebase] disabled — firebase: null');
      return;
    }

    // 1. Initialize Firebase app
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: firebaseConfig.options);
      Printer.printHint('[Firebase] ✅ App initialized');
    } else {
      Printer.printHint('[Firebase] already initialized');
    }

    // Register Firestore and Auth
    getIt.lazySingletonOnce<FirebaseFirestore>(() => FirebaseFirestore.instance);
    getIt.lazySingletonOnce<FirebaseAuth>(() => FirebaseAuth.instance);

    try {
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
      );
    } catch (e) {
      Printer.logger('Firestore persistence settings notice: $e');
    }

    // 2. Analytics + Crashlytics + Performance تشتغل بالتوازي
    await Future.wait([
      _initAnalytics(firebaseConfig),
      _initCrashlytics(firebaseConfig),
      _initPerformance(firebaseConfig),
    ]);

    // 3. Remote Config (مرتبط بـ firebase)
    await _initRemoteConfig();

    // 4. Notifications — initialized alongside Firebase
    await _initNotifications();
  }

  // ─── Analytics ──────────────────────────────────────────────────────

  static Future<void> _initAnalytics(FirebaseConfig config) async {
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
      config.analytics,
    );
    Printer.printHint(
      '[Firebase] Analytics ${config.analytics ? "✅ enabled" : "disabled"}',
    );
  }

  // ─── Crashlytics ────────────────────────────────────────────────────

  static Future<void> _initCrashlytics(FirebaseConfig config) async {
    // Crashlytics is not supported on Flutter Web
    if (CurrentPlatform.isWeb || !config.crashlytics) {
      Printer.printHint('[Firebase] Crashlytics skipped (web or disabled)');
      return;
    }

    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      config.crashlytics,
    );

    if (config.crashlytics) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      Printer.printHint('[Firebase] ✅ Crashlytics enabled');
    } else {
      Printer.printHint('[Firebase] Crashlytics disabled');
    }
  }

  // ─── Performance ────────────────────────────────────────────────────

  static Future<void> _initPerformance(FirebaseConfig config) async {
    // Firebase Performance on web is not supported by standard plugin
    if (CurrentPlatform.isWeb || !config.performance) {
      Printer.printHint('[Firebase] Performance skipped (web or disabled)');
      return;
    }

    await FirebasePerformance.instance.setPerformanceCollectionEnabled(
      config.performance,
    );
    Printer.printHint(
      '[Firebase] Performance ${config.performance ? "✅ enabled" : "disabled"}',
    );
  }

  // ─── Remote Config ──────────────────────────────────────────────────

  static Future<void> _initRemoteConfig() async {
    getIt.lazySingletonOnce<AppRemoteConfig>(
      () => AppRemoteConfig(
        firebaseRemoteConfig: FirebaseRemoteConfig.instance,
        networkChecker: getIt<NetworkChecker>(),
      ),
    );

    if (CurrentPlatform.isMobile) {
      await getIt<AppRemoteConfig>().fetchAndActivate();
    }

    Printer.printHint('[Firebase] ✅ RemoteConfig initialized');
  }

  // ─── Notifications ──────────────────────────────────────────────────

  static Future<void> _initNotifications() async {
    if (CurrentPlatform.isWeb) return;
    await AppNotificationService.initNotification();
    Printer.printHint('[Firebase] ✅ Notifications initialized');
  }
}

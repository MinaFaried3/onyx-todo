import 'dart:async';

import 'package:onyx_todo/core/config/platform/platform.dart';
import 'package:onyx_todo/core/extension/bool_extension.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:onyx_todo/core/network/network_checker.dart';
import 'package:onyx_todo/core/notification/firebase_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

abstract final class AppNotificationService {
  static FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  static NetworkChecker? get networkChecker {
    if (!getIt.isRegistered<NetworkChecker>()) return null;
    return getIt<NetworkChecker>();
  }

  static String? _cachedDeviceToken;
  static String? _cachedApnsToken;

  static void invalidateTokenCache() {
    _cachedDeviceToken = null;
    _cachedApnsToken = null;
  }

  static Future<void> initNotification() async {
    if (Firebase.apps.isEmpty) return;

    try {
      await NotificationService.instance.initialize();
      unawaited(getIOSAPNsToken());
      unawaited(getDeviceToken());
    } catch (e) {
      Printer.logger('❌ [AppNotificationService] initNotification error: $e');
    }
  }

  static Future<void> requestPermission() async {
    await NotificationService.instance.requestPermission();
  }

  static Future<String> getDeviceToken() async {
    if (Firebase.apps.isEmpty) return '';
    if (CurrentPlatform.isWeb) return '';
    if (_cachedDeviceToken != null) return _cachedDeviceToken!;

    if (CurrentPlatform.isIOS && kDebugMode) return '';

    final checker = networkChecker;
    if (checker == null) return '';
    if ((await checker.isConnected).isFalse) return '';

    try {
      final String fcmToken = await firebaseMessaging.getToken() ?? '';
      _cachedDeviceToken = fcmToken;
      Printer.print('fcmToken   $fcmToken', color: ConsoleColor.brightYellow);
      return fcmToken;
    } catch (e) {
      Printer.print('FCM TOKEN ERROR : $e', color: ConsoleColor.redBg);
      return '';
    }
  }

  static Future<String> getIOSAPNsToken() async {
    if (Firebase.apps.isEmpty) return '';
    if (CurrentPlatform.isWeb) return '';
    if (_cachedApnsToken != null) return _cachedApnsToken!;

    if ((CurrentPlatform.isIOS && kDebugMode) || CurrentPlatform.isAndroid) return '';
    final checker = networkChecker;
    if (checker == null) return '';
    if ((await checker.isConnected).isFalse) return '';
    try {
      final String apns = await firebaseMessaging.getAPNSToken() ?? '';
      _cachedApnsToken = apns;
      Printer.print('apns   $apns', color: ConsoleColor.brightYellow);
      return apns;
    } catch (e) {
      Printer.print('APNs TOKEN ERROR : $e', color: ConsoleColor.redBg);
      return '';
    }
  }
}

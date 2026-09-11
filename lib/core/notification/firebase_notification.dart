import 'dart:async';
import 'dart:convert';

import 'package:alice/alice.dart';
import 'package:onyx_todo/core/navigation/routes/core/routes_strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onyx_todo/core/config/platform/platform.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:onyx_todo/core/navigation/service/navigation_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

@pragma('vm:entry-point')
void _onDidReceiveBackgroundNotificationResponse(
  NotificationResponse response,
) {
  // NotificationService.instance.handleNotificationPayload(response.payload);

  // Intentionally empty.
  // When the user taps this notification, the app will foreground and
  // _setupMessageHandlers will pick it up via getNotificationAppLaunchDetails().
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';
  static const String _channelDescription =
      'This channel is used for important notifications.';

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final _notificationTapStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  bool _isFlutterLocalNotificationsInitialized = false;
  StreamSubscription<String>? _tokenRefreshSubscription;

  Stream<Map<String, dynamic>> get onNotificationTap =>
      _notificationTapStreamController.stream;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await setupFlutterNotifications();
    _schedulePermissionSetup();

    await _setupMessageHandlers();
    _listenToTokenRefresh();
  }

  void _schedulePermissionSetup() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_setupPermissions());
    });
  }

  Future<void> _setupPermissions() async {
    try {
      await Future.wait([
        if (CurrentPlatform.isApple) _configureForegroundPresentation(),
        requestPermission(),
      ]);
    } catch (e, stack) {
      Printer.logger('❌ [NotificationService] _setupPermissions error: $e');
      Printer.logger('Stack Trace:\n$stack');
    }
  }

  Future<NotificationSettings?> requestPermission() async {
    try {
      return await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } on PlatformException catch (e) {
      Printer.logger(
        '⚠️ [NotificationService] PlatformException requesting permission: $e',
      );
      return null;
    } catch (e, stack) {
      if (CurrentPlatform.isAndroid) {
        return await _fallbackAndroidLocalPermission();
      }
      Printer.logger('❌ [NotificationService] requestPermission error: $e');
      Printer.logger('Stack Trace:\n$stack');
      return null;
    }
  }

  Future<NotificationSettings?> _fallbackAndroidLocalPermission() async {
    try {
      Printer.logger(
        '⚠️ [NotificationService] FCM requestPermission failed, trying local fallback',
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    } catch (e) {
      Printer.logger(
        '⚠️ [NotificationService] Android local notifications fallback error: $e',
      );
    }
    return null;
  }

  Future<void> _configureForegroundPresentation() async {
    try {
      // Disable FCM's native foreground display on Apple platforms —
      // flutter_local_notifications handles foreground notification rendering via showNotification()
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: false,
        sound: false,
      );
    } catch (e) {
      Printer.logger(
        '❌ [NotificationService] _configureForegroundPresentation error: $e',
      );
    }
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    // android setup
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    final initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // flutter notification setup
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        handleNotificationPayload(details.payload);
      },
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveBackgroundNotificationResponse,
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? _readString(message.data, 'title');
    final body = notification?.body ?? _readString(message.data, 'body');

    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      Printer.printHint('[NotificationService] message skipped: empty content');
      return;
    }

    final id =
        Object.hash(
          message.messageId ?? DateTime.now().toIso8601String(),
          message.sentTime?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
          title,
        ).abs() %
        0x7FFFFFFF; // clamp to valid Android notification ID range

    await _localNotifications.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  Future<void> showAliceNotification(String title, String body) async {
    await _localNotifications.show(
      0x7FFFFFFA, // Unique ID for Alice HTTP notifications
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: false,
        ),
      ),
      payload: 'Alice',
    );
  }

  Future<void> _setupMessageHandlers() async {
    FirebaseMessaging.onMessage.listen((message) async {
      await showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleRemoteMessageTap);

    // FCM cold start takes priority
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleRemoteMessageTap(initialMessage);
      return; // ← don't also handle local notification
    }

    // Local notification cold start
    final launchDetails = await _localNotifications
        .getNotificationAppLaunchDetails();
    final response = launchDetails?.notificationResponse;
    if (response?.payload?.isNotEmpty == true) {
      handleNotificationPayload(response!.payload);
    }
  }

  void _handleRemoteMessageTap(RemoteMessage message) {
    if (message.data.isEmpty) {
      Printer.print(
        '_handleRemoteMessageTap message.data.isEmpty $message \n ${message.data} ',
      );
      _openNotificationsScreen();
      return;
    }

    _notificationTapStreamController.add(
      Map<String, dynamic>.from(message.data),
    );
    Printer.print(
      '_handleRemoteMessageTap _notificationTapStreamController $message \n ${message.data} ',
    );
    _openNotificationsScreen();
  }

  void handleNotificationPayload(String? payload) {
    if (payload == null || payload.isEmpty) {
      Printer.print(
        'handleNotificationPayload payload == null || payload.isEmpty $payload \n  ',
      );
      _openNotificationsScreen();
      return;
    }

    // Alice notification tap — redirect to Alice inspector
    if (payload == 'Alice') {
      Printer.print('handleNotificationPayload Alice notification tap');
      if (getIt.isRegistered<Alice>()) {
        getIt<Alice>().showInspector();
      }
      return;
    }

    try {
      final decoded = jsonDecode(payload);
      switch (decoded) {
        case Map<String, dynamic> m:
          _notificationTapStreamController.add(m);
        case Map m:
          _notificationTapStreamController.add(
            Map<String, dynamic>.from(m),
          );
      }
    } catch (_) {
      Printer.printHint(
        '[NotificationService] payload parsing failed, opening notifications',
      );
    }
    Printer.print(
      'handleNotificationPayload _notificationTapStreamController $payload \n  ',
    );
    _openNotificationsScreen();
  }

  void _listenToTokenRefresh() {
    _tokenRefreshSubscription ??= _messaging.onTokenRefresh.listen((token) {
      Printer.print(
        'FCM token refreshed: $token',
        color: ConsoleColor.brightYellow,
      );
    });
  }

  // ✅ Safe approach — defer navigation to app lifecycle
  void _openNotificationsScreen() {
    // Only navigate if app is in foreground/active state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!getIt.isRegistered<NavigationService>()) return;
      getIt<NavigationService>().go(RoutesStrings.notifications);
    });
  }

  String? _readString(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }

  // ✅ Add disposal
  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _notificationTapStreamController.close();
  }
}

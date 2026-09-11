import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/navigation/observer/navigation_observer.dart';
import 'package:onyx_todo/core/navigation/observer/request_route_observer.dart';
import 'package:onyx_todo/core/navigation/overlay/overlay_manager.dart';
import 'package:onyx_todo/core/navigation/service/navigation_service.dart';
import 'package:onyx_todo/core/storage/shared_preferences/app_preferences.dart';

/// Callback signature — كل مشروع يمرر buildAppRouter الخاص به
typedef RouterBuilder = GoRouter Function({
  required String initialLocation,
  required GlobalKey<NavigatorState> navigatorKey,
  required List<NavigatorObserver> observers,
});

abstract final class NavigationModule {
  /// [routerBuilder] — الـ GoRouter builder الخاص بكل مشروع.
  /// [hasFirebase] — إذا كان true يُضاف FirebaseAnalyticsObserver.
  static Future<void> init({
    required RouterBuilder routerBuilder,
    bool hasFirebase = false,
  }) async {
    // 1. Navigator key
    getIt.lazySingletonOnce<GlobalKey<NavigatorState>>(
      () => GlobalKey<NavigatorState>(),
    );

    final appPreferences = getIt<AppPreferences>();

    // 2. Navigation Observers
    getIt.lazySingletonOnce<NavigationObserver>(() => NavigationObserver());
    getIt.lazySingletonOnce<RequestRouteObserver>(() => RequestRouteObserver());

    // 3. Resolve initial location
    final initialLocation = await appPreferences.getOpeningRoutePath();

    // 4. GoRouter — built by the caller app
    final observers = <NavigatorObserver>[
      getIt<NavigationObserver>(),
      getIt<RequestRouteObserver>(),
      if (hasFirebase)
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ];

    getIt.lazySingletonOnce<GoRouter>(
      () => routerBuilder(
        initialLocation: initialLocation,
        navigatorKey: getIt<GlobalKey<NavigatorState>>(),
        observers: observers,
      ),
    );

    // 5. Overlay manager
    getIt.lazySingletonOnce<OverlayManager>(
      () => OverlayManager(navigatorKey: getIt<GlobalKey<NavigatorState>>()),
    );

    // 6. Context-less Navigation Service
    getIt.lazySingletonOnce<NavigationService>(
      () => NavigationServiceImpl(
        router: getIt<GoRouter>(),
        overlay: getIt<OverlayManager>(),
      ),
    );

    Printer.printHint('[DI] ✅ Navigation registered');
  }
}

import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/navigation/service/navigation_service.dart';
import 'package:onyx_todo/core/network/services/cancel_request_service.dart';

/// Watches navigation and cancels in-flight requests for routes that are left.
class RequestRouteObserver extends NavigatorObserver {
  CancelRequestService get _manager => getIt<CancelRequestService>();

  NavigationService get _navigation => getIt<NavigationService>();

  String? _routeName(Route<dynamic>? route) {
    if (route == null) return null;
    final settings = route.settings;
    if (settings.name != null && settings.name!.isNotEmpty) {
      return settings.name;
    }
    final args = settings.arguments;
    if (args is GoRouterState) {
      return args.matchedLocation;
    }
    return null;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final routeName = _routeName(route);
    Printer.print('_navigation.currentRouteName ${routeName}');
    if (routeName != null && routeName.isNotEmpty) {
      _navigation.currentRouteName = routeName;
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    final routeName = _routeName(route);
    if (routeName != null && routeName.isNotEmpty) {
      _manager.cancelRoute(routeName);
    }
    final previousRouteName = _routeName(previousRoute);
    if (previousRouteName != null && previousRouteName.isNotEmpty) {
      _navigation.currentRouteName = previousRouteName;
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    final routeName = _routeName(route);
    if (routeName != null && routeName.isNotEmpty) {
      _manager.cancelRoute(routeName);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    final oldRouteName = _routeName(oldRoute);
    if (oldRouteName != null && oldRouteName.isNotEmpty) {
      _manager.cancelRoute(oldRouteName);
    }
    final newRouteName = _routeName(newRoute);
    if (newRouteName != null && newRouteName.isNotEmpty) {
      _navigation.currentRouteName = newRouteName;
    }
  }
}

import 'dart:async';

import 'package:onyx_todo/core/navigation/ui/widgets/undefined_route_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter buildCoreRouter({
  required String initialLocation,
  required GlobalKey<NavigatorState> navigatorKey,
  required List<NavigatorObserver> observers,
  required List<RouteBase> routes,
  FutureOr<String?> Function(BuildContext context, GoRouterState state)?
  redirect,
  Widget Function(BuildContext context, GoRouterState state)? errorBuilder,
  bool debugLogDiagnostics = kDebugMode,
  int redirectLimit = 5,
}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initialLocation,
    debugLogDiagnostics: debugLogDiagnostics,
    redirectLimit: redirectLimit,
    redirect: redirect,
    observers: observers,
    errorBuilder:
        errorBuilder ??
        (context, state) => UndefinedRouteScreen(error: state.error),
    routes: routes,
  );
}

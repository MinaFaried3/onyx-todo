import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';


class NavigationObserver extends NavigatorObserver {
  /// Static access to the current route stack for context-less checks.
  static final List<Route<dynamic>> routeStack = [];
  static final Expando<String> _routeLocations = Expando('RouteLocations');

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    routeStack.add(route);
    _captureLocation(route);
    if (kDebugMode) {
      _printRouteStack('PUSH: ${_getRouteName(route)}');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    routeStack.remove(route);
    if (kDebugMode) {
      _printRouteStack('POP: ${_getRouteName(route)}');
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    routeStack.remove(route);
    if (kDebugMode) {
      _printRouteStack('REMOVE: ${_getRouteName(route)}');
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute != null) {
      routeStack.remove(oldRoute);
    }
    if (newRoute != null) {
      routeStack.add(newRoute);
      _captureLocation(newRoute);
    }
    if (kDebugMode) {
      final name = newRoute != null ? _getRouteName(newRoute) : 'Unknown';
      _printRouteStack('REPLACE: $name');
    }
  }

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    super.didStartUserGesture(route, previousRoute);
    if (kDebugMode) {
      Printer.log(
        "User gesture started on route: ${_getRouteName(route)}",
        color: ConsoleColor.yellow,
      );
    }
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    if (kDebugMode) {
      Printer.log("User gesture stopped.", color: ConsoleColor.yellow);
    }
  }

  /// Prints the current route stack with premium visual formatting.
  void _printRouteStack(String action) {
    // Determine the icon for the action
    final (icon, actionColor) = switch (action) {
      final a when a.contains('PUSH') => ('=>', ConsoleColor.brightGreen),
      final a when a.contains('POP') => ('⬅`', ConsoleColor.brightYellow),
      final a when a.contains('REPLACE') => ('< <', ConsoleColor.brightBlue),
      final a when a.contains('REMOVE') => ('x', ConsoleColor.brightRed),
      _ => ('*', ConsoleColor.cyan),
    };

    // Print Header
    Printer.log('\n┌${'─' * 50}', color: ConsoleColor.brightBlack);
    Printer.log('│ $icon [Navigation] $action', color: actionColor);
    Printer.log('├${'─' * 50}', color: ConsoleColor.brightBlack);

    // Process stack for visual deduplication
    final List<String> displayStack = [];
    for (int i = 0; i < routeStack.length; i++) {
      final name = _getRouteName(routeStack[i]);
      if (displayStack.isEmpty || displayStack.last != name) {
        displayStack.add(name);
      }
    }

    // Print Stack
    for (int i = 0; i < displayStack.length; i++) {
      final name = displayStack[i];
      final isCurrent = i == displayStack.length - 1;
      final prefix = isCurrent ? '│  ▶ ' : '│    ';
      final color = isCurrent
          ? ConsoleColor.brightCyan
          : ConsoleColor.brightBlack;
      final suffix = isCurrent ? ' (CURRENT)' : '';

      Printer.log('$prefix[$i] $name$suffix', color: color);
    }

    // Print Footer
    Printer.log('└${'─' * 50}\n', color: ConsoleColor.brightBlack);
  }

  /// Checks if a specific route name exists in the stack.
  static bool hasRoute(String routeName) {
    return routeStack.any(
      (route) => _getRouteNameFromRoute(route) == routeName,
    );
  }

  /// Resolves the route name from settings or provides a fallback.
  String _getRouteName(Route<dynamic> route) => _getRouteNameFromRoute(route);

  /// Helper to get route name from a Route object.
  static String _getRouteNameFromRoute(Route<dynamic> route) {
    // 1. Check our internal location cache (most accurate for GoRouter)
    final cachedLocation = _routeLocations[route];
    if (cachedLocation != null) {
      return cachedLocation;
    }

    final settings = route.settings;

    // 2. Try to get the explicit name
    if (settings.name != null && settings.name!.isNotEmpty) {
      return settings.name!;
    }

    // 3. Try to extract location from GoRouterState if stored in arguments
    final args = settings.arguments;
    if (args != null && args is GoRouterState) {
      return args.matchedLocation;
    }

    // 4. Fallback: use the runtime type but make it cleaner (remove generics)
    String type = route.runtimeType.toString();
    if (type.contains('<')) {
      type = type.substring(0, type.indexOf('<'));
    }

    return '[$type]';
  }

  /// Attempts to capture the current GoRouter location and link it to the route.
  void _captureLocation(Route<dynamic> route) {
    try {
      if (GetIt.I.isRegistered<GoRouter>()) {
        final router = GetIt.I<GoRouter>();
        final configuration = router.routerDelegate.currentConfiguration;

        if (configuration.isEmpty) {
          return;
        }

        final location = configuration.last.matchedLocation;
        if (location.isNotEmpty) {
          _routeLocations[route] = location;
        }
      }
    } catch (e) {
      // Silently fail if router is not yet initialized or other issues
      Printer.printHint('[NavigationObserver] Failed to capture location: $e');
    }
  }
}

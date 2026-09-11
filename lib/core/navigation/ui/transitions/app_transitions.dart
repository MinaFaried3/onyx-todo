import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppTransitionType {
  material,
  cupertino,
  fade,
  rotate,
  scale,
  size,
  slide,
  sizeFade,
  none,
}

abstract final class AppTransitions {
  static const Duration _debugDuration = Duration(milliseconds: 320);
  static const Duration _releaseDuration = Duration(milliseconds: 180);

  static Page<T> buildPage<T>({
    required Widget child,
    required GoRouterState state,
    AppTransitionType type = AppTransitionType.material,
  }) {
    final transitionDuration = kDebugMode ? _debugDuration : _releaseDuration;

    switch (type) {
      case AppTransitionType.none:
        return NoTransitionPage<T>(child: child, key: state.pageKey, name: state.name ?? state.uri.path);

      case AppTransitionType.material:
        return MaterialPage<T>(child: child, key: state.pageKey, name: state.name ?? state.uri.path);

      case AppTransitionType.cupertino:
        return CupertinoPage<T>(child: child, key: state.pageKey, name: state.name ?? state.uri.path);

      case AppTransitionType.fade:
        return CustomTransitionPage<T>(
          key: state.pageKey,
          name: state.name ?? state.uri.path,
          child: child,
          transitionDuration: transitionDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );

      case AppTransitionType.rotate:
        return CustomTransitionPage<T>(
          key: state.pageKey,
          name: state.name ?? state.uri.path,
          child: child,
          transitionDuration: transitionDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Pronounced rotation for testing
            return RotationTransition(
              turns: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
        );

      case AppTransitionType.scale:
        return CustomTransitionPage<T>(
          key: state.pageKey,
          name: state.name ?? state.uri.path,
          child: child,
          transitionDuration: transitionDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              child: child,
            );
          },
        );

      case AppTransitionType.size:
        return CustomTransitionPage<T>(
          key: state.pageKey,
          name: state.name ?? state.uri.path,
          child: child,
          transitionDuration: transitionDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Align(
              alignment: .center,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: 0.0,
                child: child,
              ),
            );
          },
        );

      case AppTransitionType.slide:
        return CustomTransitionPage<T>(
          key: state.pageKey,
          name: state.name ?? state.uri.path,
          child: child,
          transitionDuration: transitionDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Clearly sliding from right
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0), // From full right
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOutCubic)),
              ),
              child: child,
            );
          },
        );

      case AppTransitionType.sizeFade:
        return CustomTransitionPage<T>(
          key: state.pageKey,
          name: state.name ?? state.uri.path,
          child: child,
          transitionDuration: transitionDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(sizeFactor: animation, child: child),
            );
          },
        );
    }
  }
}

import 'package:onyx_todo/core/navigation/ui/transitions/app_transitions.dart';
import 'package:onyx_todo/core/navigation/ui/widgets/screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


abstract final class RouteBuilderHelper {
  static Page<T> buildPage<T>({
    required GoRouterState state,
    required Widget child,
    AppTransitionType transition = AppTransitionType.material,
    List<BlocProvider> Function()? providers,
    VoidCallback? prepareModule,
    bool wrapWithScreenWidget = true,
  }) {
    // 0. Prepare DI modules if needed
    prepareModule?.call();
    // 1. Wrap with BlocProviders if provided (Lazy initialization via function)
    Widget screen = providers != null
        ? MultiBlocProvider(providers: providers(), child: child)
        : child;
    // 2. Wrap with ScreenWidget for global logic (like upgrade checks, analytics, etc.)
    if (wrapWithScreenWidget) {
      screen = ScreenWidget(
        state: state,
        child: screen,
      );
    }
    // 3. Build the page using centralized transitions
    return AppTransitions.buildPage<T>(
      child: screen,
      state: state,
      type: transition,
    );
  }
}

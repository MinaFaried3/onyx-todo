import 'package:onyx_todo/core/controller/cubit/base_state.dart';
import 'package:onyx_todo/core/controller/helper/app_error_handler.dart';
import 'package:onyx_todo/core/controller/helper/error_state_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A type-safe wrapper around [BlocSelector] constrained to [BaseState] hierarchies.
/// Rebuilds only when the selected value of type [T] changes, and optionally listens
/// for errors and state changes via [BlocListener].
class AppBlocSelector<B extends BlocBase<S>, S extends BaseState, T>
    extends StatelessWidget {
  final BlocWidgetSelector<S, T> selector;
  final Widget Function(BuildContext context, T state) builder;
  final B? bloc;
  final BlocWidgetListener<S>? listener;
  final bool Function(S previous, S current)? listenWhen;
  final AppErrorCallbacks? errorCallbacks;
  final bool showErrorNotification;
  final AppErrorHandler? customErrorHandler;
  final bool enableBaseListener;

  const AppBlocSelector({
    super.key,
    required this.selector,
    required this.builder,
    this.bloc,
    this.listener,
    this.listenWhen,
    this.errorCallbacks,
    this.showErrorNotification = true,
    this.customErrorHandler,
    this.enableBaseListener = true,
  });

  @override
  Widget build(BuildContext context) {
    final selectorWidget = BlocSelector<B, S, T>(
      bloc: bloc,
      selector: selector,
      builder: builder,
    );

    if (!enableBaseListener && listener == null) {
      return selectorWidget;
    }

    return BlocListener<B, S>(
      bloc: bloc,
      listenWhen: listenWhen,
      listener: (context, state) {
        if (enableBaseListener) {
          errorStateActions(
            context,
            state,
            callbacks: errorCallbacks,
            showNotification: showErrorNotification,
            customHandler: customErrorHandler,
          );
        }
        listener?.call(context, state);
      },
      child: selectorWidget,
    );
  }
}

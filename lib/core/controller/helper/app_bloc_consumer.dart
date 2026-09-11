import 'package:onyx_todo/core/controller/cubit/base_state.dart';
import 'package:onyx_todo/core/controller/helper/app_error_handler.dart';
import 'package:onyx_todo/core/controller/helper/error_state_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocConsumer<B extends BlocBase<S>, S extends BaseState>
    extends StatelessWidget {
  final BlocWidgetBuilder<S> builder;
  final BlocWidgetListener<S>? listener;
  final B? bloc;
  final bool Function(S previous, S current)? buildWhen;
  final bool Function(S previous, S current)? listenWhen;
  final AppErrorCallbacks? errorCallbacks;
  final bool showErrorNotification;
  final AppErrorHandler? customErrorHandler;
  final bool enableBaseListener;

  const AppBlocConsumer({
    super.key,
    required this.builder,
    this.listener,
    this.bloc,
    this.buildWhen,
    this.listenWhen,
    this.errorCallbacks,
    this.showErrorNotification = true,
    this.customErrorHandler,
    this.enableBaseListener = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      bloc: bloc,
      buildWhen: buildWhen,
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
      builder: builder,
    );
  }
}

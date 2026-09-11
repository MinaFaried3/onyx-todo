import 'package:onyx_todo/core/controller/cubit/base_state.dart';
import 'package:onyx_todo/core/controller/helper/app_error_handler.dart';
import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:flutter/material.dart';

/// Central error state dispatcher invoked by [AppBlocConsumer] and state handlers.
/// Delegates to the registered [AppErrorHandler] in DI or falls back to [DefaultAppErrorHandler].
void errorStateActions(
  BuildContext context,
  BaseState state, {
  AppErrorCallbacks? callbacks,
  bool showNotification = true,
  AppErrorHandler? customHandler,
}) {
  final failure = state.failure;
  if (failure == null) return;

  final handler = customHandler ??
      (getIt.isRegistered<AppErrorHandler>()
          ? getIt<AppErrorHandler>()
          : DefaultAppErrorHandler.instance);

  handler.handleError(
    context,
    failure,
    callbacks: callbacks,
    showNotification: showNotification,
  );
}

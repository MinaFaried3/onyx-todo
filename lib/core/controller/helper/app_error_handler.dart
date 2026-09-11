import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:onyx_todo/core/network/dio_factory/dio_factory.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/core/network/services/token_service.dart';
import 'package:flutter/material.dart';

/// Callbacks map allowing per-screen / per-consumer overrides for specific failure types.
class AppErrorCallbacks {
  final void Function(BuildContext context, UnauthorizedFailure failure)?
  onUnauthorized;
  final void Function(BuildContext context, ForbiddenFailure failure)?
  onForbidden;
  final void Function(
    BuildContext context,
    NoInternetConnectionFailure failure,
  )?
  onNoInternet;
  final void Function(BuildContext context, NotFoundFailure failure)?
  onNotFound;
  final void Function(BuildContext context, Failure failure)? onServerFailure;
  final void Function(BuildContext context, LocationFailure failure)?
  onLocationFailure;
  final void Function(BuildContext context, UnsecureConnectionFailure failure)?
  onUnsecureConnection;
  final void Function(BuildContext context, Failure failure)? onAnyFailure;

  const AppErrorCallbacks({
    this.onUnauthorized,
    this.onForbidden,
    this.onNoInternet,
    this.onNotFound,
    this.onServerFailure,
    this.onLocationFailure,
    this.onUnsecureConnection,
    this.onAnyFailure,
  });
}

/// Abstract contract defining how failure events, notifications, and lifecycle actions
/// (e.g. logout on 401, error toasts/snackbars) are handled across client applications.
abstract interface class AppErrorHandler {
  void handleError(
    BuildContext context,
    Failure failure, {
    AppErrorCallbacks? callbacks,
    bool showNotification = true,
  });

  void showFailureNotification(BuildContext context, Failure failure);

  void onUnauthorized(BuildContext context, UnauthorizedFailure failure);

  void onForbidden(BuildContext context, ForbiddenFailure failure);

  void onNoInternet(BuildContext context, NoInternetConnectionFailure failure);

  void onNotFound(BuildContext context, NotFoundFailure failure);

  void onServerFailure(BuildContext context, Failure failure);

  void onLocationFailure(BuildContext context, LocationFailure failure);

  void onUnsecureConnection(
    BuildContext context,
    UnsecureConnectionFailure failure,
  );

  void onUnknown(BuildContext context, Failure failure);
}

/// Default multiplatform error handler providing safe fallback behaviors.
class DefaultAppErrorHandler implements AppErrorHandler {
  const DefaultAppErrorHandler();

  static const DefaultAppErrorHandler instance = DefaultAppErrorHandler();

  @override
  void handleError(
    BuildContext context,
    Failure failure, {
    AppErrorCallbacks? callbacks,
    bool showNotification = true,
  }) {
    if (showNotification) {
      showFailureNotification(context, failure);
    }

    callbacks?.onAnyFailure?.call(context, failure);

    switch (failure) {
      case UnauthorizedFailure():
        if (callbacks?.onUnauthorized != null) {
          callbacks!.onUnauthorized!(context, failure);
        } else {
          onUnauthorized(context, failure);
        }
      case ForbiddenFailure():
        if (callbacks?.onForbidden != null) {
          callbacks!.onForbidden!(context, failure);
        } else {
          onForbidden(context, failure);
        }
      case NoInternetConnectionFailure():
        if (callbacks?.onNoInternet != null) {
          callbacks!.onNoInternet!(context, failure);
        } else {
          onNoInternet(context, failure);
        }
      case NotFoundFailure():
        if (callbacks?.onNotFound != null) {
          callbacks!.onNotFound!(context, failure);
        } else {
          onNotFound(context, failure);
        }
      case ServerFailure() ||
          InternalServerErrorFailure() ||
          NotImplementedFailure() ||
          BadRequestFailure() ||
          UnprocessableEntityFailure() ||
          PaymentRequiredFailure():
        if (callbacks?.onServerFailure != null) {
          callbacks!.onServerFailure!(context, failure);
        } else {
          onServerFailure(context, failure);
        }
      case LocationFailure():
        if (callbacks?.onLocationFailure != null) {
          callbacks!.onLocationFailure!(context, failure);
        } else {
          onLocationFailure(context, failure);
        }
      case UnsecureConnectionFailure():
        if (callbacks?.onUnsecureConnection != null) {
          callbacks!.onUnsecureConnection!(context, failure);
        } else {
          onUnsecureConnection(context, failure);
        }
      case UnKnownFailure():
        onUnknown(context, failure);
    }
  }

  @override
  void showFailureNotification(BuildContext context, Failure failure) {
    if (failure.message.isEmpty) return;
    context.safeShowSnackBar(SnackBar(content: Text(failure.message)));
  }

  @override
  void onUnauthorized(BuildContext context, UnauthorizedFailure failure) {
    Printer.print(
      'UnauthorizedFailure handled by DefaultAppErrorHandler',
      color: ConsoleColor.yellow,
    );
    if (getIt.isRegistered<TokenService>()) {
      getIt<TokenService>().clearTokens();
    }
    if (getIt.isRegistered<DioFactory>()) {
      getIt<DioFactory>().refreshBaseHeaders();
    }
  }

  @override
  void onForbidden(BuildContext context, ForbiddenFailure failure) {
    Printer.print(
      'ForbiddenFailure: ${failure.message}',
      color: ConsoleColor.yellow,
    );
  }

  @override
  void onNoInternet(BuildContext context, NoInternetConnectionFailure failure) {
    Printer.print(
      'NoInternetConnectionFailure: ${failure.message}',
      color: ConsoleColor.yellow,
    );
  }

  @override
  void onNotFound(BuildContext context, NotFoundFailure failure) {
    Printer.print(
      'NotFoundFailure: ${failure.message}',
      color: ConsoleColor.yellow,
    );
  }

  @override
  void onServerFailure(BuildContext context, Failure failure) {
    Printer.print(
      '${failure.runtimeType}: ${failure.message}',
      color: ConsoleColor.red,
    );
  }

  @override
  void onLocationFailure(BuildContext context, LocationFailure failure) {
    Printer.print(
      'LocationFailure: ${failure.message}',
      color: ConsoleColor.redBg,
    );
  }

  @override
  void onUnsecureConnection(
    BuildContext context,
    UnsecureConnectionFailure failure,
  ) {
    Printer.print(
      'UnsecureConnectionFailure: ${failure.message}',
      color: ConsoleColor.redBg,
    );
  }

  @override
  void onUnknown(BuildContext context, Failure failure) {
    Printer.print(
      'UnKnownFailure: ${failure.message}',
      color: ConsoleColor.red,
    );
  }
}

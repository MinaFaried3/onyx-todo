import 'package:dio/dio.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:onyx_todo/core/navigation/service/navigation_service.dart';
import 'package:onyx_todo/core/network/services/cancel_request_service.dart';

/// Keys used in [RequestOptions.extra] for customization of cancellation behavior.
class RequestExtraKeys {
  static const String skipCancellation = 'skipCancellation';
  static const String route = 'route';
}

/// Attaches a route-scoped [CancelToken] to every outgoing request automatically.
class CancelTokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.cancelToken != null ||
        options.extra[RequestExtraKeys.skipCancellation] == true) {
      handler.next(options);
      return;
    }
    try {
      final routeName =
          options.extra[RequestExtraKeys.route] as String? ??
          getIt<NavigationService>().currentRouteName;
      if (routeName != null && routeName.isNotEmpty) {
        final token = getIt<CancelRequestService>().createToken(routeName);
        options.cancelToken = token;
      }
    } catch (e) {
      Printer.printHint('CancelTokenInterceptor: failed to attach token: $e');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _pruneToken(response.requestOptions);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _pruneToken(err.requestOptions);
    if (err.type == DioExceptionType.cancel) {
      return handler.reject(err);
    }
    handler.next(err);
  }

  void _pruneToken(RequestOptions options) {
    final token = options.cancelToken;
    if (token == null) return;
    final routeName =
        options.extra[RequestExtraKeys.route] as String? ??
        getIt<NavigationService>().currentRouteName;
    if (routeName != null && routeName.isNotEmpty) {
      getIt<CancelRequestService>().removeToken(routeName, token);
    }
  }
}

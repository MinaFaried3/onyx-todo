import 'dart:async';

import 'package:dio/dio.dart';
import 'package:onyx_todo/core/network/services/token_service.dart';

/// A global stream that the app listens to for forcing logout/navigation.
/// Wire this into your router or root widget.

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final TokenService tokenService;

  AuthInterceptor({required this.dio, required this.tokenService});

  Completer<void>? _refreshCompleter;

  // =========================
  // REQUEST
  // =========================
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // ✅ FIX: else-if prevents double-refresh after waiting
      final refreshCompleter = _refreshCompleter;
      if (refreshCompleter != null) {
        await refreshCompleter.future;
      } else {
        final rToken = await tokenService.refreshToken;
        if (rToken != null && await tokenService.shouldRefreshAccessToken()) {
          await _refreshToken();
        }
      }

      final token = await tokenService.accessToken;
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      handler.next(options);
    } on AuthExpiredException {
      // ✅ FIX: typed catch so session expiry is handled explicitly
      AuthEventBus.instance.emit(AuthEvent.sessionExpired);
      handler.reject(
        DioException(
          requestOptions: options,
          error: const AuthExpiredException(),
          type: DioExceptionType.badResponse,
        ),
      );
    } catch (e) {
      handler.reject(DioException(requestOptions: options, error: e));
    }
  }

  // =========================
  // ERROR (401 HANDLING)
  // =========================
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    if (err.requestOptions.extra['retry'] == true) {
      return handler.next(err);
    }

    try {
      await _refreshToken();
      final response = await _retry(err.requestOptions);
      handler.resolve(response);
    } on AuthExpiredException {
      // ✅ FIX: tokens already cleared in _refreshToken — no double clear
      AuthEventBus.instance.emit(AuthEvent.sessionExpired);
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const AuthExpiredException(),
          type: DioExceptionType.badResponse,
        ),
      );
    } catch (e) {
      handler.next(err);
    }
  }

  // =========================
  // REFRESH TOKEN (LOCKED)
  // =========================
  Future<void> _refreshToken() async {
    final existingCompleter = _refreshCompleter;
    if (existingCompleter != null) {
      return existingCompleter.future;
    }

    final completer = Completer<void>();
    _refreshCompleter = completer;

    try {
      final refreshToken = await tokenService.refreshToken;

      if (refreshToken == null || !(await tokenService.isRefreshTokenValid())) {
        throw const AuthExpiredException();
      }

      // await authApi.refreshToken(refreshToken).then(
      //   (response) => tokenService.saveTokens(
      //     accessToken: response.accessToken,
      //     refreshToken: response.refreshToken,
      //     accessExpiry: response.accessExpiry,
      //     refreshExpiry: response.refreshExpiry,
      //   ),
      // );

      completer.complete();
    } catch (e) {
      completer.completeError(e);
      await tokenService.clearTokens(); // single owner of clear
      rethrow;
    } finally {
      _refreshCompleter = null;
    }
  }

  // =========================
  // RETRY REQUEST
  // =========================
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final token = await tokenService.accessToken;
    final retryCount = (requestOptions.extra['retryCount'] ?? 0) as int;

    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
      extra: {
        ...requestOptions.extra,
        'retry': true,
        'retryCount': retryCount + 1,
      },
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      followRedirects: requestOptions.followRedirects,
      receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
      validateStatus: requestOptions.validateStatus,
      sendTimeout: requestOptions.sendTimeout,
      receiveTimeout: requestOptions.receiveTimeout,
    );

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
      cancelToken: requestOptions.cancelToken,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
    );
  }
}

class AuthEventBus {
  AuthEventBus._();

  static final AuthEventBus instance = AuthEventBus._();

  // late final instead of final — initialized once, never closed
  final _controller = StreamController<AuthEvent>.broadcast();

  Stream<AuthEvent> get stream => _controller.stream;

  void emit(AuthEvent event) {
    if (!_controller.hasListener) return; // silent guard if app is tearing down
    _controller.add(event);
  }
}

enum AuthEvent { sessionExpired }

class AuthExpiredException implements Exception {
  final String message;

  const AuthExpiredException([this.message = 'Session expired']);
}

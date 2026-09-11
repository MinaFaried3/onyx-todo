import 'dart:async';

import 'package:dio/dio.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/network/config/request_key_builder.dart';

/// Intercepts duplicate in-flight requests (same method, URL, query, body,
/// and filtered headers) and resolves them from the same completer instead
/// of firing them twice.
class DedupInterceptor extends Interceptor {
  // key → completer that resolves when the first request finishes
  final Map<String, Completer<Response<dynamic>>> _inFlight = {};

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip non-idempotent mutations you don't want to deduplicate
    // (uncomment if you only want to dedup GET/HEAD)
    // if (!['GET', 'HEAD'].contains(options.method.toUpperCase())) {
    //   return handler.next(options);
    // }

    final key = RequestKeyBuilder.fromOptions(options);

    if (_inFlight.containsKey(key)) {
      _log('⛔ Duplicate blocked: ${options.method} ${options.uri}');

      try {
        // Wait for the original request to finish
        final response = await _inFlight[key]!.future;

        // Clone the response with the current request's options so Dio
        // doesn't complain about mismatched requestOptions references.
        handler.resolve(
          Response(
            data: response.data,
            headers: response.headers,
            requestOptions: options,
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            isRedirect: response.isRedirect,
            redirects: response.redirects,
            extra: response.extra,
          ),
        );
      } on DioException catch (e) {
        // If the original request failed, propagate the error to duplicate
        handler.reject(
          DioException(
            requestOptions: options,
            error: e.error,
            response: e.response,
            type: e.type,
            message: e.message,
          ),
        );
      } catch (e) {
        handler.reject(DioException(requestOptions: options, error: e));
      }
      return;
    }

    // First occurrence — register it
    _inFlight[key] = Completer<Response<dynamic>>();
    // Attach the key to extra so onResponse/onError can find it
    options.extra['_dedup_key'] = key;
    _log('✅ Forwarded: ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _complete(response.requestOptions, result: response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _completeError(err.requestOptions, err);
    handler.next(err);
  }

  // ---------------------------------------------------------------------------

  void _complete(RequestOptions options, {required Response<dynamic> result}) {
    final key = options.extra['_dedup_key'] as String?;
    if (key == null) return;
    _inFlight[key]?.complete(result);
    _inFlight.remove(key);
  }

  void _completeError(RequestOptions options, DioException err) {
    final key = options.extra['_dedup_key'] as String?;
    if (key == null) return;
    _inFlight[key]?.completeError(err);
    _inFlight.remove(key);
  }

  void _log(String message) {
    Printer.print('[DedupInterceptor] $message');
  }
}

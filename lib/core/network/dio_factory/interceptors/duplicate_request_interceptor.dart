import 'package:dio/dio.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/network/config/request_key_builder.dart';

//use this or [DedupInterceptor]
class DuplicateRequestInterceptor extends Interceptor {
  final Map<String, CancelToken> _activeRequests = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final key = RequestKeyBuilder.fromOptions(options);

    if (_activeRequests.containsKey(key)) {
      Printer.print(
        '🚫 Duplicate request blocked: ${options.method} ${options.uri}',
      );

      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          error: 'Duplicate request',
        ),
      );
      return;
    }

    // Store key in extra so onResponse/onError can safely identify
    // the original request without re-computing the key from a
    // potentially mutated requestOptions.
    options.extra['_dedup_key'] = key;

    // ✅ Preserve caller's CancelToken — don't override it
    _activeRequests[key] = options.cancelToken ?? CancelToken();

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _removeKey(response.requestOptions);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ✅ Don't clean up for duplicate rejections — they never registered
    // a key so removing would delete the original request's slot.
    final isDuplicateRejection =
        err.type == DioExceptionType.cancel && err.error == 'Duplicate request';

    if (!isDuplicateRejection) {
      _removeKey(err.requestOptions);
    }

    handler.next(err);
  }

  void _removeKey(RequestOptions options) {
    final key = options.extra['_dedup_key'] as String?;
    if (key != null) {
      _activeRequests.remove(key);
    }
  }
}

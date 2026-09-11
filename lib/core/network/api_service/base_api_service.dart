import 'package:dio/dio.dart';
import 'package:onyx_todo/core/extension/empty_or_null.dart';
import 'package:onyx_todo/core/helper/typedefs.dart';

abstract class ApiService {
  const ApiService();

  Future<Response<T>> get<T>({
    required String endpoint,
    Json? body,
    Json? formDataBody,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    int? timeout,
  });

  Future<Response<T>> post<T>({
    required String endpoint,
    Json? body,
    Json? formDataBody,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    int? timeout,
  });

  Future<Response<T>> delete<T>({
    required String endpoint,
    Json? body,
    Json? formDataBody,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    int? timeout,
  });

  Future<Response<T>> put<T>({
    required String endpoint,
    Json? body,
    Json? formDataBody,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    int? timeout,
  });

  Future<Response<T>> patch<T>({
    required String endpoint,
    Json? body,
    Json? formDataBody,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    int? timeout,
  });
}

class DioApiService extends ApiService {
  final Dio dio;

  const DioApiService(this.dio);

  // ---------------------------
  // INTERNAL CORE METHOD
  // ---------------------------
  Future<Response<T>> _request<T>({
    required String method,
    required String endpoint,
    Json? body,
    Json? formDataBody,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    int? timeout,
  }) async {
    // 🚨 SAFETY ASSERTION
    assert(
      !(body.isNotNull && formDataBody.isNotNull),
      'You cannot pass both body and formDataBody at the same time.',
    );

    if (body.isNotNull && formDataBody.isNotNull) {
      throw ArgumentError(
        'You cannot pass both body and formDataBody at the same time.',
      );
    }

    final finalHeaders = _prepareHeaders(formDataBody, headers);

    final options = Options(
      method: method,
      headers: finalHeaders,
      extra: extra,
      sendTimeout: timeout != null
          ? Duration(milliseconds: timeout)
          : dio.options.sendTimeout,
      receiveTimeout: timeout != null
          ? Duration(milliseconds: timeout)
          : dio.options.receiveTimeout,
    );

    dynamic data = _prepareBody(formDataBody, body);

    return dio.request<T>(
      endpoint,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  dynamic _prepareBody(Json? formDataBody, Json? jsonBody) {
    if (formDataBody != null) {
      return FormData.fromMap(formDataBody);
    }
    return jsonBody;
  }

  Map<String, dynamic> _prepareHeaders(
    Json? formDataBody,
    Map<String, dynamic>? headers,
  ) {
    final headersMap = {...dio.options.headers, ...?headers};

    if (formDataBody == null) {
      headersMap.putIfAbsent(
        Headers.contentTypeHeader,
        () => Headers.jsonContentType,
      );
    }

    return headersMap;
  }

  // ---------------------------
  // GET
  // ---------------------------
  @override
  Future<Response<T>> get<T>({
    required String endpoint,
    Json? body,
    Json? formDataBody,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    int? timeout,
  }) {
    return _request<T>(
      method: 'GET',
      endpoint: endpoint,
      body: body,
      formDataBody: formDataBody,
      query: query,
      headers: headers,
      extra: extra,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      timeout: timeout,
    );
  }

  // ---------------------------
  // POST
  // ---------------------------
  @override
  Future<Response<T>> post<T>({
    required String endpoint,
    Json? body,
    Json? formDataBody,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    int? timeout,
  }) {
    return _request<T>(
      method: 'POST',
      endpoint: endpoint,
      body: body,
      formDataBody: formDataBody,
      query: query,
      headers: headers,
      extra: extra,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      timeout: timeout,
    );
  }

  // ---------------------------
  // PUT
  // ---------------------------
  @override
  Future<Response<T>> put<T>({
    required String endpoint,
    Json? body,
    Json? formDataBody,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    int? timeout,
  }) {
    return _request<T>(
      method: 'PUT',
      endpoint: endpoint,
      body: body,
      formDataBody: formDataBody,
      query: query,
      headers: headers,
      extra: extra,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      timeout: timeout,
    );
  }

  // ---------------------------
  // DELETE
  // ---------------------------
  @override
  Future<Response<T>> delete<T>({
    required String endpoint,
    Json? body,
    Json? formDataBody,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    int? timeout,
  }) {
    return _request<T>(
      method: 'DELETE',
      endpoint: endpoint,
      body: body,
      formDataBody: formDataBody,
      query: query,
      headers: headers,
      extra: extra,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      timeout: timeout,
    );
  }

  // ---------------------------
  // PATCH
  // ---------------------------
  @override
  Future<Response<T>> patch<T>({
    required String endpoint,
    Json? body,
    Json? formDataBody,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    int? timeout,
  }) {
    return _request<T>(
      method: 'PATCH',
      endpoint: endpoint,
      body: body,
      formDataBody: formDataBody,
      query: query,
      headers: headers,
      extra: extra,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      timeout: timeout,
    );
  }
}

import 'package:dio/dio.dart';
import 'package:firebase_performance/firebase_performance.dart';

class DioFirebasePerformanceInterceptor extends Interceptor {
  DioFirebasePerformanceInterceptor({
    this.requestContentLengthMethod = defaultRequestContentLength,
    this.responseContentLengthMethod = defaultResponseContentLength,
    this.requestUrlBuilder = defaultRequestUrl,
  });

  final RequestContentLengthMethod requestContentLengthMethod;
  final ResponseContentLengthMethod responseContentLengthMethod;
  final RequestUrlBuilder requestUrlBuilder;
  static const extraKey = 'DioFirebasePerformanceInterceptor';

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final httpMethod = options.method.asHttpMethod() ?? HttpMethod.Get;
      final metric = FirebasePerformance.instance.newHttpMetric(
        requestUrlBuilder(options),
        httpMethod,
      );
      options.extra[extraKey] = metric;
      final requestContentLength = requestContentLengthMethod(options);
      await metric.start();
      if (requestContentLength != null) {
        metric.requestPayloadSize = requestContentLength;
      }
    } catch (_) {}
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    await _stopMetric(response, response.requestOptions);
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    await _stopMetric(err.response, err.requestOptions);
    return super.onError(err, handler);
  }

  Future<void> _stopMetric(Response? response, RequestOptions options) async {
    try {
      final metric = options.extra[extraKey];
      if (metric is HttpMetric) {
        options.extra.remove(extraKey);
        metric.setResponse(response, responseContentLengthMethod);
        await metric.stop();
      }
    } catch (_) {}
  }
}

typedef RequestContentLengthMethod = int? Function(RequestOptions options);

int? defaultRequestContentLength(RequestOptions options) {
  try {
    final bodyLength = switch (options.data) {
      null => 0,
      List<int> bytes => bytes.length,
      String text => text.length,
      _ => null,
    };
    if (bodyLength == null) return null;
    return options.headers.length * 32 + bodyLength;
  } catch (_) {
    return null;
  }
}

typedef ResponseContentLengthMethod = int? Function(Response options);

int? defaultResponseContentLength(Response response) {
  try {
    final lengthHeader = response.headers[Headers.contentLengthHeader]?.first;
    final parsed = int.tryParse(lengthHeader ?? '');
    if (parsed != null && parsed > 0) return parsed;

    return switch (response.data) {
      List<int> bytes => bytes.length,
      String text => text.length,
      _ => null,
    };
  } catch (_) {
    return null;
  }
}

extension _ResponseHttpMetric on HttpMetric {
  void setResponse(
    Response? value,
    ResponseContentLengthMethod responseContentLengthMethod,
  ) {
    if (value == null) {
      return;
    }
    final responseContentLength = responseContentLengthMethod(value);
    if (responseContentLength != null) {
      responsePayloadSize = responseContentLength;
    }
    final contentType = value.headers.value.call(Headers.contentTypeHeader);
    if (contentType != null) {
      responseContentType = contentType;
    }
    if (value.statusCode != null) {
      httpResponseCode = value.statusCode;
    }
  }
}

typedef RequestUrlBuilder = String Function(RequestOptions options);

String defaultRequestUrl(RequestOptions options) {
  return options.uri.normalized();
}

extension _UriHttpMethod on Uri {
  String normalized() {
    return "$scheme://$host$path";
  }
}

extension _StringHttpMethod on String {
  HttpMethod? asHttpMethod() {
    switch (toUpperCase()) {
      case 'POST':
        return HttpMethod.Post;
      case 'GET':
        return HttpMethod.Get;
      case 'DELETE':
        return HttpMethod.Delete;
      case 'PUT':
        return HttpMethod.Put;
      case 'PATCH':
        return HttpMethod.Patch;
      case 'OPTIONS':
        return HttpMethod.Options;
      default:
        return null;
    }
  }
}

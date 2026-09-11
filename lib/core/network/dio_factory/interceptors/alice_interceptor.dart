import 'package:alice/alice.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:onyx_todo/core/notification/firebase_notification.dart';
import 'package:dio/dio.dart';


class AliceInterceptor extends AliceDioAdapter {
  AliceInterceptor(Alice alice) {
    alice.addAdapter(this);
  }
}

class AliceNotificationInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _showNotification(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _showNotification(err.response, err: err);
    handler.next(err);
  }

  void _showNotification(Response? response, {DioException? err}) {
    try {
      final req = response?.requestOptions ?? err?.requestOptions;
      if (req == null) return;

      final method = req.method.toUpperCase();
      final path = req.uri.path;
      final query = req.uri.query.isNotEmpty ? '?${req.uri.query}' : '';

      final title = '$method $path$query';

      String body;
      if (response != null) {
        body = 'Status: ${response.statusCode}';
      } else if (err != null) {
        body = 'Error: ${err.type.name} | ${err.message}';
      } else {
        body = 'No response';
      }

      NotificationService.instance.showAliceNotification(title, body);
    } catch (_) {}
  }
}

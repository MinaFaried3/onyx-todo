import 'package:onyx_todo/core/helper/typedefs.dart';
import 'package:onyx_todo/core/network/realtime/core/realtime_client.dart';

enum WsAuthMode { queryParam, header }

abstract class WebSocketClient extends RealTimeClient {
  void send(Json event);

  @override
  Future<void> connect({
    required Uri uri,
    Map<String, String>? headers,
    String? token,
    WsAuthMode authMode,
  });

  @override
  Future<void> disconnect({int? closeCode, String? closeReason});
}

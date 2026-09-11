import 'package:onyx_todo/core/network/realtime/core/realtime_client.dart';

abstract class SseClient extends RealTimeClient {
  @override
  Future<void> connect({
    required Uri uri,
    Map<String, String>? headers,
    String? lastEventId,
  });
}

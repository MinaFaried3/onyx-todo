import 'package:onyx_todo/core/network/realtime/core/connection_status.dart';
import 'package:onyx_todo/core/network/realtime/core/realtime_event.dart';

abstract class RealTimeClient {
  Stream<ConnectionStatus> get statusStream;

  ConnectionStatus get status;

  Stream<RealTimeEvent> get events;

  Future<void> connect({required Uri uri, Map<String, String>? headers});

  Future<void> disconnect();

  Future<void> dispose();
}

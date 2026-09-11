/// Real-time communication barrel - WebSocket and Server-Sent Events (SSE) abstractions and implementations.
///
/// Import this file to access real-time networking clients:
/// ```dart
/// import 'package:onyx_todo/core/network/realtime/realtime.dart';
/// ```
library;

export 'core/connection_status.dart';
export 'core/realtime_client.dart';
export 'core/realtime_config.dart';
export 'core/realtime_event.dart';
export 'sse/eventflux_sse_client.dart';
export 'sse/sse_client.dart';
export 'websocket/websocket_channel_client.dart';
export 'websocket/websocket_client.dart';

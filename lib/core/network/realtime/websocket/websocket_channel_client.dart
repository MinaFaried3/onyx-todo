import 'dart:async';
import 'dart:convert';

import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/helper/typedefs.dart';
import 'package:onyx_todo/core/network/realtime/core/connection_status.dart';
import 'package:onyx_todo/core/network/realtime/core/realtime_config.dart';
import 'package:onyx_todo/core/network/realtime/core/realtime_event.dart';
import 'package:onyx_todo/core/network/realtime/websocket/websocket_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final class WebSocketChannelClient implements WebSocketClient {
  final RealTimeConfig _config;

  WebSocketChannel? _channel;
  final _statusController = StreamController<ConnectionStatus>.broadcast();
  final _eventController = StreamController<RealTimeEvent>.broadcast();
  ConnectionStatus _status = .disconnected;
  Timer? _reconnectTimer;
  int _retryAttempt = 0;
  bool _intentionalDisconnect = false;

  Uri? _lastUri;
  Map<String, String>? _lastHeaders;
  String? _lastToken;
  WsAuthMode _lastAuthMode = .queryParam;

  WebSocketChannelClient({this._config = RealTimeConfig.defaultConfig});

  @override
  Stream<ConnectionStatus> get statusStream => _statusController.stream;

  @override
  ConnectionStatus get status => _status;

  @override
  Stream<RealTimeEvent> get events => _eventController.stream;

  @override
  Future<void> connect({
    required Uri uri,
    Map<String, String>? headers,
    String? token,
    WsAuthMode authMode = .queryParam,
  }) async {
    _intentionalDisconnect = false;
    _lastUri = uri;
    _lastHeaders = headers;
    _lastToken = token;
    _lastAuthMode = authMode;

    await _doConnect(uri, headers, token, authMode);
  }

  Future<void> _doConnect(
    Uri uri,
    Map<String, String>? headers,
    String? token,
    WsAuthMode authMode,
  ) async {
    _setStatus(.connecting);

    final effectiveUri = switch (authMode) {
      .queryParam when token != null => uri.replace(
        queryParameters: {...uri.queryParameters, 'token': token},
      ),
      _ => uri,
    };

    try {
      _channel = WebSocketChannel.connect(effectiveUri, protocols: null);
      await _channel!.ready;

      _retryAttempt = 0;
      _setStatus(.connected);
      Printer.log(
        'WebSocket connected to $effectiveUri',
        color: ConsoleColor.green,
      );

      _channel!.stream.listen(_onData, onError: _onError, onDone: _onDone);
    } catch (e) {
      Printer.log('WebSocket connection failed: $e', color: ConsoleColor.red);
      _setStatus(.disconnected);
      _scheduleReconnect();
    }
  }

  void _onData(dynamic raw) {
    try {
      final json = jsonDecode(raw as String) as Json;
      final event = RealTimeEvent.fromJson(json);
      _eventController.add(event);
    } catch (e) {
      Printer.log(
        'WebSocket event parse error: $e',
        color: ConsoleColor.yellow,
      );
    }
  }

  void _onError(Object error) {
    Printer.log('WebSocket stream error: $error', color: ConsoleColor.red);
  }

  void _onDone() {
    Printer.log(
      'WebSocket stream closed (code: ${_channel?.closeCode}, '
      'reason: ${_channel?.closeReason})',
      color: ConsoleColor.yellow,
    );
    _setStatus(.disconnected);
    if (!_intentionalDisconnect) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_intentionalDisconnect) return;
    if (!_config.shouldRetry(_retryAttempt)) {
      Printer.log(
        'WebSocket max retry attempts reached',
        color: ConsoleColor.red,
      );
      return;
    }

    final delay = _config.delayForAttempt(_retryAttempt);
    _retryAttempt++;
    _setStatus(.reconnecting);
    Printer.log(
      'WebSocket reconnecting (attempt $_retryAttempt) in ${delay.inSeconds}s',
      color: ConsoleColor.cyan,
    );

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      if (_lastUri != null && !_intentionalDisconnect) {
        _doConnect(_lastUri!, _lastHeaders, _lastToken, _lastAuthMode);
      }
    });
  }

  @override
  void send(Json event) {
    if (_status != .connected || _channel == null) {
      Printer.log(
        'WebSocket not connected, cannot send',
        color: ConsoleColor.yellow,
      );
      return;
    }
    _channel!.sink.add(jsonEncode(event));
  }

  @override
  Future<void> disconnect({int? closeCode, String? closeReason}) async {
    _intentionalDisconnect = true;
    _reconnectTimer?.cancel();
    _retryAttempt = 0;
    await _channel?.sink.close(closeCode ?? 1000, closeReason);
    _channel = null;
    _setStatus(ConnectionStatus.disconnected);
    Printer.log(
      'WebSocket disconnected intentionally',
      color: ConsoleColor.brightBlack,
    );
  }

  @override
  Future<void> dispose() async {
    await disconnect();
    await _statusController.close();
    await _eventController.close();
  }

  void _setStatus(ConnectionStatus newStatus) {
    _status = newStatus;
    if (!_statusController.isClosed) {
      _statusController.add(newStatus);
    }
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/helper/typedefs.dart';
import 'package:onyx_todo/core/network/realtime/core/connection_status.dart';
import 'package:onyx_todo/core/network/realtime/core/realtime_config.dart';
import 'package:onyx_todo/core/network/realtime/core/realtime_event.dart';
import 'package:onyx_todo/core/network/realtime/sse/sse_client.dart';
import 'package:eventflux/eventflux.dart';

final class EventFluxSseClient implements SseClient {
  final RealTimeConfig _config;

  EventFlux? _eventFlux;
  final _statusController = StreamController<ConnectionStatus>.broadcast();
  final _eventController = StreamController<RealTimeEvent>.broadcast();
  ConnectionStatus _status = .disconnected;
  String? _lastEventId;

  Map<String, String>? _lastHeaders;

  EventFluxSseClient({this._config = RealTimeConfig.defaultConfig});

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
    String? lastEventId,
  }) async {
    _lastHeaders = headers;
    if (lastEventId != null) _lastEventId = lastEventId;

    _setStatus(.connecting);

    final effectiveHeaders = <String, String>{
      'Accept': 'text/event-stream',
      'Last-Event-ID': ?_lastEventId,
      ...?headers,
    };

    _eventFlux = EventFlux.spawn();
    _eventFlux!.connect(
      EventFluxConnectionType.get,
      uri.toString(),
      header: effectiveHeaders,
      tag: 'SseClient',
      autoReconnect: true,
      reconnectConfig: ReconnectConfig(
        mode: ReconnectMode.exponential,
        interval: _config.initialRetryDelay,
        maxAttempts: _config.maxRetryAttempts ?? -1,
        onReconnect: () {
          _setStatus(.reconnecting);
          Printer.log('SSE reconnecting to $uri', color: ConsoleColor.cyan);
        },
        reconnectHeader: () async => <String, String>{
          'Accept': 'text/event-stream',
          'Last-Event-ID': ?_lastEventId,
          ...?_lastHeaders,
        },
      ),
      onSuccessCallback: (response) {
        _setStatus(.connected);
        Printer.log('SSE connected to $uri', color: ConsoleColor.green);

        response?.stream?.listen(
          (event) {
            _processEvent(event);
          },
          onError: (error) {
            Printer.log('SSE stream error: $error', color: ConsoleColor.red);
          },
        );
      },
      onError: (error) {
        Printer.log('SSE connection error: $error', color: ConsoleColor.red);
        _setStatus(.disconnected);
      },
      onConnectionClose: () {
        Printer.log('SSE connection closed', color: ConsoleColor.yellow);
        _setStatus(.disconnected);
      },
    );
  }

  void _processEvent(EventFluxData event) {
    try {
      if (event.id.isNotEmpty) {
        _lastEventId = event.id;
      }

      final rawData = event.data;
      if (rawData.isEmpty) return;

      final Json json = jsonDecode(rawData) as Json;
      final newEvent = RealTimeEvent.fromSse(
        id: event.id,
        event: event.event,
        data: json,
      );
      _eventController.add(newEvent);
    } catch (e) {
      Printer.log('SSE event parse error: $e', color: ConsoleColor.yellow);
    }
  }

  @override
  Future<void> disconnect() async {
    _eventFlux?.disconnect();
    _eventFlux = null;
    _setStatus(.disconnected);
    Printer.log(
      'SSE disconnected intentionally',
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

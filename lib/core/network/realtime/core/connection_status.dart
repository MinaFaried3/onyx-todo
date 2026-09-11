enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  reconnecting;

  bool get isConnected => this == .connected;
  bool get isDisconnected => this == .disconnected;
  bool get isReconnecting => this == .reconnecting;
  bool get isConnecting => this == .connecting;
}

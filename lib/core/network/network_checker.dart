import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

abstract class NetworkChecker extends Equatable {
  Future<bool> get isConnected;
}

class NetworkCheckerImpl extends NetworkChecker {
  final Connectivity _connection;
  static const _cacheDuration = Duration(seconds: 3);

  bool? _cachedResult;
  DateTime? _lastCheckedAt;

  NetworkCheckerImpl({required Connectivity connectionChecker})
    : _connection = connectionChecker;

  @override
  Future<bool> get isConnected async {
    final now = DateTime.now();
    final lastCheckedAt = _lastCheckedAt;
    final cachedResult = _cachedResult;
    if (cachedResult != null &&
        lastCheckedAt != null &&
        now.difference(lastCheckedAt) < _cacheDuration) {
      return cachedResult;
    }

    final result = await _hasConnection;
    _cachedResult = result;
    _lastCheckedAt = now;
    return result;
  }

  Future<bool> get _hasConnection async {
    final results = await _connection.checkConnectivity();
    return results.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.vpn);
  }

  @override
  List<Object> get props => [isConnected, _connection];
}

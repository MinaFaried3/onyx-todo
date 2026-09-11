import 'package:dio/dio.dart';

/// Stores and cancels [CancelToken]s grouped by route/tab key.
class CancelRequestService {
  final Map<String, List<CancelToken>> _tokens = {};

  /// Creates and registers a new [CancelToken] for the given [key].
  CancelToken createToken(String key) {
    final token = CancelToken();
    _tokens.putIfAbsent(key, () => []).add(token);
    return token;
  }

  /// Cancels all active tokens associated with the given [key].
  void cancelRoute(String key) {
    final tokens = _tokens[key];
    if (tokens == null) return;
    for (final token in tokens) {
      if (!token.isCancelled) {
        token.cancel('Request cancelled: leaving $key');
      }
    }
    _tokens.remove(key);
  }

  /// Cancels all active tokens across all routes.
  void cancelAll() {
    for (final entry in _tokens.entries) {
      for (final token in entry.value) {
        if (!token.isCancelled) {
          token.cancel('ALL requests cancelled');
        }
      }
    }
    _tokens.clear();
  }

  /// Returns the number of active requests currently tracked for [key].
  int getActiveRequestsCount(String key) => _tokens[key]?.length ?? 0;

  /// Removes a specific [token] from the list for [key].
  /// Called after a request completes (success or error) to prevent memory leaks.
  void removeToken(String key, CancelToken token) {
    final tokens = _tokens[key];
    if (tokens == null) return;
    tokens.remove(token);
    if (tokens.isEmpty) {
      _tokens.remove(key);
    }
  }
}

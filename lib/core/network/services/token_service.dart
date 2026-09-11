import 'package:onyx_todo/core/config/platform/platform.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

class TokenService {
  final FlutterSecureStorage _secureStorage;

  const TokenService(this._secureStorage);

  final _accessTokenKey = 'access_token';
  final _refreshTokenKey = 'refresh_token';
  final _accessExpiryKey = 'access_expiry';
  final _refreshExpiryKey = 'refresh_expiry';

  Box? get _webBox {
    try {
      if (getIt.isRegistered<Box>()) {
        return getIt<Box>();
      }
    } catch (_) {}
    return null;
  }

  // ===== SAVE =====
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime accessExpiry,
    required DateTime refreshExpiry,
  }) async {
    if (CurrentPlatform.isWeb) {
      final box = _webBox;
      if (box != null) {
        await Future.wait([
          box.put(_accessTokenKey, accessToken),
          box.put(_refreshTokenKey, refreshToken),
          box.put(_accessExpiryKey, accessExpiry.toIso8601String()),
          box.put(_refreshExpiryKey, refreshExpiry.toIso8601String()),
        ]);
      }
      return;
    }

    try {
      await Future.wait([
        _secureStorage.write(key: _accessTokenKey, value: accessToken),
        _secureStorage.write(key: _refreshTokenKey, value: refreshToken),
        _secureStorage.write(
          key: _accessExpiryKey,
          value: accessExpiry.toIso8601String(),
        ),
        _secureStorage.write(
          key: _refreshExpiryKey,
          value: refreshExpiry.toIso8601String(),
        ),
      ]);
    } catch (e) {
      Printer.print("TokenService.saveTokens error: $e, type: ${e.runtimeType}");
    }
  }

  // ===== GETTERS =====
  Future<String?> get accessToken async {
    if (CurrentPlatform.isWeb) {
      return _webBox?.get(_accessTokenKey) as String?;
    }
    try {
      return await _secureStorage.read(key: _accessTokenKey);
    } catch (e) {
      Printer.print("TokenService.accessToken error: $e, type: ${e.runtimeType}");
      return null;
    }
  }

  Future<String?> get refreshToken async {
    if (CurrentPlatform.isWeb) {
      return _webBox?.get(_refreshTokenKey) as String?;
    }
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      Printer.print("TokenService.refreshToken error: $e, type: ${e.runtimeType}");
      return null;
    }
  }

  Future<DateTime?> get accessExpiry async {
    if (CurrentPlatform.isWeb) {
      final value = _webBox?.get(_accessExpiryKey) as String?;
      return value != null ? DateTime.tryParse(value) : null;
    }
    try {
      final value = await _secureStorage.read(key: _accessExpiryKey);
      return value != null ? DateTime.tryParse(value) : null;
    } catch (e) {
      Printer.print("TokenService.accessExpiry error: $e, type: ${e.runtimeType}");
      return null;
    }
  }

  Future<DateTime?> get refreshExpiry async {
    if (CurrentPlatform.isWeb) {
      final value = _webBox?.get(_refreshExpiryKey) as String?;
      return value != null ? DateTime.tryParse(value) : null;
    }
    try {
      final value = await _secureStorage.read(key: _refreshExpiryKey);
      return value != null ? DateTime.tryParse(value) : null;
    } catch (e) {
      Printer.print("TokenService.refreshExpiry error: $e, type: ${e.runtimeType}");
      return null;
    }
  }

  // ===== FUNCTIONAL TASKOPTION GETTERS =====
  TaskOption<String> get accessTokenOption =>
      TaskOption(() async => Option.fromNullable(await accessToken));

  TaskOption<String> get refreshTokenOption =>
      TaskOption(() async => Option.fromNullable(await refreshToken));

  TaskOption<DateTime> get accessExpiryOption =>
      TaskOption(() async => Option.fromNullable(await accessExpiry));

  TaskOption<DateTime> get refreshExpiryOption =>
      TaskOption(() async => Option.fromNullable(await refreshExpiry));

  // ===== VALIDATION =====
  Future<bool> isAccessTokenValid() async {
    final expiry = await accessExpiry;
    if (expiry == null) return false;

    return DateTime.now().isBefore(expiry);
  }

  Future<bool> isRefreshTokenValid() async {
    final expiry = await refreshExpiry;
    if (expiry == null) return false;

    return DateTime.now().isBefore(expiry);
  }

  // ===== SHOULD REFRESH =====
  /// Add buffer (e.g. 1 min) to avoid edge expiration during request
  Future<bool> shouldRefreshAccessToken({
    Duration buffer = const Duration(seconds: 60),
  }) async {
    final token = await accessToken;
    if (token == null || token.isEmpty) return false;

    final expiry = await accessExpiry;
    if (expiry == null) return false;

    final now = DateTime.now();
    return now.add(buffer).isAfter(expiry);
  }

  // ===== CLEAR =====
  Future<void> clearTokens() async {
    if (CurrentPlatform.isWeb) {
      final box = _webBox;
      if (box != null) {
        await Future.wait([
          box.delete(_accessTokenKey),
          box.delete(_refreshTokenKey),
          box.delete(_accessExpiryKey),
          box.delete(_refreshExpiryKey),
        ]);
      }
      return;
    }
    try {
      await Future.wait([
        _secureStorage.delete(key: _accessTokenKey),
        _secureStorage.delete(key: _refreshTokenKey),
        _secureStorage.delete(key: _accessExpiryKey),
        _secureStorage.delete(key: _refreshExpiryKey),
      ]);
    } catch (e) {
      Printer.print("TokenService.clearTokens error: $e, type: ${e.runtimeType}");
    }
  }
}

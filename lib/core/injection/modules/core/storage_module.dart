import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onyx_todo/core/network/services/token_service.dart';
import 'package:onyx_todo/core/storage/shared_preferences/app_preferences.dart';

abstract final class StorageModule {
  /// [appId] يُستخدم لتسمية الـ vault — كل مشروع يمرر اسمه الخاص.
  /// مثال: 'Onyx_driver' | 'Onyx_customer' | 'Onyx_admin'
  static Future<void> init({required String appId}) async {
    // Initialize Hive — آمن للاستدعاء أكثر من مرة
    await Hive.initFlutter();

    // Open a Hive box for storing preferences
    final Box hiveBox = await Hive.openBox('appPreferences');

    // Register Hive Box
    getIt.lazySingletonOnce<Box>(() => hiveBox);

    // Register secure storage — vault names مبنية على appId
    getIt.lazySingletonOnce<FlutterSecureStorage>(
      () => FlutterSecureStorage(
        aOptions: AndroidOptions(
          storageNamespace: '${appId}_secure_vault',
          preferencesKeyPrefix: '${appId}_enc_',
        ),
        iOptions: const IOSOptions(
          synchronizable: false,
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
        webOptions: WebOptions(
          dbName: '${appId}_web_vault',
          publicKey: '${appId}_pub_key',
        ),
      ),
    );

    // Register token service
    getIt.lazySingletonOnce<TokenService>(
      () => TokenService(getIt<FlutterSecureStorage>()),
    );

    // Register AppPreferences
    getIt.lazySingletonOnce<AppPreferences>(
      () => AppPreferences(
        hiveBox: getIt<Box>(),
        tokenService: getIt<TokenService>(),
      ),
    );
  }
}

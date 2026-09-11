import 'dart:async';


import 'package:onyx_todo/core/config/platform/platform.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/injection/modules/core/app_module.dart';
import 'package:onyx_todo/core/injection/modules/core/firebase_module.dart';
import 'package:onyx_todo/core/injection/modules/core/network_module.dart';
import 'package:onyx_todo/core/injection/modules/core/storage_module.dart';
import 'package:onyx_todo/core/localization/constants.dart';
import 'package:onyx_todo/core/localization/language_manager.dart';
import 'package:onyx_todo/core/localization/localization_packages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'config/environments/core_config.dart';
import 'injection/modules/core/navigation_module.dart';
import 'injection/modules/feature/feature_module.dart';

// CoreConfig + all sub-configurations
export 'package:onyx_todo/core/config/environments/core_config.dart';
export 'package:onyx_todo/core/injection/modules/core/navigation_module.dart'
    show RouterBuilder;

typedef OnyxAppInitCallback = FutureOr<void> Function();

Future<void> runOnyxApp({
  required CoreConfig config,
  required RouterBuilder routerBuilder,
  required Widget child,
  OnyxAppInitCallback? onInit,
}) async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      Printer.logger('❌ FlutterError: ${details.exceptionAsString()}');
      final stack = details.stack;
      if (stack != null) {
        Printer.logger('Stack Trace:\n$stack');
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      _handleUncaughtError(error, stack);
      return true;
    };

    try {
      await EasyLocalization.ensureInitialized();
    } catch (e, stack) {
      Printer.logger('❌ EasyLocalization initialization failed: $e');
      Printer.logger('Stack Trace:\n$stack');
    }

    try {
      // OnyxCore handles Firebase init internally via FirebaseConfiguration
      await OnyxCore.initialize(
        configuration: config,
        routerBuilder: routerBuilder,
      );
      if (onInit != null) {
        await onInit();
      }
    } catch (e, stack) {
      Printer.logger('❌ OnyxCore.initialize / onInit failed: $e');
      Printer.logger('Stack Trace:\n$stack');
    }

    runApp(
      EasyLocalization(
        supportedLocales: config.supportedLocales,
        path: LocalizationManager.assetsPath,
        //todo handle this in the future
        startLocale: LocalizationConstants.defaultLocale,
        fallbackLocale: LocalizationConstants.defaultLocale,
        child: child,
      ),
    );
  }, _handleUncaughtError);
}

abstract final class OnyxCore {
  static Future<void> initialize({
    required CoreConfig configuration,
    required RouterBuilder routerBuilder,
  }) async {
    await AppModule.init(configuration: configuration);
    await StorageModule.init(appId: configuration.appId);
    await NetworkModule.init(configuration: configuration);
    await FirebaseModule.init(configuration: configuration);
    FeatureModule.init();
    await NavigationModule.init(
      routerBuilder: routerBuilder,
      hasFirebase: configuration.hasFirebase,
    );
  }
}

void _handleUncaughtError(Object error, StackTrace stack) {
  if (_isFlutterWebError(error)) return;

  Printer.logger('❌ Uncaught Error: $error');
  Printer.logger('Stack Trace:\n$stack');
}

bool _isFlutterWebError(Object error) {
  if (!CurrentPlatform.isWeb) return false;

  final errorString = error.toString();

  if (errorString.contains('LegacyJavaScriptObject') &&
      (errorString.contains('DiagnosticsNode') ||
          errorString.contains('WidgetInspector'))) {
    return true;
  }

  if (errorString.contains('Trying to render a disposed EngineFlutterView')) {
    return true;
  }

  return false;
}

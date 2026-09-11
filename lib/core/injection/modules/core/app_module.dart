import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:onyx_todo/core/config/environments/core_config.dart';
import 'package:onyx_todo/core/config/platform/platform.dart';
import 'package:onyx_todo/core/controller/helper/bloc_observer.dart';
import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:onyx_todo/core/network/network_checker.dart';
import 'package:onyx_todo/core/platform_file_ops/core/contracts/platform_file_ops_contract.dart';
import 'package:onyx_todo/core/platform_file_ops/platform_file_ops_locator.dart';
import 'package:onyx_todo/core/utils/app_device_info/app_device_info.dart';
import 'package:onyx_todo/core/utils/app_device_info/app_device_info_impl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract final class AppModule {
  static Future<void> init({required CoreConfig configuration}) async {
    getIt.allowReassignment = true;

    getIt.lazySingletonOnce<GlobalKey<NavigatorState>>(
      () => GlobalKey<NavigatorState>(),
    );

    // Register CoreConfiguration — متاح من أي مكان عبر getIt<CoreConfiguration>()
    getIt.lazySingletonOnce<CoreConfig>(() => configuration);

    if (CurrentPlatform.isWeb) {
      final platformFileOps = createPlatformFileOps()..initializeUrlStrategy();
      getIt.lazySingletonOnce<PlatformFileOpsContract>(
        () => platformFileOps,
      );
    }

    // Network checker
    getIt.lazySingletonOnce<NetworkChecker>(
      () => NetworkCheckerImpl(connectionChecker: Connectivity()),
    );

    // App device info
    final packageInfo = await PackageInfo.fromPlatform();
    final appDeviceInfo = AppDeviceInfoImpl(
      packageInfo: packageInfo,
      deviceInfoPlugin: DeviceInfoPlugin(),
    );
    await appDeviceInfo.init();
    getIt.lazySingletonOnce<AppDeviceInfo>(() => appDeviceInfo);

    // BlocObserver — always registered in debug mode
    if (kDebugMode) {
      getIt.lazySingletonOnce<MyBlocObserver>(() => MyBlocObserver());
    }
  }
}

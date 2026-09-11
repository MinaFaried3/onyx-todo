import 'package:flutter/foundation.dart';
import 'package:onyx_todo/core/config/environments/core_config.dart';
import 'package:onyx_todo/core/config/platform/platform.dart';

/// Runtime mode information.
///
/// Depends on [CoreConfig.environment]
abstract class AppMode {
  //! Full production mode: release build + env == prod.
  static bool get prodReleaseMode =>
      kReleaseMode && CoreConfig.currEnv.isProd;

  //! Development mode: any state that is not prod release.
  static bool get devMode => !prodReleaseMode;

  static bool get devMobile => devMode && CurrentPlatform.isMobile;
  static bool get devWeb => devMode && CurrentPlatform.isWeb;
  static bool get prodMobile => prodReleaseMode && CurrentPlatform.isMobile;
  static bool get prodWeb => prodReleaseMode && CurrentPlatform.isWeb;
  static bool get devDebugMobile => kDebugMode && CurrentPlatform.isMobile;
  static bool get devDebugWeb => kDebugMode && CurrentPlatform.isWeb;
}

import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:onyx_todo/core/extension/not_nullable_extensions.dart';
import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:onyx_todo/core/storage/shared_preferences/app_preferences.dart';
import 'package:onyx_todo/core/utils/app_device_info/app_device_info.dart';
import 'package:onyx_todo/core/utils/upgrade/upgrade_buttons_type.dart';

abstract class UpgradeEventManger {
  static Map<String, Object> eventParameter(UpgradeButtonsType buttonType) => {
    'os': Platform.operatingSystem,
    'buttonType': buttonType.name,
    'version': getIt<AppDeviceInfo>().version,
    'buildNumber': getIt<AppDeviceInfo>().buildNumber,
    'installerStore': getIt<AppDeviceInfo>().installerStore.orEmpty(),
    'userId': getIt<AppPreferences>().userId,
    'time': (DateTime.now()).toIso8601String(),
  };

  static bool onUpdatePressed() {
    getIt<FirebaseAnalytics>().logEvent(
      name: 'updateButtonFromUpgradeDialogPressed',
      parameters: eventParameter(UpgradeButtonsType.updateNow),
    );
    return true;
  }

  static bool onLaterPressed() {
    getIt<FirebaseAnalytics>().logEvent(
      name: 'laterButtonFromUpgradeDialogPressed',
      parameters: eventParameter(UpgradeButtonsType.later),
    );
    return true;
  }

  static bool onIgnorePressed() {
    getIt<FirebaseAnalytics>().logEvent(
      name: 'ignoreButtonFromUpgradeDialogPressed',
      parameters: eventParameter(UpgradeButtonsType.ignore),
    );
    return true;
  }
}

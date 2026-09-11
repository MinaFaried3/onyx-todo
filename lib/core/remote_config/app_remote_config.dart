import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:onyx_todo/core/extension/bool_extension.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/network/network_checker.dart';

final class AppRemoteConfig {
  final FirebaseRemoteConfig firebaseRemoteConfig;
  final NetworkChecker networkChecker;
  StreamSubscription<RemoteConfigUpdate>? _configUpdatedSubscription;

  AppRemoteConfig({
    required this.firebaseRemoteConfig,
    required this.networkChecker,
    Map<String, dynamic>? defaultRemoteConfigKeys,
    RemoteConfigSettings? remoteConfigSettings,
  }) {
    firebaseRemoteConfig.setDefaults(
      defaultRemoteConfigKeys ?? RemoteConfigKeys.defaultRemoteConfigKeys,
    );

    firebaseRemoteConfig.setConfigSettings(
      remoteConfigSettings ??
          RemoteConfigSettings(
            fetchTimeout: Duration(seconds: 10),
            minimumFetchInterval: Duration(hours: 1),
          ),
    );
  }

  Future<void> fetchAndActivate() async {
    if ((await networkChecker.isConnected).isFalse) return;
    try {
      Printer.print('fetching from remote config .....');
      bool result = await firebaseRemoteConfig.fetchAndActivate();
      Printer.print(
        "RemoteConfig Has Been Fetched And Activated $result",
        color: ConsoleColor.brightYellow,
      );
    } catch (error) {
      Printer.print(error, color: ConsoleColor.redBg);
    }
  }

  Future<void> activate() async {
    if ((await networkChecker.isConnected).isFalse) return;
    try {
      bool result = await firebaseRemoteConfig.activate();
      Printer.print(
        "RemoteConfig Has Been Activated $result",
        color: ConsoleColor.brightYellow,
      );
    } catch (error) {
      Printer.print(error, color: ConsoleColor.redBg);
    }
  }

  Future<void> listenWhenConfigUpdated(void Function() onData) async {
    if ((await networkChecker.isConnected).isFalse) return;
    try {
      await _configUpdatedSubscription?.cancel();
      _configUpdatedSubscription = firebaseRemoteConfig.onConfigUpdated.listen((
        event,
      ) async {
        await activate();
        onData();
      });
    } catch (error) {
      Printer.print(error, color: ConsoleColor.redBg);
    }
  }

  Future<void> dispose() async {
    await _configUpdatedSubscription?.cancel();
    _configUpdatedSubscription = null;
  }

  Future<bool> getBool(String key) async {
    if ((await networkChecker.isConnected).isFalse) {
      return RemoteConfigKeys.defaultRemoteConfigKeys[key];
    }
    try {
      return firebaseRemoteConfig.getBool(key);
    } catch (error) {
      Printer.print(error, color: ConsoleColor.redBg);
      return RemoteConfigKeys.defaultRemoteConfigKeys[key];
    }
  }

  Future<double> getDouble(String key) async {
    if ((await networkChecker.isConnected).isFalse) {
      return RemoteConfigKeys.defaultRemoteConfigKeys[key];
    }
    try {
      return firebaseRemoteConfig.getDouble(key);
    } catch (error) {
      Printer.print(error, color: ConsoleColor.redBg);
      return RemoteConfigKeys.defaultRemoteConfigKeys[key];
    }
  }

  Future<int> getInt(String key) async {
    if ((await networkChecker.isConnected).isFalse) {
      return RemoteConfigKeys.defaultRemoteConfigKeys[key];
    }
    try {
      return firebaseRemoteConfig.getInt(key);
    } catch (error) {
      Printer.print(error, color: ConsoleColor.redBg);
      return RemoteConfigKeys.defaultRemoteConfigKeys[key];
    }
  }

  Future<String> getString(String key) async {
    if ((await networkChecker.isConnected).isFalse) {
      return RemoteConfigKeys.defaultRemoteConfigKeys[key];
    }

    try {
      return firebaseRemoteConfig.getString(key);
    } catch (error) {
      Printer.print(error, color: ConsoleColor.redBg);
      return RemoteConfigKeys.defaultRemoteConfigKeys[key];
    }
  }

  Future<bool> get isMaintenanceMode async =>
      getBool(RemoteConfigKeys.maintenanceMode);
}

abstract class RemoteConfigKeys {
  static const String showLaterButton = 'showLaterButton';
  static const String showIgnoreButton = 'showIgnoreButton';
  static const String showSubscriptionIos = 'showSubscriptionIos';
  static const String showBankPaymentIos = 'showBankPaymentIos';
  static const String showSubscriptionAndroid = 'showSubscriptionAndroid';
  static const String showBankPaymentAndroid = 'showBankPaymentAndroid';
  static const String maintenanceMode = 'maintenance_mode';

  static Map<String, dynamic> get defaultRemoteConfigKeys => {
    showLaterButton: true,
    showIgnoreButton: true,
    showSubscriptionIos: false,
    showBankPaymentIos: false,
    showSubscriptionAndroid: false,
    showBankPaymentAndroid: false,
    maintenanceMode: false,
  };
}

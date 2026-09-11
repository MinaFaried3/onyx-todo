import 'package:device_info_plus/device_info_plus.dart';
import 'package:onyx_todo/core/config/platform/platform.dart';

abstract interface class AppDeviceInfo {
  // Package Info
  String get appName;

  String get packageName;

  String get version;

  String get buildNumber;

  String get buildSignature;

  String get installerStore;

  // Platform-specific Raw Device Info
  BaseDeviceInfo? get osInfo;

  AndroidDeviceInfo? get android;

  IosDeviceInfo? get ios;

  WebBrowserInfo? get web;

  // General Device Info
  String get deviceName;

  String get deviceModel;

  String get osVersion;

  String get deviceId;

  String get fingerPrint;

  // Platform helper
  AppPlatform get platform;

  bool get isAndroid;

  bool get isIos;

  bool get isWeb;

  // Common Device/OS fields
  bool? get isPhysicalDevice;

  int? get freeDiskSize;

  int? get totalDiskSize;

  int? get physicalRamSize;

  int? get availableRamSize;

  // Map representation
  Map<String, dynamic> get toMap;
}

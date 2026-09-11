import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:onyx_todo/core/config/platform/platform.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';

import 'app_device_info.dart';

final class AppDeviceInfoImpl implements AppDeviceInfo {
  final PackageInfo _packageInfo;
  final DeviceInfoPlugin _deviceInfoPlugin;

  AppDeviceInfoImpl({
    required this._packageInfo,
    required this._deviceInfoPlugin,
  });
  late final String _appVersion;
  late final String _appBuildNumber;
  late final String _osVersion;
  late final String _deviceName;
  late final String _deviceId;

  AndroidDeviceInfo? _androidInfo;
  IosDeviceInfo? _iosInfo;
  WebBrowserInfo? _webBrowserInfo;

  late final String _deviceModel;

  Future<void> init() async {
    final currentPlatform = CurrentPlatform.current;

    _appVersion = _packageInfo.version;
    _appBuildNumber = _packageInfo.buildNumber;

    switch (currentPlatform) {
      case AppPlatform.web:
        _webBrowserInfo = await _deviceInfoPlugin.webBrowserInfo;
        _deviceName = _webBrowserInfo!.browserName.name;
        _deviceModel = _webBrowserInfo!.userAgent ?? 'Unknown Web Browser';
        _osVersion = _webBrowserInfo!.appVersion ?? 'Unknown OS';
        _deviceId = _webBrowserInfo!.userAgent != null
            ? _webBrowserInfo!.userAgent.hashCode.toString()
            : 'unknown-web-id';
      case AppPlatform.android:
        _androidInfo = await _deviceInfoPlugin.androidInfo;
        _deviceName = _androidInfo!.device;
        _deviceModel = _androidInfo!.model;
        _osVersion = 'Android ${_androidInfo!.version.release}';
        _deviceId = _androidInfo!.id;
      case AppPlatform.ios:
        _iosInfo = await _deviceInfoPlugin.iosInfo;
        _deviceName = _iosInfo!.name;
        _deviceModel = _iosInfo!.model;
        _osVersion = 'iOS ${_iosInfo!.systemVersion}';
        _deviceId = _iosInfo!.identifierForVendor ?? 'unknown-ios-id';
      default:
        _deviceName = currentPlatform.name;
        _deviceModel = 'Unknown';
        _osVersion = 'Unknown';
        _deviceId = 'unknown-device-id';
    }
  }

  @override
  String get appName => _packageInfo.appName;

  @override
  String get packageName => _packageInfo.packageName;

  @override
  String get version => _packageInfo.version;

  @override
  String get buildNumber => _packageInfo.buildNumber;

  @override
  String get buildSignature => _packageInfo.buildSignature;

  @override
  String get installerStore => _packageInfo.installerStore ?? '';

  @override
  BaseDeviceInfo? get osInfo {
    switch (platform) {
      case AppPlatform.android:
        return _androidInfo;
      case AppPlatform.ios:
        return _iosInfo;
      case AppPlatform.web:
        return _webBrowserInfo;
      default:
        return null;
    }
  }

  @override
  AndroidDeviceInfo? get android => _androidInfo;

  @override
  IosDeviceInfo? get ios => _iosInfo;

  @override
  WebBrowserInfo? get web => _webBrowserInfo;

  @override
  String get deviceName => _deviceName;

  @override
  String get deviceModel => _deviceModel;

  @override
  String get osVersion => _osVersion;

  @override
  String get deviceId => _deviceId;

  @override
  String get fingerPrint {
    switch (platform) {
      case AppPlatform.android:
        return '${_androidInfo?.brand}-${_androidInfo?.model}-${_androidInfo?.version.sdkInt}-${_androidInfo?.id}';
      case AppPlatform.ios:
        return 'Apple-${_iosInfo?.model}-${_iosInfo?.systemVersion}-${_iosInfo?.identifierForVendor}';
      case AppPlatform.web:
        return '${_webBrowserInfo?.browserName.name}-${_webBrowserInfo?.platform}-${_webBrowserInfo?.appVersion}-$_deviceId';
      default:
        return 'Unknown - Unknown - Unknown - $_deviceId';
    }
  }

  @override
  AppPlatform get platform => CurrentPlatform.current;

  @override
  bool get isAndroid => CurrentPlatform.isAndroid;

  @override
  bool get isIos => CurrentPlatform.isIOS;

  @override
  bool get isWeb => CurrentPlatform.isWeb;

  // Common Device/OS fields implementation
  @override
  bool? get isPhysicalDevice =>
      _androidInfo?.isPhysicalDevice ?? _iosInfo?.isPhysicalDevice;

  @override
  int? get freeDiskSize => _androidInfo?.freeDiskSize ?? _iosInfo?.freeDiskSize;

  @override
  int? get totalDiskSize =>
      _androidInfo?.totalDiskSize ?? _iosInfo?.totalDiskSize;

  @override
  int? get physicalRamSize =>
      _androidInfo?.physicalRamSize ?? _iosInfo?.physicalRamSize;

  @override
  int? get availableRamSize =>
      _androidInfo?.availableRamSize ?? _iosInfo?.availableRamSize;

  @override
  Map<String, dynamic> get toMap {
    try {
      final map = <String, dynamic>{
        'appName': appName,
        'packageName': packageName,
        'version': version,
        'buildNumber': buildNumber,
        'buildSignature': buildSignature,
        'installerStore': installerStore,
        'deviceName': deviceName,
        'deviceModel': deviceModel,
        'osVersion': osVersion,
        'deviceId': deviceId,
        'platform': platform.name,
      };
      Printer.print(map);
      return map;
    } catch (e) {
      Printer.print(e, color: ConsoleColor.red);
      return {};
    }
  }
}

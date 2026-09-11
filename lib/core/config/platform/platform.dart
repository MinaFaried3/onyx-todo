import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:onyx_todo/core/helper/typedefs.dart';

enum AppPlatform { android, ios, web, windows, macos, linux, fuchsia, unknown }

extension CurrentPlatform on AppPlatform {
  static AppPlatform get current {
    if (kIsWeb) return .web;

    return switch (defaultTargetPlatform) {
      .android => .android,
      .iOS => .ios,
      .windows => .windows,
      .macOS => .macos,
      .linux => .linux,
      .fuchsia => .fuchsia,
    };
  }

  static String get operatingSystem {
    if (kIsWeb) return AppPlatform.web.name;

    return switch (defaultTargetPlatform) {
      TargetPlatform.android => AppPlatform.android.name,
      TargetPlatform.iOS => AppPlatform.ios.name,
      TargetPlatform.windows => AppPlatform.windows.name,
      TargetPlatform.macOS => AppPlatform.macos.name,
      TargetPlatform.linux => AppPlatform.linux.name,
      TargetPlatform.fuchsia => AppPlatform.fuchsia.name,
    };
  }

  static String get name => current.name;

  static bool get isAndroid => current == .android;

  static bool get isIOS => current == .ios;

  static bool get isWeb => current == .web;

  static bool get isWindows => current == .windows;

  static bool get isMacOS => current == .macos;

  static bool get isLinux => current == .linux;

  static bool get isFuchsia => current == .fuchsia;

  static bool get isMobile => current == .android || current == .ios;

  static bool get isDesktop =>
      current == .windows || current == .macos || current == .linux;

  static bool get isApple => current == .ios || current == .macos;

  static bool get isNotApple => !isApple;

  static T? handle<T>({
    PlatformCallback<T>? onAndroid,
    PlatformCallback<T>? onIOS,
    PlatformCallback<T>? onWeb,
    PlatformCallback<T>? onWindows,
    PlatformCallback<T>? onMacOS,
    PlatformCallback<T>? onLinux,
    PlatformCallback<T>? onFuchsia,
    PlatformCallback<T>? onUnknown,
    PlatformCallback<T>? orElse,
  }) => switch (current) {
    .android => onAndroid?.call() ?? orElse!.call(),
    .ios => onIOS?.call() ?? orElse!.call(),
    .web => onWeb?.call() ?? orElse!.call(),
    .windows => onWindows?.call() ?? orElse!.call(),
    .macos => onMacOS?.call() ?? orElse!.call(),
    .linux => onLinux?.call() ?? orElse!.call(),
    .fuchsia => onFuchsia?.call() ?? orElse!.call(),
    .unknown => onUnknown?.call() ?? orElse!.call(),
  };
}

import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/responsive/break_points.dart';

extension ResponsiveExtension on BuildContext {
  // --------------------------------------------------
  // Core dimensions
  // --------------------------------------------------
  double get width => MediaQuery.sizeOf(this).width;

  double get height => MediaQuery.sizeOf(this).height;

  double get aspectRatio => MediaQuery.sizeOf(this).aspectRatio;

  // --------------------------------------------------
  // Safe area
  // --------------------------------------------------
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  double get statusBarHeight => padding.top;

  double get bottomPadding => padding.bottom;

  double get safeHeight => height - padding.top - padding.bottom;

  double get safeWidth => width - padding.left - padding.right;

  // --------------------------------------------------
  // Keyboard / insets
  // --------------------------------------------------
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  double get keyboardHeight => viewInsets.bottom;

  bool get isKeyboardOpen => keyboardHeight > 0;

  // --------------------------------------------------
  // Display
  // --------------------------------------------------
  double get pixelRatio => MediaQuery.devicePixelRatioOf(this);

  double get physicalWidth => width * pixelRatio;

  double get physicalHeight => height * pixelRatio;

  // --------------------------------------------------
  // Breakpoints
  // --------------------------------------------------
  bool get isMobile => width <= Breakpoints.mobile;

  bool get isTablet =>
      width > Breakpoints.mobile && width <= Breakpoints.tablet;

  bool get isDesktop => width > Breakpoints.tablet;

  // --------------------------------------------------
  // Orientation
  // --------------------------------------------------
  bool get isPortrait => MediaQuery.orientationOf(this) == Orientation.portrait;

  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  bool get isTabletPortrait => isTablet && isPortrait;

  bool get isTabletLandscape => isTablet && isLandscape;

  // --------------------------------------------------
  // Directionality
  // --------------------------------------------------
  bool get isRTL => Directionality.of(this) == TextDirection.rtl;

  bool get isLTR => Directionality.of(this) == TextDirection.ltr;

  TextDirection get direction => Directionality.of(this);

  // --------------------------------------------------
  // Theme / brightness
  // --------------------------------------------------
  Brightness get platformBrightness => MediaQuery.platformBrightnessOf(this);

  bool get isDarkMode => platformBrightness == Brightness.dark;

  bool get isLightMode => platformBrightness == Brightness.light;

  // --------------------------------------------------
  // Typography
  // --------------------------------------------------
  TextScaler get textScaler => MediaQuery.textScalerOf(this);

  double getWidth({
    double? ratioMobile,
    double? ratioTablet,
    double? ratioDesktop,
    double? ratioDesktopOpenSideMenu,
    bool sideMenu = false,
  }) {
    if (isMobile) return width * (ratioMobile ?? 1);
    if (isTabletPortrait) return width * (ratioTablet ?? 1);
    if (isTabletLandscape) {
      return width * (ratioDesktopOpenSideMenu ?? ratioTablet ?? 1);
    }
    if (isDesktop) {
      return width *
          (sideMenu
              ? (ratioDesktopOpenSideMenu ?? ratioTablet ?? 1)
              : (ratioDesktop ?? 1));
    }
    return width;
  }

  double getHeight({
    double? ratioMobile,
    double? ratioTablet,
    double? ratioDesktop,
    double? ratioTabletPortrait,
  }) {
    if (isMobile) return height * (ratioMobile ?? 1);
    if (isTabletPortrait) {
      return height * (ratioTabletPortrait ?? ratioTablet ?? 1);
    }
    if (isTabletLandscape) return height * (ratioTablet ?? 1);
    if (isDesktop) return height * (ratioDesktop ?? 1);
    return height;
  }

  double fontSize(double size) {
    final responsiveSize = size * scaleFactor;

    final lowerLimit = size * 0.9;
    final upperLimit = size * 1.3;

    return responsiveSize.clamp(lowerLimit, upperLimit).floorToDouble();
  }

  double get scaleFactor {
    const minWidth = 550.0;
    const maxWidth = 1920.0;
    final clampedWidth = width.clamp(minWidth, maxWidth);
    final t = (clampedWidth - minWidth) / (maxWidth - minWidth);
    return _lerp(clampedWidth / minWidth, clampedWidth / 1000.0, t);
  }

  /// Accessibility-aware font size (respects user text scale setting)
  double sp(double size) => textScaler.scale(fontSize(size));

  // --------------------------------------------------
  // Percentage helpers
  // --------------------------------------------------
  double wp(double percent) => width * percent / 100;

  double hp(double percent) => height * percent / 100;

  // --------------------------------------------------
  // Responsive value picker
  // --------------------------------------------------
  T responsiveValue<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }
}

double _lerp(double a, double b, double c) {
  return (1.0 - c) * a + c * b;
}

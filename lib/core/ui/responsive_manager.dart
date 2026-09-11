import 'package:flutter/material.dart';
import 'package:onyx_todo/core/localization/language_manager.dart';

class ContextManager {
  static late MediaQueryData mediaQueryData;
  static late Locale locale;
  static late TextDirection textDirection;

  late final double screenWidth;
  late final double screenHeight;
  late final double bodyHeight;

  // late double defaultSize;
  late final Orientation orientation;

  //default appbar height
  late final double appBarHeight;

  bool get isArabic => locale == LocalizationManager.arabicLocale;

  bool get isEnglish => locale == LocalizationManager.englishLocale;

  ContextManager(BuildContext context, {bool hasAppBar = true}) {
    mediaQueryData = MediaQuery.of(context);
    locale = Localizations.localeOf(context);
    textDirection = Directionality.of(context);

    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
    orientation = mediaQueryData.orientation;
    appBarHeight = screenHeight * 0.06639566395663957;
    bodyHeight = _calculateBodyHeight(hasAppBar);
  }

  double _calculateBodyHeight(bool hasAppBar) {
    final double baseHeight =
        screenHeight -
        mediaQueryData.viewPadding.top -
        mediaQueryData.viewPadding.bottom;

    if (hasAppBar) {
      return baseHeight - appBarHeight;
    } else {
      return baseHeight;
    }
  }

  bool isLandScape() {
    return orientation == Orientation.landscape ? true : false;
  }

  // get percentage
  double getScreenHeightPercentage(double percentage) =>
      screenHeight * percentage / 100;

  double getBodyHeightPercentage(double percentage) =>
      bodyHeight * percentage / 100;

  double getWidthPercentage(double percentage) =>
      screenWidth * percentage / 100;

  // get values based on width ,height
  double getWidthOf(double value) => screenWidth * value;

  double getScreenHeightOf(double value) => screenHeight * value;

  double getBodyHeightOf(double value) => bodyHeight * value;

  // sizedBox based on percentage
  SizedBox heightSpace(double percentageValue) =>
      SizedBox(height: getBodyHeightPercentage(percentageValue));

  SizedBox widthSpace(double percentageValue) =>
      SizedBox(width: getWidthPercentage(percentageValue));
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight, BuildContext context) {
  final sizeConfig = ContextManager(context);

  double screenHeight = sizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth, BuildContext context) {
  final sizeConfig = ContextManager(context);

  double screenWidth = sizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

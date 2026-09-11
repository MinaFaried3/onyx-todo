import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/color_manager.dart';
import 'package:onyx_todo/core/ui/font_manager.dart';

// ─── Font resolver ────────────────────────────────────────────────────────────
// Returns the correct font family for the given locale.
// Arabic → Cairo (bundled in Onyx_Onyxboard).
// Everything else → Cairo as well (Cairo covers Latin glyphs).
// Override by passing an explicit [fontFamily] to any style function.
String _resolveFont(Locale? locale) {
  if (locale?.languageCode == 'ar') return FontConstants.cairoFontFamily;
  return FontConstants.cairoFontFamily; // Cairo covers Latin too
}

// Returns the font family for the ambient locale in [context].
// Falls back to Cairo when context is null.
String fontFamilyOf([BuildContext? context]) {
  final locale = context != null ? Localizations.localeOf(context) : null;
  return _resolveFont(locale);
}

// ─── Core builder ─────────────────────────────────────────────────────────────
TextStyle _getTextStyle(
  double fontSize,
  FontWeight fontWeight,
  Color color, {
  String? fontFamily,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: fontFamily ?? FontConstants.cairoFontFamily,
    color: color,
    fontWeight: fontWeight,
  );
}

// ─── Style functions ──────────────────────────────────────────────────────────
// Each function accepts an optional [fontFamily] so callers can pass
// fontFamilyOf(context) when they need locale-aware font switching.

TextStyle get200ExtraLightStyle({
  double fontSize = FontSize.s10,
  Color color = ColorsManager.darkTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize, FontWeightManager.extraLight, color, fontFamily: fontFamily);

TextStyle get300LightStyle({
  double fontSize = FontSize.s12,
  Color color = ColorsManager.darkTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize, FontWeightManager.light, color, fontFamily: fontFamily);

TextStyle get400RegularStyle({
  double fontSize = FontSize.s14,
  Color color = ColorsManager.darkTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize, FontWeightManager.regular, color, fontFamily: fontFamily);

TextStyle get500MediumStyle({
  double? fontSize = FontSize.s16,
  Color color = ColorsManager.darkTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize ?? FontSize.s16, FontWeightManager.medium, color, fontFamily: fontFamily);

TextStyle get600SemiBoldStyle({
  double fontSize = FontSize.s16,
  Color color = ColorsManager.darkTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize, FontWeightManager.semiBold, color, fontFamily: fontFamily);

TextStyle get700BoldStyle({
  double? fontSize = FontSize.s16,
  Color color = ColorsManager.darkTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize ?? FontSize.s16, FontWeightManager.bold, color, fontFamily: fontFamily);

TextStyle get800ExtraBoldStyle({
  double fontSize = FontSize.s16,
  Color color = ColorsManager.darkTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize, FontWeightManager.extraBold, color, fontFamily: fontFamily);

TextStyle get900BlackStyle({
  double fontSize = FontSize.s16,
  Color color = ColorsManager.darkTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize, FontWeightManager.black, color, fontFamily: fontFamily);

TextStyle getHeading1Style({
  double fontSize = FontSize.s24,
  Color color = ColorsManager.darkTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize, FontWeightManager.bold, color, fontFamily: fontFamily);

TextStyle getHeading1GreyStyle({
  double fontSize = FontSize.s24,
  Color color = ColorsManager.greyTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize, FontWeightManager.bold, color, fontFamily: fontFamily);

TextStyle getHeading2Style({
  double fontSize = FontSize.s20,
  Color color = ColorsManager.darkTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize, FontWeightManager.bold, color, fontFamily: fontFamily);

TextStyle getHeading3Style({
  double fontSize = FontSize.s16,
  Color color = ColorsManager.darkTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize, FontWeightManager.bold, color, fontFamily: fontFamily);

TextStyle getText1Style({
  double fontSize = FontSize.s16,
  Color color = ColorsManager.greyTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize, FontWeightManager.medium, color, fontFamily: fontFamily);

TextStyle getNumberStyle({
  double fontSize = FontSize.s24,
  Color color = ColorsManager.bluePrimary,
  String? fontFamily,
}) => _getTextStyle(fontSize, FontWeightManager.bold, color, fontFamily: fontFamily);

TextStyle getText2Style({
  double fontSize = FontSize.s14,
  Color color = ColorsManager.darkTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize, FontWeightManager.bold, color, fontFamily: fontFamily);

TextStyle getText3Style({
  double fontSize = FontSize.s14,
  Color color = ColorsManager.greyTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize, FontWeightManager.bold, color, fontFamily: fontFamily);

TextStyle getText4Style({
  double fontSize = FontSize.s14,
  Color color = ColorsManager.greyTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize, FontWeightManager.medium, color, fontFamily: fontFamily);

TextStyle getText5Style({
  double fontSize = FontSize.s12,
  Color color = ColorsManager.greyTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize, FontWeightManager.medium, color, fontFamily: fontFamily);

TextStyle getNavigationTextStyle({
  double fontSize = FontSize.s10,
  Color color = ColorsManager.greyTextColor,
  String? fontFamily,
}) => _getTextStyle(fontSize, FontWeightManager.medium, color, fontFamily: fontFamily);

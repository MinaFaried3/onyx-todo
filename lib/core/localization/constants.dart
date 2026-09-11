import 'package:onyx_todo/core/localization/language_manager.dart';
import 'package:flutter/material.dart';

abstract class LocalizationConstants {
  static const LanguageType defaultLang = LanguageType.arabic;
  static final Locale defaultLocale = defaultLang.locale;
}
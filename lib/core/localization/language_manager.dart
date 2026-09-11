import 'package:flutter/material.dart';

const String ar = "ar";
const String en = "en";

const String egCountry = 'EG';
const String usCountry = 'US';


enum LanguageType { 
  arabic(ar, egCountry, LocalizationManager.arabicLocale),
  english(en, usCountry, LocalizationManager.englishLocale);


  final String lang;
  final String country;
  final Locale locale;

  const LanguageType(this.lang, this.country, this.locale);

  static LanguageType fromString(String value) {
    return LanguageType.values.firstWhere(
      (langType) =>
          langType.lang == value || langType.getLangWithCountry() == value,
      orElse: () => LanguageType.english, // Default fallback
    );
  }

  static final String langSeparator = '-';
}

extension GetLanguage on LanguageType {
  String getValue() {
    return lang;
  }

  String getLangWithCountry() {
    if (country.isEmpty) {
      return lang;
    }
    return "$lang${LanguageType.langSeparator}$country";
  }

  static LanguageType get defaultLang => LanguageType.english;
}

class LocalizationManager {
  static const Locale arabicLocale = Locale(ar, egCountry);
  static const Locale englishLocale = Locale(en, usCountry);


  static const List<Locale> supportedLocales = [arabicLocale,englishLocale];

  static const String assetsPath = "assets/translation";

  static Locale getLangLocal(String langCountry) {
    final languageType = LanguageType.fromString(langCountry);
    return switch (languageType) {
      LanguageType.arabic  => arabicLocale,
      LanguageType.english => englishLocale,
    };
  }
}

class ArabicNumbers {
  static String convert(Object value) {
    assert(
      value is int || value is String || value is num || value is double,
      "The value object must be of type 'int','num' or 'String'.",
    );

    if (value is num) {
      return _toArabicNumbers(value.toString());
    } else {
      return _toArabicNumbers(value as String);
    }
  }

  static String _toArabicNumbers(String value) {
    return value
        .replaceAll('0', '٠')
        .replaceAll('.', ',')
        .replaceAll('1', '١')
        .replaceAll('2', '٢')
        .replaceAll('3', '٣')
        .replaceAll('4', '٤')
        .replaceAll('5', '٥')
        .replaceAll('6', '٦')
        .replaceAll('7', '٧')
        .replaceAll('8', '٨')
        .replaceAll('9', '٩');
  }
}

extension IntExtensions on int {
  /// Converts English numbers to the Arabic numbers format
  ///
  ///
  /// Example:
  /// ```dart
  /// final arabicNumbers = 0123456789.toArabicNumbers;
  /// // result: ٠١٢٣٤٥٦٧٨٩
  /// ```
  String get toArabicNumbers {
    return ArabicNumbers.convert(this);
  }
}

extension DoubleExtensions on double {
  /// Converts English numbers to the Arabic numbers format
  ///
  ///
  /// Example:
  /// ```dart
  /// final arabicNumbers = 0123456789.toArabicNumbers;
  /// // result: ٠١٢٣٤٥٦٧٨٩
  /// ```
  String get toArabicNumbers {
    return ArabicNumbers.convert(this);
  }
}

extension NumExtensions on num {
  /// Converts English numbers to the Arabic numbers format
  ///
  ///
  /// Example:
  /// ```dart
  /// final arabicNumbers = 0123456789.toArabicNumbers;
  /// // result: ٠١٢٣٤٥٦٧٨٩
  /// ```
  String get toArabicNumbers {
    return ArabicNumbers.convert(this);
  }
}

extension StringExtensions on String {
  /// Converts English numbers to the Arabic numbers format
  ///
  ///
  /// Example:
  /// ```dart
  /// final arabicNumbers = '0123456789'.toArabicNumbers;
  /// // result: ٠١٢٣٤٥٦٧٨٩
  /// ```
  String get toArabicNumbers {
    return ArabicNumbers.convert(this);
  }
}

extension StringNullableExtensions on String? {
  /// Converts English numbers to the Arabic numbers format
  ///
  ///
  /// Example:
  /// ```dart
  /// final arabicNumbers = '0123456789'.toArabicNumbers;
  /// // result: ٠١٢٣٤٥٦٧٨٩
  /// ```
  String? get toArabicNumbers {
    return ArabicNumbers.convert(this ?? '');
  }
}

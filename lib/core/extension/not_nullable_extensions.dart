

extension NonNullableInt on int? {
  int orZero() {
    if (this == null) {
      return 0;
    }
    return this!;
  }
}

extension NonNullableDouble on double? {
  double orZero() {
    if (this == null) {
      return 0.toDouble();
    }
    return this!;
  }
}

extension NonNullableString on String? {
  String orEmpty() {
    if (this == null) return '';
    return this!;
  }
}

extension NonNullableBool on bool? {
  bool orFalse() {
    if (this == null) return false;
    return this!;
  }
}

extension NonNullableList on List? {
  List orEmpty() {
    if (this == null) return const [];
    return this!;
  }
}

extension NonNullableMap on Map? {
  Map orEmpty() {
    if (this == null) return const {};
    return this!;
  }
}

extension NonNullableSet on Set? {
  Set orEmpty() {
    if (this == null) return const {};
    return this!;
  }
}

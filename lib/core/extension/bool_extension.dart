extension BoolNullExtension on bool? {
  bool get isTrue => this == true;

  bool get isFalse => this == false;

  bool get isNull => this == null;

  bool get isFalseOrNull => this == false || this == null;

  bool get isTrueOrNull => this == true || this == null;
}

extension Invert on bool {
  bool get invert => !this;
}

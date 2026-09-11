extension EmptyOrNullIterable on Iterable? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get hasValue => !isNullOrEmpty;
}

extension EmptyOrNullMap on Map? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get hasValue => !isNullOrEmpty;
}

extension EmptyOrNullString on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get hasValue => !isNullOrEmpty;

  String get fromNullToEmpty => this ?? '';
}

extension EmptyOrNullNum on int? {
  int get fromNullToEmpty => this ?? 0;
}

extension IsNull on Object? {
  bool get isNull => this == null;
  bool get isNotNull => this != null;
}

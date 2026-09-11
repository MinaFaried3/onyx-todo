import 'package:onyx_todo/core/localization/core_strings.dart';
import 'package:easy_localization/easy_localization.dart';

enum AppGender {
  male(0, key: CoreStrings.male),
  female(1, key: CoreStrings.female);

  const AppGender(this.id, {required this.key});

  final int id;
  final String key;

  int get value => id;

  /// Returns the localized display name using easy_localization.
  String get label => key.tr();

  // ── Factories ──────────────────────────────────────────────────────────────

  /// Parse from integer ID (0 = male, 1 = female).
  static AppGender fromId(int? id) {
    if (id == null) return .male;
    return values.firstWhere((g) => g.id == id, orElse: () => .male);
  }

  static AppGender fromValue(int? value) => fromId(value);

  /// Parse from string ('male', 'female', '0', '1').
  static AppGender fromString(String? value) {
    if (value == null) return .male;
    final intVal = int.tryParse(value);
    if (intVal != null) return fromId(intVal);

    final lower = value.trim().toLowerCase();
    return values.firstWhere(
      (g) => g.name == lower || g.key == lower,
      orElse: () => .male,
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  bool get isMale => this == .male;

  bool get isFemale => this == .female;

  int toJson() => id;
}


import 'package:equatable/equatable.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/feature/workspace/domain/entities/screen_leaf.dart';

class SubModuleEntity extends Equatable {
  final String id;
  final String nameAr;
  final String nameEn;
  final List<ScreenLeaf> screens;

  const SubModuleEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.screens = const [],
  });

  /// Screens belonging to a specific screen type
  List<ScreenLeaf> screensForType(ScreenType type) {
    return screens.where((s) => s.screenType == type).toList();
  }

  /// Outer scope 1: Screen Type Average Percentage
  double progressForType(ScreenType type) {
    final typeScreens = screensForType(type);
    if (typeScreens.isEmpty) return 0.0;
    final total = typeScreens.fold<double>(0.0, (sum, s) => sum + s.overallProgress);
    return total / typeScreens.length;
  }

  /// Outer scope 2: Sub-Module Average Percentage
  /// Average across the 4 standard screen types (Config, Inputs, Transaction, Reports)
  /// that contain screens (or all 4 if any exist).
  double get subModuleProgress {
    if (screens.isEmpty) return 0.0;
    final activeTypes = ScreenType.values.where((t) => screensForType(t).isNotEmpty).toList();
    if (activeTypes.isEmpty) return 0.0;
    final sum = activeTypes.fold<double>(0.0, (acc, t) => acc + progressForType(t));
    return sum / activeTypes.length;
  }

  @override
  List<Object?> get props => [id, nameAr, nameEn, screens];

  SubModuleEntity copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    List<ScreenLeaf>? screens,
  }) {
    return SubModuleEntity(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      screens: screens ?? this.screens,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'screens': screens.map((e) => e.toMap()).toList(),
    };
  }

  factory SubModuleEntity.fromMap(Map<String, dynamic> map) {
    return SubModuleEntity(
      id: map['id'] as String? ?? '',
      nameAr: map['nameAr'] as String? ?? '',
      nameEn: map['nameEn'] as String? ?? '',
      screens: (map['screens'] as List? ?? [])
          .map((e) => ScreenLeaf.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';

class ScreenLeaf extends Equatable {
  final String id;
  final String nameAr;
  final String nameEn;
  final ScreenType screenType;
  final double backendProgress; // 0.0 to 100.0
  final double frontendProgress; // 0.0 to 100.0

  const ScreenLeaf({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.screenType = ScreenType.inputs,
    this.backendProgress = 0.0,
    this.frontendProgress = 0.0,
  });

  /// Screen average done percentage = (Backend% + Frontend%) / 2
  double get overallProgress =>
      ((backendProgress.clamp(0.0, 100.0) + frontendProgress.clamp(0.0, 100.0)) / 2.0);

  @override
  List<Object?> get props => [
        id,
        nameAr,
        nameEn,
        screenType,
        backendProgress,
        frontendProgress,
      ];

  ScreenLeaf copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    ScreenType? screenType,
    double? backendProgress,
    double? frontendProgress,
  }) {
    return ScreenLeaf(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      screenType: screenType ?? this.screenType,
      backendProgress: backendProgress ?? this.backendProgress,
      frontendProgress: frontendProgress ?? this.frontendProgress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'screenType': screenType.value,
      'backendProgress': backendProgress,
      'frontendProgress': frontendProgress,
    };
  }

  factory ScreenLeaf.fromMap(Map<String, dynamic> map) {
    return ScreenLeaf(
      id: map['id'] as String? ?? '',
      nameAr: map['nameAr'] as String? ?? '',
      nameEn: map['nameEn'] as String? ?? '',
      screenType: ScreenType.fromString(map['screenType'] as String?),
      backendProgress: (map['backendProgress'] as num?)?.toDouble() ?? 0.0,
      frontendProgress: (map['frontendProgress'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

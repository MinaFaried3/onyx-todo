import 'package:onyx_todo/core/controller/cubit/base_state.dart';
import 'package:onyx_todo/core/controller/cubit/sub_state.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/feature/achievement/domain/entities/daily_achievement_entity.dart';
import 'package:fpdart/fpdart.dart';

final class AchievementState extends BaseState {
  final SubState<List<DailyAchievementEntity>> achievementsState;
  final SubState<Unit> logState;
  final String selectedFilter; // "today", "yesterday", "this_week", "last_week", "this_month", "custom"
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final String? developerFilter;

  const AchievementState({
    super.uiState,
    super.failure,
    this.achievementsState = const SubState(),
    this.logState = const SubState(),
    this.selectedFilter = 'today',
    this.customStartDate,
    this.customEndDate,
    this.developerFilter,
  });

  double get totalLoggedHours {
    final list = achievementsState.data ?? [];
    return list.fold<double>(0.0, (sum, a) => sum + a.totalHours);
  }

  @override
  List<Object?> get props => [
        uiState,
        failure,
        achievementsState,
        logState,
        selectedFilter,
        customStartDate,
        customEndDate,
        developerFilter,
      ];

  @override
  AchievementState copyWith({
    UiState? uiState,
    Failure? Function()? failure,
    SubState<List<DailyAchievementEntity>>? achievementsState,
    SubState<Unit>? logState,
    String? selectedFilter,
    DateTime? Function()? customStartDate,
    DateTime? Function()? customEndDate,
    String? Function()? developerFilter,
  }) {
    return AchievementState(
      uiState: uiState ?? this.uiState,
      failure: failure != null ? failure.copy : this.failure,
      achievementsState: achievementsState ?? this.achievementsState,
      logState: logState ?? this.logState,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      customStartDate: customStartDate != null ? customStartDate() : this.customStartDate,
      customEndDate: customEndDate != null ? customEndDate() : this.customEndDate,
      developerFilter: developerFilter != null ? developerFilter() : this.developerFilter,
    );
  }
}

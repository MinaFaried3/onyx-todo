import 'package:equatable/equatable.dart';
import 'package:onyx_todo/core/controller/cubit/base_state.dart';
import 'package:onyx_todo/core/controller/cubit/sub_state.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/feature/achievement/domain/entities/daily_achievement_entity.dart';
import 'package:fpdart/fpdart.dart';

final class AchievementState extends Equatable implements BaseState {
  final SubState<List<DailyAchievementEntity>> achievementsState;
  final SubState<Unit> logState;
  final String selectedFilter; // "today", "yesterday", "this_week", "last_week", "this_month", "custom"
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final String? developerFilter;
  final Failure? _failure;

  const AchievementState({
    this.achievementsState = const SubState(),
    this.logState = const SubState(),
    this.selectedFilter = 'today',
    this.customStartDate,
    this.customEndDate,
    this.developerFilter,
    Failure? failure,
  }) : _failure = failure;

  @override
  Failure? get failure => _failure;

  double get totalLoggedHours {
    final list = achievementsState.data ?? [];
    return list.fold<double>(0.0, (sum, a) => sum + a.totalHours);
  }

  @override
  List<Object?> get props => [
        achievementsState,
        logState,
        selectedFilter,
        customStartDate,
        customEndDate,
        developerFilter,
        _failure,
      ];

  AchievementState copyWith({
    SubState<List<DailyAchievementEntity>>? achievementsState,
    SubState<Unit>? logState,
    String? selectedFilter,
    DateTime? Function()? customStartDate,
    DateTime? Function()? customEndDate,
    String? Function()? developerFilter,
    Failure? Function()? failure,
  }) {
    return AchievementState(
      achievementsState: achievementsState ?? this.achievementsState,
      logState: logState ?? this.logState,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      customStartDate: customStartDate != null ? customStartDate() : this.customStartDate,
      customEndDate: customEndDate != null ? customEndDate() : this.customEndDate,
      developerFilter: developerFilter != null ? developerFilter() : this.developerFilter,
      failure: failure.copy,
    );
  }
}

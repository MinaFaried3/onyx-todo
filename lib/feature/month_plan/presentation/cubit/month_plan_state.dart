import 'package:equatable/equatable.dart';
import 'package:onyx_todo/core/controller/cubit/base_state.dart';
import 'package:onyx_todo/core/controller/cubit/sub_state.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_entity.dart';

final class MonthPlanState extends Equatable implements BaseState {
  final SubState<List<MonthlyPlanEntity>> plansState;
  final SubState<MonthlyPlanEntity> activePlanState;
  final int selectedMonth;
  final int selectedYear;
  final Failure? _failure;

  const MonthPlanState({
    this.plansState = const SubState(),
    this.activePlanState = const SubState(),
    required this.selectedMonth,
    required this.selectedYear,
    Failure? failure,
  }) : _failure = failure;

  @override
  Failure? get failure => _failure;

  @override
  List<Object?> get props => [
        plansState,
        activePlanState,
        selectedMonth,
        selectedYear,
        _failure,
      ];

  MonthPlanState copyWith({
    SubState<List<MonthlyPlanEntity>>? plansState,
    SubState<MonthlyPlanEntity>? activePlanState,
    int? selectedMonth,
    int? selectedYear,
    Failure? Function()? failure,
  }) {
    return MonthPlanState(
      plansState: plansState ?? this.plansState,
      activePlanState: activePlanState ?? this.activePlanState,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      failure: failure.copy,
    );
  }
}

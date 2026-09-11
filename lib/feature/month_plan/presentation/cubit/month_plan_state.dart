import 'package:onyx_todo/core/controller/cubit/base_state.dart';
import 'package:onyx_todo/core/controller/cubit/sub_state.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_entity.dart';

final class MonthPlanState extends BaseState {
  final SubState<List<MonthlyPlanEntity>> plansState;
  final SubState<MonthlyPlanEntity> activePlanState;
  final int selectedMonth;
  final int selectedYear;

  const MonthPlanState({
    super.uiState,
    super.failure,
    this.plansState = const SubState(),
    this.activePlanState = const SubState(),
    required this.selectedMonth,
    required this.selectedYear,
  });

  @override
  List<Object?> get props => [
        uiState,
        failure,
        plansState,
        activePlanState,
        selectedMonth,
        selectedYear,
      ];

  @override
  MonthPlanState copyWith({
    UiState? uiState,
    Failure? Function()? failure,
    SubState<List<MonthlyPlanEntity>>? plansState,
    SubState<MonthlyPlanEntity>? activePlanState,
    int? selectedMonth,
    int? selectedYear,
  }) {
    return MonthPlanState(
      uiState: uiState ?? this.uiState,
      failure: failure != null ? failure.copy : this.failure,
      plansState: plansState ?? this.plansState,
      activePlanState: activePlanState ?? this.activePlanState,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }
}

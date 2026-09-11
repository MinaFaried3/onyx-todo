import 'package:onyx_todo/core/controller/cubit/base_cubit.dart';
import 'package:onyx_todo/core/controller/cubit/sub_state.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_entity.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_task_item.dart';
import 'package:onyx_todo/feature/month_plan/domain/repositories/month_plan_repository.dart';
import 'package:onyx_todo/feature/month_plan/presentation/cubit/month_plan_state.dart';

class MonthPlanCubit extends BaseCubit<MonthPlanState> {
  final MonthPlanRepository _monthPlanRepository;

  MonthPlanCubit({required MonthPlanRepository monthPlanRepository})
      : _monthPlanRepository = monthPlanRepository,
        super(MonthPlanState(
          selectedMonth: DateTime.now().month,
          selectedYear: DateTime.now().year,
        ));

  Future<void> fetchPlans({String? developerName}) async {
    emit(state.copyWith(
      plansState: state.plansState.copyWith(state: UiState.loading),
    ));

    final res = await _monthPlanRepository.getPlans(
      month: state.selectedMonth,
      year: state.selectedYear,
      developerName: developerName,
    );

    res.fold(
      (failure) => emit(state.copyWith(
        plansState: state.plansState.copyWith(
          state: UiState.failed,
          failure: () => failure,
        ),
      )),
      (plans) {
        emit(state.copyWith(
          plansState: state.plansState.copyWith(
            state: UiState.succeed,
            data: plans,
          ),
          activePlanState: plans.isNotEmpty
              ? state.activePlanState.copyWith(
                  state: UiState.succeed,
                  data: plans.first,
                )
              : state.activePlanState,
        ));
      },
    );
  }

  void selectMonthYear({required int month, required int year, String? developerName}) {
    emit(state.copyWith(selectedMonth: month, selectedYear: year));
    fetchPlans(developerName: developerName);
  }

  Future<void> saveOrUpdatePlan(MonthlyPlanEntity plan) async {
    final res = await _monthPlanRepository.savePlan(plan);
    res.fold(
      (failure) => emit(state.copyWith(failure: () => failure)),
      (_) {
        final currentList = List<MonthlyPlanEntity>.from(state.plansState.data ?? []);
        final index = currentList.indexWhere((p) => p.id == plan.id);
        if (index != -1) {
          currentList[index] = plan;
        } else {
          currentList.add(plan);
        }
        emit(state.copyWith(
          plansState: state.plansState.copyWith(data: currentList),
          activePlanState: state.activePlanState.copyWith(
            state: UiState.succeed,
            data: plan,
          ),
        ));
      },
    );
  }

  Future<void> updatePlanStatus({
    required String planId,
    required PlanStatus status,
    String? managerNotes,
  }) async {
    final res = await _monthPlanRepository.updatePlanStatus(
      planId: planId,
      status: status.value,
      managerNotes: managerNotes,
    );

    res.fold(
      (failure) => emit(state.copyWith(failure: () => failure)),
      (_) {
        final currentList = List<MonthlyPlanEntity>.from(state.plansState.data ?? []);
        final index = currentList.indexWhere((p) => p.id == planId);
        if (index != -1) {
          final updated = currentList[index].copyWith(
            status: status,
            managerNotes: managerNotes,
          );
          currentList[index] = updated;
          emit(state.copyWith(
            plansState: state.plansState.copyWith(data: currentList),
            activePlanState: state.activePlanState.data?.id == planId
                ? state.activePlanState.copyWith(data: updated)
                : null,
          ));
        }
      },
    );
  }

  void addTaskToPlan(MonthlyPlanTaskItem item) {
    final currentPlan = state.activePlanState.data;
    if (currentPlan == null) return;

    final updatedTasks = [...currentPlan.plannedTasks, item];
    final totalEst = updatedTasks.fold<double>(0.0, (sum, t) => sum + t.estimatedHours);
    final updatedPlan = currentPlan.copyWith(
      plannedTasks: updatedTasks,
      totalEstimatedHours: totalEst,
      updatedAt: DateTime.now(),
    );

    saveOrUpdatePlan(updatedPlan);
  }
}

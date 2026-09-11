import 'package:onyx_todo/core/controller/cubit/base_cubit.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_entity.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_task_item.dart';
import 'package:onyx_todo/feature/month_plan/domain/repositories/month_plan_repository.dart';
import 'package:onyx_todo/feature/month_plan/presentation/cubit/month_plan_state.dart';

class MonthPlanCubit extends BaseCubit<MonthPlanState> {
  final MonthPlanRepository monthPlanRepository;

  MonthPlanCubit({required this.monthPlanRepository})
      : super(MonthPlanState(
          selectedMonth: DateTime.now().month,
          selectedYear: DateTime.now().year,
        ));

  Future<void> fetchPlans({String? developerName}) async {
    emit(state.copyWith(
      plansState: state.plansState.copyWith(state: UiState.loading),
    ));

    final res = await monthPlanRepository.getPlans(
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
    final res = await monthPlanRepository.savePlan(plan);
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
    final res = await monthPlanRepository.updatePlanStatus(
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

  void updateTaskInPlan(MonthlyPlanTaskItem item) {
    final currentPlan = state.activePlanState.data;
    if (currentPlan == null) return;

    final updatedTasks = currentPlan.plannedTasks.map((t) => t.taskId == item.taskId ? item : t).toList();
    final totalEst = updatedTasks.fold<double>(0.0, (sum, t) => sum + t.estimatedHours);
    final updatedPlan = currentPlan.copyWith(
      plannedTasks: updatedTasks,
      totalEstimatedHours: totalEst,
      updatedAt: DateTime.now(),
    );

    saveOrUpdatePlan(updatedPlan);
  }

  void removeTaskFromPlan(String taskId) {
    final currentPlan = state.activePlanState.data;
    if (currentPlan == null) return;

    final updatedTasks = currentPlan.plannedTasks.where((t) => t.taskId != taskId).toList();
    final totalEst = updatedTasks.fold<double>(0.0, (sum, t) => sum + t.estimatedHours);
    final updatedPlan = currentPlan.copyWith(
      plannedTasks: updatedTasks,
      totalEstimatedHours: totalEst,
      updatedAt: DateTime.now(),
    );

    saveOrUpdatePlan(updatedPlan);
  }

  Future<void> closePlanWithRollover({
    required MonthlyPlanEntity plan,
    required List<MonthlyPlanTaskItem> tasksWithActuals,
    required bool rolloverUnfinished,
  }) async {
    final totalActual = tasksWithActuals.fold<double>(0.0, (sum, t) => sum + t.actualHours);
    final closedPlan = plan.copyWith(
      status: PlanStatus.closed,
      plannedTasks: tasksWithActuals,
      totalActualHours: totalActual,
      updatedAt: DateTime.now(),
    );

    await saveOrUpdatePlan(closedPlan);

    if (rolloverUnfinished) {
      final unfinished = tasksWithActuals
          .where((t) => t.status != 'completed' || t.actualHours < t.estimatedHours)
          .toList();

      if (unfinished.isNotEmpty) {
        final nextMonth = plan.month == 12 ? 1 : plan.month + 1;
        final nextYear = plan.month == 12 ? plan.year + 1 : plan.year;

        final nextPlansRes = await monthPlanRepository.getPlans(
          month: nextMonth,
          year: nextYear,
          developerName: plan.developerName,
        );

        final existingNextPlan = nextPlansRes.fold(
          (_) => null,
          (plans) => plans.where((p) => p.developerName == plan.developerName).firstOrNull,
        );

        final rolledTasks = unfinished.map((t) {
          final remainingHours = (t.estimatedHours - t.actualHours).clamp(1.0, t.estimatedHours);
          return t.copyWith(
            actualHours: 0.0,
            estimatedHours: remainingHours,
            estimatedDays: (remainingHours / 8.0).clamp(0.5, 30.0),
            isRolledOver: true,
          );
        }).toList();

        if (existingNextPlan != null) {
          final mergedTasks = [...existingNextPlan.plannedTasks, ...rolledTasks];
          final totalEst = mergedTasks.fold<double>(0.0, (sum, t) => sum + t.estimatedHours);
          final updatedNextPlan = existingNextPlan.copyWith(
            plannedTasks: mergedTasks,
            totalEstimatedHours: totalEst,
            updatedAt: DateTime.now(),
          );
          await monthPlanRepository.savePlan(updatedNextPlan);
        } else {
          final workingDays = MonthlyPlanEntity.calculateWorkingDays(nextYear, nextMonth);
          final totalEst = rolledTasks.fold<double>(0.0, (sum, t) => sum + t.estimatedHours);
          final newNextPlan = MonthlyPlanEntity(
            id: 'plan_${plan.developerName}_${nextYear}_$nextMonth',
            developerName: plan.developerName,
            developerStack: plan.developerStack,
            month: nextMonth,
            year: nextYear,
            workingDays: workingDays,
            targetHours: workingDays * 8.0,
            totalEstimatedHours: totalEst,
            totalActualHours: 0.0,
            status: PlanStatus.draft,
            plannedTasks: rolledTasks,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await monthPlanRepository.savePlan(newNextPlan);
        }
      }
    }
  }
}

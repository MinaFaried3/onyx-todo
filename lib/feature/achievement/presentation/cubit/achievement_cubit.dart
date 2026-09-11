import 'package:onyx_todo/core/controller/cubit/base_cubit.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/feature/achievement/domain/entities/daily_achievement_entity.dart';
import 'package:onyx_todo/feature/achievement/domain/repositories/achievement_repository.dart';
import 'package:onyx_todo/feature/achievement/presentation/cubit/achievement_state.dart';
import 'package:fpdart/fpdart.dart';

class AchievementCubit extends BaseCubit<AchievementState> {
  final AchievementRepository achievementRepository;

  AchievementCubit({required this.achievementRepository})
      : super(const AchievementState());

  Future<void> fetchAchievements({String? developerName}) async {
    emit(state.copyWith(
      achievementsState: state.achievementsState.copyWith(state: UiState.loading),
    ));

    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    switch (state.selectedFilter) {
      case 'yesterday':
        final y = now.subtract(const Duration(days: 1));
        startDate = DateTime(y.year, y.month, y.day);
        endDate = DateTime(y.year, y.month, y.day, 23, 59, 59);
        break;
      case 'this_week':
        // Start from Saturday / Sunday (e.g. 7 days back)
        startDate = now.subtract(Duration(days: now.weekday % 7));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'last_week':
        final startThisWeek = now.subtract(Duration(days: now.weekday % 7));
        startDate = startThisWeek.subtract(const Duration(days: 7));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        endDate = startThisWeek.subtract(const Duration(seconds: 1));
        break;
      case 'this_month':
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      case 'custom':
        startDate = state.customStartDate ?? DateTime(now.year, now.month, now.day);
        endDate = state.customEndDate ?? DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'today':
      default:
        startDate = DateTime(now.year, now.month, now.day);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
    }

    final res = await achievementRepository.getAchievements(
      startDate: startDate,
      endDate: endDate,
      developerName: developerName ?? state.developerFilter,
    );

    res.fold(
      (failure) => emit(state.copyWith(
        achievementsState: state.achievementsState.copyWith(
          state: UiState.failed,
          failure: () => failure,
        ),
      )),
      (list) => emit(state.copyWith(
        achievementsState: state.achievementsState.copyWith(
          state: UiState.succeed,
          data: list,
        ),
      )),
    );
  }

  void setFilter(String filterKey, {DateTime? customStart, DateTime? customEnd}) {
    emit(state.copyWith(
      selectedFilter: filterKey,
      customStartDate: () => customStart,
      customEndDate: () => customEnd,
    ));
    fetchAchievements();
  }

  void setDeveloperFilter(String? developerName) {
    emit(state.copyWith(developerFilter: () => developerName));
    fetchAchievements(developerName: developerName);
  }

  Future<bool> submitDailyAchievement(DailyAchievementEntity achievement) async {
    emit(state.copyWith(
      logState: state.logState.copyWith(state: UiState.loading),
    ));

    final res = await achievementRepository.submitAchievement(achievement);

    return res.fold(
      (failure) {
        emit(state.copyWith(
          logState: state.logState.copyWith(
            state: UiState.failed,
            failure: () => failure,
          ),
        ));
        return false;
      },
      (_) {
        emit(state.copyWith(
          logState: state.logState.copyWith(
            state: UiState.succeed,
            data: unit,
          ),
        ));
        fetchAchievements();
        return true;
      },
    );
  }
}

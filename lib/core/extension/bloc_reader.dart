import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_todo/feature/achievement/presentation/cubit/achievement_cubit.dart';
import 'package:onyx_todo/feature/excel_import/presentation/cubit/excel_import_cubit.dart';
import 'package:onyx_todo/feature/month_plan/presentation/cubit/month_plan_cubit.dart';
import 'package:onyx_todo/feature/task/presentation/cubit/tasks_cubit.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_cubit.dart';

extension BlocReaderExtension on BuildContext {
  WorkspaceCubit get workspaceCubit => read<WorkspaceCubit>();
  TasksCubit get tasksCubit => read<TasksCubit>();
  MonthPlanCubit get monthPlanCubit => read<MonthPlanCubit>();
  AchievementCubit get achievementCubit => read<AchievementCubit>();
  ExcelImportCubit get excelImportCubit => read<ExcelImportCubit>();
}

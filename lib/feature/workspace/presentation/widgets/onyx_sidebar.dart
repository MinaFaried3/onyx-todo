import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_create_dialog.dart';
import 'package:onyx_todo/feature/workspace/domain/entities/onyx_module.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_state.dart';
import 'package:onyx_todo/feature/workspace/presentation/widgets/module_create_dialog.dart';
import 'package:onyx_todo/feature/workspace/presentation/widgets/onyx_collapsed_sidebar.dart';
import 'package:onyx_todo/feature/workspace/presentation/widgets/onyx_module_tile.dart';
import 'package:onyx_todo/feature/workspace/presentation/widgets/onyx_sidebar_item.dart';
import 'package:onyx_todo/feature/workspace/presentation/widgets/onyx_user_switcher.dart';

class OnyxSidebar extends StatelessWidget {
  const OnyxSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceCubit = context.workspaceCubit;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      builder: (context, state) {
        final isCollapsed = state.isSidebarCollapsed;
        final currentUser = state.currentUser;
        final availableUsers = state.availableUsers;
        final modules = state.modulesState.data ?? OnyxModule.standardModules;

        if (isCollapsed) {
          return OnyxCollapsedSidebar(
            cubit: workspaceCubit,
            isDark: isDark,
          );
        }

        return Container(
          width: 260,
          color: isDark ? OnyxColors.darkSidebar : OnyxColors.lightSidebar,
          child: Column(
            children: [
              // Top Brand Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [OnyxColors.primary, OnyxColors.primaryDark],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.circleCheck,
                          size: 16,
                          color: OnyxColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppStrings.onyxErp.tr(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: -0.2),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.anglesLeft, size: 14),
                      tooltip: AppStrings.collapseMenu.tr(),
                      onPressed: () => workspaceCubit.toggleSidebar(),
                    ),
                  ],
                ),
              ),

              // User Switcher Profile Card
              OnyxUserSwitcher(
                cubit: workspaceCubit,
                currentUser: currentUser,
                users: availableUsers,
                isDark: isDark,
              ),
              const SizedBox(height: 12),

              // Quick + Task Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OnyxColors.primary,
                    foregroundColor: OnyxColors.white,
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.plus, size: 14),
                  label: Text(
                    AppStrings.createTask.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  onPressed: () {
                    final tasksCubit = context.tasksCubit;
                    showDialog(
                      context: context,
                      builder: (ctx) => BlocProvider.value(
                        value: tasksCubit,
                        child: const TaskCreateDialog(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),

              // Main Navigation Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    // Main views
                    OnyxSidebarItem(
                      icon: FontAwesomeIcons.listCheck,
                      label: AppStrings.tasks.tr(),
                      isSelected: state.activeView == WorkspaceView.list ||
                          state.activeView == WorkspaceView.board ||
                          state.activeView == WorkspaceView.workload,
                      onTap: () => workspaceCubit.setView(WorkspaceView.list),
                    ),
                    OnyxSidebarItem(
                      icon: FontAwesomeIcons.chartPie,
                      label: AppStrings.analyticsView.tr(),
                      isSelected: state.activeView == WorkspaceView.analytics,
                      onTap: () => workspaceCubit.setView(WorkspaceView.analytics),
                    ),
                    OnyxSidebarItem(
                      icon: FontAwesomeIcons.trophy,
                      label: AppStrings.dailyAchievements.tr(),
                      isSelected: state.activeView == WorkspaceView.achievements,
                      onTap: () => workspaceCubit.setView(WorkspaceView.achievements),
                    ),
                    OnyxSidebarItem(
                      icon: FontAwesomeIcons.calendarCheck,
                      label: AppStrings.monthlyPlan.tr(),
                      isSelected: state.activeView == WorkspaceView.monthlyPlan,
                      onTap: () => workspaceCubit.setView(WorkspaceView.monthlyPlan),
                    ),
                    OnyxSidebarItem(
                      icon: FontAwesomeIcons.usersGear,
                      label: AppStrings.teamsAndUsers.tr(),
                      isSelected: state.activeView == WorkspaceView.teamManagement,
                      onTap: () => workspaceCubit.setView(WorkspaceView.teamManagement),
                    ),
                    OnyxSidebarItem(
                      icon: FontAwesomeIcons.fileExcel,
                      label: AppStrings.excelImport.tr(),
                      isSelected: state.activeView == WorkspaceView.excelImport,
                      onTap: () => workspaceCubit.setView(WorkspaceView.excelImport),
                    ),

                    const Divider(height: 24),

                    // Spaces & Modules Tree
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.folderTree, size: 12, color: OnyxColors.neutral400),
                          const SizedBox(width: 6),
                          Text(
                            AppStrings.modules.tr().toUpperCase(),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: OnyxColors.neutral400),
                          ),
                          const Spacer(),
                          Text(
                            '${modules.length}',
                            style: const TextStyle(fontSize: 10, color: OnyxColors.neutral400),
                          ),
                          if (currentUser.canManageTeam) ...[
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => BlocProvider.value(
                                    value: workspaceCubit,
                                    child: const ModuleCreateDialog(),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(4),
                              child: const Padding(
                                padding: EdgeInsets.all(2),
                                child: FaIcon(FontAwesomeIcons.plus, size: 10, color: OnyxColors.primary),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // All Modules Chip
                    OnyxModuleTile(
                      code: 'ALL',
                      name: AppStrings.all.tr(),
                      isSelected: state.selectedModuleCode == 'ALL',
                      onTap: () => workspaceCubit.selectModule('ALL'),
                    ),

                    // Individual 20 Modules
                    ...modules.map((m) {
                      return OnyxModuleTile(
                        code: m.code,
                        name: m.nameAr,
                        isSelected: state.selectedModuleCode == m.code,
                        onTap: () => workspaceCubit.selectModule(m.code),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/auth/domain/entities/user_profile.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_create_dialog.dart';
import 'package:onyx_todo/feature/workspace/domain/entities/onyx_module.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_state.dart';

class ClickUpSidebar extends StatelessWidget {
  const ClickUpSidebar({super.key});

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
          return _buildCollapsedSidebar(context, workspaceCubit, isDark);
        }

        return Container(
          width: 260,
          color: isDark ? ClickUpColors.darkSidebar : ClickUpColors.lightSidebar,
          child: Column(
            children: [
              // Top Brand Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [ClickUpColors.primary, ClickUpColors.primaryDark],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'O',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Onyx Tasks',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: -0.2),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.menu_open_rounded, size: 18),
                      tooltip: 'طي القائمة',
                      onPressed: () => workspaceCubit.toggleSidebar(),
                    ),
                  ],
                ),
              ),

              // User Switcher Profile Card
              _buildUserSwitcher(context, workspaceCubit, currentUser, availableUsers, isDark),
              const SizedBox(height: 12),

              // Quick + Task Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ClickUpColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 38),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(
                    AppStrings.createTask.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => const TaskCreateDialog(),
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
                    _buildNavItem(
                      icon: Icons.check_circle_outline_rounded,
                      label: AppStrings.tasks.tr(),
                      isSelected: state.activeView == WorkspaceView.list ||
                          state.activeView == WorkspaceView.board ||
                          state.activeView == WorkspaceView.workload,
                      onTap: () => workspaceCubit.setView(WorkspaceView.list),
                    ),
                    _buildNavItem(
                      icon: Icons.insights_rounded,
                      label: AppStrings.dailyAchievements.tr(),
                      isSelected: state.activeView == WorkspaceView.achievements,
                      onTap: () => workspaceCubit.setView(WorkspaceView.achievements),
                    ),
                    _buildNavItem(
                      icon: Icons.calendar_month_rounded,
                      label: AppStrings.monthlyPlan.tr(),
                      isSelected: state.activeView == WorkspaceView.monthlyPlan,
                      onTap: () => workspaceCubit.setView(WorkspaceView.monthlyPlan),
                    ),
                    _buildNavItem(
                      icon: Icons.table_view_rounded,
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
                          Text(
                            AppStrings.modules.tr().toUpperCase(),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          const Spacer(),
                          Text(
                            '${modules.length}',
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    // All Modules Chip
                    _buildModuleTile(
                      code: 'ALL',
                      name: 'كافة الأنظمة',
                      isSelected: state.selectedModuleCode == 'ALL',
                      onTap: () => workspaceCubit.selectModule('ALL'),
                    ),

                    // Individual 20 Modules
                    ...modules.map((m) {
                      return _buildModuleTile(
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

  Widget _buildCollapsedSidebar(
    BuildContext context,
    WorkspaceCubit cubit,
    bool isDark,
  ) {
    return Container(
      width: 56,
      color: isDark ? ClickUpColors.darkSidebar : ClickUpColors.lightSidebar,
      child: Column(
        children: [
          const SizedBox(height: 16),
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => cubit.toggleSidebar(),
          ),
          const SizedBox(height: 16),
          IconButton(
            icon: const Icon(Icons.check_circle_outline_rounded),
            tooltip: AppStrings.tasks.tr(),
            onPressed: () => cubit.setView(WorkspaceView.list),
          ),
          IconButton(
            icon: const Icon(Icons.insights_rounded),
            tooltip: AppStrings.dailyAchievements.tr(),
            onPressed: () => cubit.setView(WorkspaceView.achievements),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded),
            tooltip: AppStrings.monthlyPlan.tr(),
            onPressed: () => cubit.setView(WorkspaceView.monthlyPlan),
          ),
          IconButton(
            icon: const Icon(Icons.table_view_rounded),
            tooltip: AppStrings.excelImport.tr(),
            onPressed: () => cubit.setView(WorkspaceView.excelImport),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSwitcher(
    BuildContext context,
    WorkspaceCubit cubit,
    UserProfile currentUser,
    List<UserProfile> users,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? ClickUpColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
        ),
      ),
      child: PopupMenuButton<String>(
        tooltip: 'تبديل المستخدم',
        onSelected: (uid) => cubit.switchUser(uid),
        itemBuilder: (ctx) => users.map((u) {
          return PopupMenuItem(
            value: u.id,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: ClickUpColors.primary.withValues(alpha: 0.2),
                  child: Text(
                    u.name.substring(0, 1),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(u.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('${u.role.label} (${u.stack.label})', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: ClickUpColors.primary,
              child: Text(
                currentUser.name.substring(0, 1),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentUser.name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    currentUser.role.label,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.unfold_more_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        margin: const EdgeInsets.only(bottom: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ClickUpColors.primary.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? ClickUpColors.primary : Colors.grey),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? ClickUpColors.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleTile({
    required String code,
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? ClickUpColors.primary.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? ClickUpColors.primary : Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                code,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? ClickUpColors.primary : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

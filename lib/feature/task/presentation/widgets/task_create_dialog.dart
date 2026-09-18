import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/core/ui/responsive/responsive_extension.dart';
import 'package:onyx_todo/feature/workspace/domain/entities/onyx_module.dart';

class TaskCreateDialog extends HookWidget {
  final String defaultVersion;
  final String defaultModuleCode;

  const TaskCreateDialog({
    super.key,
    this.defaultVersion = 'V5.1.8',
    this.defaultModuleCode = 'GNR',
  });

  @override
  Widget build(BuildContext context) {
    final tasksCubit = context.tasksCubit;
    final workspaceCubit = context.workspaceCubit;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedVersion = useState(defaultVersion);
    final selectedModule = useState(
      defaultModuleCode == 'ALL' ? 'GNR' : defaultModuleCode,
    );
    final selectedType = useState(TaskType.task);
    final selectedPriority = useState(TaskPriority.medium);

    final titleController = useTextEditingController();
    final screenController = useTextEditingController();
    final descController = useTextEditingController();
    final estimatedHoursController = useTextEditingController(text: '4.0');
    final frontendDevController = useTextEditingController();
    final backendDevController = useTextEditingController();
    final middleDevController = useTextEditingController();
    final qaTesterController = useTextEditingController();
    final selectedRoleFlow = useState<List<String>>(['backend', 'middle', 'frontend', 'qa']);
    final isSubmitting = useState(false);

    final modules = workspaceCubit.state.modulesState.data ?? OnyxModule.standardModules;
    final teams = workspaceCubit.state.teamsState.data ?? const [];

    final isMobile = context.isMobile;

    Widget buildVersionField() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.versions.tr(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: selectedVersion.value,
              isDense: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: const [
                DropdownMenuItem(value: 'V5.1.8', child: Text('V5.1.8 (Active)')),
                DropdownMenuItem(value: 'V5.2.0', child: Text('V5.2.0 (Next)')),
                DropdownMenuItem(value: 'Backlog', child: Text('Backlog')),
              ],
              onChanged: (val) {
                if (val != null) selectedVersion.value = val;
              },
            ),
          ],
        );

    Widget buildModuleField() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.modules.tr(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: selectedModule.value,
              isDense: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: modules.map((m) {
                return DropdownMenuItem(
                  value: m.code,
                  child: Text('${m.code} - ${m.nameAr}', overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) selectedModule.value = val;
              },
            ),
          ],
        );

    Widget buildScreenField() => TextField(
          controller: screenController,
          decoration: InputDecoration(
            labelText: AppStrings.screenName.tr(),
            hintText: AppStrings.screenHint.tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            isDense: true,
          ),
        );

    Widget buildTitleField() => TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: AppStrings.taskTitle.tr(),
            hintText: AppStrings.titleHint.tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            isDense: true,
          ),
        );

    Widget buildTypeField() => DropdownButtonFormField<TaskType>(
          initialValue: selectedType.value,
          isDense: true,
          decoration: InputDecoration(
            labelText: AppStrings.taskType.tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: TaskType.values.map((t) {
            return DropdownMenuItem(
              value: t,
              child: Row(
                children: [
                  FaIcon(t.icon, size: 12, color: t.color),
                  const SizedBox(width: 8),
                  Text(t.label, style: const TextStyle(fontSize: 12)),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) selectedType.value = val;
          },
        );

    Widget buildPriorityField() => DropdownButtonFormField<TaskPriority>(
          initialValue: selectedPriority.value,
          isDense: true,
          decoration: InputDecoration(
            labelText: AppStrings.priority.tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: TaskPriority.values.map((p) {
            return DropdownMenuItem(
              value: p,
              child: Row(
                children: [
                  FaIcon(p.icon, size: 12, color: p.color),
                  const SizedBox(width: 8),
                  Text(p.label, style: const TextStyle(fontSize: 12)),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) selectedPriority.value = val;
          },
        );

    Widget buildHoursField() => TextField(
          controller: estimatedHoursController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: AppStrings.estimatedHours.tr(),
            suffixText: 'h',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            isDense: true,
          ),
        );

    Widget buildBackendDevField() => TextField(
          controller: backendDevController,
          decoration: InputDecoration(
            labelText: AppStrings.backendDev.tr(),
            hintText: AppStrings.assigneeHint.tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            isDense: true,
          ),
        );

    Widget buildMiddleDevField() => TextField(
          controller: middleDevController,
          decoration: InputDecoration(
            labelText: AppStrings.middleDev.tr(),
            hintText: AppStrings.assigneeHint.tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            isDense: true,
          ),
        );

    Widget buildFrontendDevField() => TextField(
          controller: frontendDevController,
          decoration: InputDecoration(
            labelText: AppStrings.frontendDev.tr(),
            hintText: AppStrings.assigneeHint.tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            isDense: true,
          ),
        );

    Widget buildQaTesterField() => TextField(
          controller: qaTesterController,
          decoration: InputDecoration(
            labelText: AppStrings.qaTester.tr(),
            hintText: AppStrings.assigneeHint.tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            isDense: true,
          ),
        );

    return Dialog(
      backgroundColor: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const FaIcon(FontAwesomeIcons.listCheck, color: OnyxColors.primary, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppStrings.createTask.tr(),
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!isMobile) ...[
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: OnyxColors.primary,
                        side: const BorderSide(color: OnyxColors.primary),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      icon: const FaIcon(FontAwesomeIcons.bolt, size: 12),
                      label: Text(
                        AppStrings.generalTask.tr(),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        selectedModule.value = 'GNR';
                        screenController.text = AppStrings.generalScreen.tr();
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.xmark,
                      size: 16,
                      color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral600,
                    ),
                    onPressed: () => context.safePop(),
                  ),
                ],
              ),
              if (isMobile) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: OnyxColors.primary,
                      side: const BorderSide(color: OnyxColors.primary),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ),
                    icon: const FaIcon(FontAwesomeIcons.bolt, size: 12),
                    label: Text(
                      AppStrings.generalTask.tr(),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      selectedModule.value = 'GNR';
                      screenController.text = AppStrings.generalScreen.tr();
                    },
                  ),
                ),
              ],
              Divider(
                height: 20,
                color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
              ),

              // Scrollable Form Fields
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Version & Module Selectors
                      if (isMobile) ...[
                        buildVersionField(),
                        const SizedBox(height: 12),
                        buildModuleField(),
                      ] else
                        Row(
                          children: [
                            Expanded(child: buildVersionField()),
                            const SizedBox(width: 12),
                            Expanded(child: buildModuleField()),
                          ],
                        ),
                      const SizedBox(height: 14),

                      // Screen Name & Task Title
                      if (isMobile) ...[
                        buildScreenField(),
                        const SizedBox(height: 12),
                        buildTitleField(),
                      ] else
                        Row(
                          children: [
                            Expanded(flex: 2, child: buildScreenField()),
                            const SizedBox(width: 12),
                            Expanded(flex: 3, child: buildTitleField()),
                          ],
                        ),
                      const SizedBox(height: 14),

                      // Type, Priority, Estimated Hours
                      if (isMobile) ...[
                        buildTypeField(),
                        const SizedBox(height: 12),
                        buildPriorityField(),
                        const SizedBox(height: 12),
                        buildHoursField(),
                      ] else
                        Row(
                          children: [
                            Expanded(child: buildTypeField()),
                            const SizedBox(width: 10),
                            Expanded(child: buildPriorityField()),
                            const SizedBox(width: 10),
                            Expanded(child: buildHoursField()),
                          ],
                        ),
                      const SizedBox(height: 14),

                      // Role Flow Selection
                      Text(
                        '${AppStrings.roleFlow.tr()}:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Backend ➔ Middle ➔ Front ➔ QA', style: TextStyle(fontSize: 11)),
                            selected: selectedRoleFlow.value.length == 4 && selectedRoleFlow.value.contains('middle'),
                            onSelected: (_) => selectedRoleFlow.value = ['backend', 'middle', 'frontend', 'qa'],
                          ),
                          ChoiceChip(
                            label: const Text('Backend ➔ Middle ➔ Front', style: TextStyle(fontSize: 11)),
                            selected: selectedRoleFlow.value.length == 3 && selectedRoleFlow.value.contains('middle'),
                            onSelected: (_) => selectedRoleFlow.value = ['backend', 'middle', 'frontend'],
                          ),
                          ChoiceChip(
                            label: const Text('Backend ➔ Frontend', style: TextStyle(fontSize: 11)),
                            selected: selectedRoleFlow.value.length == 2 && selectedRoleFlow.value.contains('backend'),
                            onSelected: (_) => selectedRoleFlow.value = ['backend', 'frontend'],
                          ),
                          ChoiceChip(
                            label: const Text('Frontend Only', style: TextStyle(fontSize: 11)),
                            selected: selectedRoleFlow.value.length == 1 && selectedRoleFlow.value.first == 'frontend',
                            onSelected: (_) => selectedRoleFlow.value = ['frontend'],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Assignees Section with Team Auto-Assign Button
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            AppStrings.assignees.tr(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                            ),
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                            icon: const FaIcon(FontAwesomeIcons.wandMagicSparkles, size: 11, color: OnyxColors.primary),
                            label: Text(
                              context.locale.languageCode == 'ar' ? 'تعيين تلقائي من الفريق' : 'Auto-Assign from Team',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: OnyxColors.primary),
                            ),
                            onPressed: () {
                              final assignedTeam = teams.where(
                                (t) => t.moduleCodes.contains(selectedModule.value),
                              ).firstOrNull ?? (teams.isNotEmpty ? teams.first : null);

                              if (assignedTeam != null) {
                                final defaults = assignedTeam.defaultRoleAssignees;
                                if (defaults['backend'] != null) backendDevController.text = defaults['backend']!;
                                if (defaults['middle'] != null) middleDevController.text = defaults['middle']!;
                                if (defaults['frontend'] != null) frontendDevController.text = defaults['frontend']!;
                                if (defaults['qa'] != null) qaTesterController.text = defaults['qa']!;
                                context.safeShowSnackBar(
                                  SnackBar(
                                    content: Text(
                                      context.locale.languageCode == 'ar'
                                          ? 'تم التعيين التلقائي وفق إعدادات فريق ${assignedTeam.name}'
                                          : 'Auto-assigned roles from team ${assignedTeam.name}',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (isMobile) ...[
                        buildBackendDevField(),
                        const SizedBox(height: 10),
                        buildMiddleDevField(),
                        const SizedBox(height: 10),
                        buildFrontendDevField(),
                        const SizedBox(height: 10),
                        buildQaTesterField(),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(child: buildBackendDevField()),
                            const SizedBox(width: 10),
                            Expanded(child: buildMiddleDevField()),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: buildFrontendDevField()),
                            const SizedBox(width: 10),
                            Expanded(child: buildQaTesterField()),
                          ],
                        ),
                      ],
                      const SizedBox(height: 14),

                      // Description
                      TextField(
                        controller: descController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: AppStrings.description.tr(),
                          hintText: AppStrings.descriptionHint.tr(),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Divider(
                height: 20,
                color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
              ),

              // Footer Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => context.safePop(),
                    child: Text(AppStrings.cancel.tr()),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OnyxColors.primary,
                      foregroundColor: OnyxColors.lightCard,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    icon: isSubmitting.value
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: OnyxColors.lightCard,
                            ),
                          )
                        : const FaIcon(FontAwesomeIcons.check, size: 14),
                    label: Text(
                      AppStrings.createTask.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: isSubmitting.value
                        ? null
                        : () async {
                            final title = titleController.text.trim();
                            if (title.isEmpty) {
                              context.safeShowSnackBar(
                                SnackBar(content: Text(AppStrings.enterTaskTitle.tr())),
                              );
                              return;
                            }

                            // Auto-fallback from team default assignees if fields left blank
                            final assignedTeam = teams.where(
                              (t) => t.moduleCodes.contains(selectedModule.value),
                            ).firstOrNull ?? (teams.isNotEmpty ? teams.first : null);
                            final defaults = assignedTeam?.defaultRoleAssignees ?? const {};

                            final finalBe = backendDevController.text.trim().isNotEmpty
                                ? backendDevController.text.trim()
                                : defaults['backend'];
                            final finalMid = middleDevController.text.trim().isNotEmpty
                                ? middleDevController.text.trim()
                                : defaults['middle'];
                            final finalFe = frontendDevController.text.trim().isNotEmpty
                                ? frontendDevController.text.trim()
                                : defaults['frontend'];
                            final finalQa = qaTesterController.text.trim().isNotEmpty
                                ? qaTesterController.text.trim()
                                : defaults['qa'];

                            isSubmitting.value = true;
                            final ok = await tasksCubit.createTask(
                              version: selectedVersion.value,
                              moduleCode: selectedModule.value,
                              screenName: screenController.text.trim().isEmpty
                                  ? AppStrings.generalScreen.tr()
                                  : screenController.text.trim(),
                              title: title,
                              description: descController.text.trim(),
                              taskType: selectedType.value.value,
                              priority: selectedPriority.value.value,
                              backendDevName: finalBe,
                              middleDevName: finalMid,
                              frontendDevName: finalFe,
                              qaTesterName: finalQa,
                              roleFlow: selectedRoleFlow.value,
                              estimatedHours:
                                  double.tryParse(estimatedHoursController.text.trim()) ?? 0.0,
                            );

                            isSubmitting.value = false;
                            if (ok && context.mounted) {
                              context.safePop();
                            }
                          },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

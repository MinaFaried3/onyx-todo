import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
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
    final isSubmitting = useState(false);

    final modules = workspaceCubit.state.modulesState.data ?? OnyxModule.standardModules;

    return Dialog(
      backgroundColor: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.listCheck, color: OnyxColors.primary, size: 18),
                const SizedBox(width: 10),
                Text(
                  AppStrings.createTask.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                  ),
                ),
                const Spacer(),
                // Quick "General Task" Shortcut
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
            Divider(
              height: 24,
              color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
            ),

            // Version & Module Selectors
            Row(
              children: [
                Expanded(
                  child: Column(
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
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
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
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Screen Name & Task Title
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: screenController,
                    decoration: InputDecoration(
                      labelText: AppStrings.screenName.tr(),
                      hintText: AppStrings.screenHint.tr(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: AppStrings.taskTitle.tr(),
                      hintText: AppStrings.titleHint.tr(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Type, Priority, Estimated Hours
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<TaskType>(
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
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<TaskPriority>(
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
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: estimatedHoursController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: AppStrings.estimatedHours.tr(),
                      suffixText: 'h',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Assignees (FE & BE)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: frontendDevController,
                    decoration: InputDecoration(
                      labelText: AppStrings.frontendDev.tr(),
                      hintText: AppStrings.assigneeHint.tr(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: backendDevController,
                    decoration: InputDecoration(
                      labelText: AppStrings.backendDev.tr(),
                      hintText: AppStrings.assigneeHint.tr(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
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
            const SizedBox(height: 20),

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
                            frontendDevName: frontendDevController.text.trim().isNotEmpty
                                ? frontendDevController.text.trim()
                                : null,
                            backendDevName: backendDevController.text.trim().isNotEmpty
                                ? backendDevController.text.trim()
                                : null,
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
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/excel_import/presentation/cubit/excel_import_cubit.dart';
import 'package:onyx_todo/feature/excel_import/presentation/cubit/excel_import_state.dart';
import 'package:onyx_todo/feature/excel_import/presentation/widgets/excel_preview_table.dart';
import 'package:onyx_todo/feature/excel_import/presentation/widgets/excel_staged_action_bar.dart';
import 'package:onyx_todo/feature/excel_import/presentation/widgets/excel_upload_dropzone.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_state.dart';

class ExcelImportScreen extends HookWidget {
  const ExcelImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final excelImportCubit = context.excelImportCubit;
    final workspaceCubit = context.workspaceCubit;
    final tasksCubit = context.tasksCubit;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<ExcelImportCubit, ExcelImportState>(
      listenWhen: (prev, curr) =>
          (!prev.importState.isSucceed && curr.importState.isSucceed) ||
          (!prev.importState.isFailed && curr.importState.isFailed) ||
          (!prev.parseState.isFailed && curr.parseState.isFailed),
      listener: (context, state) {
        if (state.importState.isSucceed) {
          tasksCubit.fetchTasks();
          context.safeShowSnackBar(
            SnackBar(
              backgroundColor: OnyxColors.success,
              content: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.circleCheck, color: OnyxColors.white, size: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${AppStrings.tasksImportedSuccess.tr()} (${state.previewTasks.length})',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: OnyxColors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state.importState.isFailed) {
          context.safeShowSnackBar(
            SnackBar(
              backgroundColor: OnyxColors.statusClosed,
              content: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.triangleExclamation, color: OnyxColors.white, size: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      state.importState.message ?? AppStrings.error.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: OnyxColors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state.parseState.isFailed) {
          context.safeShowSnackBar(
            SnackBar(
              backgroundColor: OnyxColors.statusClosed,
              content: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.triangleExclamation, color: OnyxColors.white, size: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      state.parseState.message ?? AppStrings.error.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: OnyxColors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isParsing = state.parseState.isLoading;
        final isUploading = state.importState.isLoading;
        final isSuccess = state.importState.isSucceed;
        final isStaged = state.isStaged;
        final previewTasks = state.previewTasks;
        final filteredTasks = state.filteredPreviewTasks;
        final sheetsFound = state.sheetsFound;

        // Group preview tasks by version
        final versionCounts = <String, int>{};
        for (final t in previewTasks) {
          versionCounts[t.version] = (versionCounts[t.version] ?? 0) + 1;
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.fileExcel, color: OnyxColors.success, size: 24),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.excelImport.tr(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          AppStrings.uploadExcelPrompt.tr(),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Error Notification Banner
                if (state.importState.isFailed || state.parseState.isFailed) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: OnyxColors.statusClosed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: OnyxColors.statusClosed),
                    ),
                    child: Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.circleExclamation, color: OnyxColors.statusClosed, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            state.importState.message ?? state.parseState.message ?? AppStrings.error.tr(),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: OnyxColors.statusClosed),
                          ),
                        ),
                        TextButton(
                          onPressed: () => excelImportCubit.reset(),
                          child: Text(AppStrings.retry.tr()),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // STAGE 1: Upload Dropzone (When not staged and not yet confirmed)
                if (!isStaged && !isSuccess) ...[
                  ExcelUploadDropzone(
                    isLoading: isParsing,
                    onFileSelected: (bytes, fileName) {
                      excelImportCubit.processExcelBytes(bytes, fileName);
                    },
                  ),
                ],

                // STAGE 2: Staged Review & Module Inspection (In-Memory Preview Only)
                if (isStaged) ...[
                  // Summary Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const FaIcon(FontAwesomeIcons.tableList, size: 16, color: OnyxColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              '${AppStrings.tasksImported.tr()}: ${previewTasks.length} ${AppStrings.tasks.tr()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${AppStrings.modules.tr()}: ${sheetsFound.length}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                              ),
                            ),
                          ],
                        ),
                        if (versionCounts.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            children: versionCounts.entries.map((e) {
                              return Chip(
                                label: Text(
                                  '${e.key} (${e.value} ${AppStrings.tasks.tr()})',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: isDark ? OnyxColors.neutral700 : OnyxColors.neutral200,
                                side: BorderSide.none,
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Module Filter Chips (Allows user to inspect each sheet)
                  if (sheetsFound.isNotEmpty) ...[
                    Text(
                      '${AppStrings.filter.tr()}:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: Text('${AppStrings.all.tr()} (${previewTasks.length})', style: const TextStyle(fontSize: 11)),
                            selected: state.selectedPreviewModule == 'ALL',
                            onSelected: (_) => excelImportCubit.filterPreviewByModule('ALL'),
                          ),
                          const SizedBox(width: 6),
                          ...sheetsFound.map((mod) {
                            final count = previewTasks.where((t) => t.moduleCode == mod).length;
                            final isSelected = state.selectedPreviewModule == mod;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: ChoiceChip(
                                label: Text('$mod ($count)', style: const TextStyle(fontSize: 11)),
                                selected: isSelected,
                                onSelected: (_) => excelImportCubit.filterPreviewByModule(mod),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Interactive Staged Preview Table
                  Expanded(
                    child: ExcelPreviewTable(
                      tasks: filteredTasks,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Staged Action Bar (Confirm Upload / Discard)
                  ExcelStagedActionBar(
                    isUploading: isUploading,
                    uploadProgress: state.uploadProgress,
                    uploadedCount: state.uploadedCount,
                    totalCount: state.totalToUpload,
                    onConfirm: () => excelImportCubit.confirmImport(),
                    onDiscard: () => excelImportCubit.discardStagedImport(),
                  ),
                ],

                // STAGE 3: Confirmed Success View
                if (isSuccess) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: OnyxColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: OnyxColors.success),
                    ),
                    child: Column(
                      children: [
                        const FaIcon(FontAwesomeIcons.circleCheck, color: OnyxColors.success, size: 48),
                        const SizedBox(height: 14),
                        Text(
                          '${AppStrings.tasksImportedSuccess.tr()} (${previewTasks.length} ${AppStrings.tasks.tr()})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: OnyxColors.success,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'تم رفع وتحديث كافة المهام في قاعدة بيانات Cloud Firestore بنجاح.',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: OnyxColors.primary,
                                foregroundColor: OnyxColors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const FaIcon(FontAwesomeIcons.listCheck, size: 14),
                              label: Text(
                                AppStrings.listView.tr(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                workspaceCubit.setView(WorkspaceView.list);
                                tasksCubit.fetchTasks();
                              },
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: OnyxColors.success,
                                foregroundColor: OnyxColors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const FaIcon(FontAwesomeIcons.tableColumns, size: 14),
                              label: Text(
                                AppStrings.boardView.tr(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                workspaceCubit.setView(WorkspaceView.board);
                                tasksCubit.fetchTasks();
                              },
                            ),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const FaIcon(FontAwesomeIcons.arrowRotateLeft, size: 13),
                              label: Text(AppStrings.selectExcelFile.tr()),
                              onPressed: () => excelImportCubit.reset(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

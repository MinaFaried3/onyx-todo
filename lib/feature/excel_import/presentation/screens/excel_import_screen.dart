import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/excel_import/presentation/cubit/excel_import_cubit.dart';
import 'package:onyx_todo/feature/excel_import/presentation/cubit/excel_import_state.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';

class ExcelImportScreen extends HookWidget {
  const ExcelImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final excelImportCubit = context.excelImportCubit;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<ExcelImportCubit, ExcelImportState>(
      builder: (context, state) {
        final isLoading = state.importState.isLoading;
        final isSuccess = state.importState.isSucceed;
        final previewTasks = state.previewTasks;
        final sheetsFound = state.sheetsFound;

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
                    const Icon(Icons.table_view_rounded, color: Colors.green, size: 28),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.excelImport.tr(),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          AppStrings.uploadExcelPrompt.tr(),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Upload Card / Dropzone
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ClickUpColors.primary.withValues(alpha: 0.3),
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 48,
                        color: ClickUpColors.primary.withValues(alpha: 0.8),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'رفع ملف مهام أونكس ERP (To-do list.xlsx)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'يقوم النظام تلقائياً بقراءة كافة الأنظمة الـ 20 وترحيل المهام وأكواد المشاكل والمطورين إلى قاعدة البيانات',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ClickUpColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        icon: isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.folder_open_rounded),
                        label: Text(
                          isLoading ? AppStrings.importingTasks.tr() : AppStrings.selectExcelFile.tr(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: isLoading
                            ? null
                            : () async {
                                final result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['xlsx', 'xls'],
                                  withData: true,
                                );

                                if (result != null && result.files.isNotEmpty) {
                                  final file = result.files.first;
                                  final bytes = file.bytes;
                                  if (bytes != null) {
                                    excelImportCubit.processExcelBytes(bytes, file.name);
                                  }
                                }
                              },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Success notification banner
                if (isSuccess) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'تم استيراد ${state.importState.data ?? previewTasks.length} مهمة بنجاح عبر ${sheetsFound.length} أنظمة فرعية!',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.tasksCubit.fetchTasks();
                            context.safeShowSnackBar('تم تحديث قائمة المهام!');
                          },
                          child: const Text('عرض المهام في لوحة كانبان'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Discovered Sheets Chips
                if (sheetsFound.isNotEmpty) ...[
                  Text(
                    '${AppStrings.sheetsFound.tr()} (${sheetsFound.length}):',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: sheetsFound.map((code) {
                      return Chip(
                        label: Text(code, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        backgroundColor: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
                        side: BorderSide(color: ClickUpColors.primary.withValues(alpha: 0.3)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Preview Table
                if (previewTasks.isNotEmpty) ...[
                  Text(
                    'معاينة المهام المستوردة (${previewTasks.length}):',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: previewTasks.length > 50 ? 50 : previewTasks.length,
                        itemBuilder: (context, index) {
                          final t = previewTasks[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                TaskIdBadge(formattedId: t.formattedId),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white10 : Colors.black12,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(t.moduleCode, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(t.screenName, style: const TextStyle(fontSize: 10, color: Colors.blue)),
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(t.title, style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                if (t.frontendDevName != null) ...[
                                  Text(t.frontendDevName!, style: const TextStyle(fontSize: 10, color: Colors.teal)),
                                  const SizedBox(width: 6),
                                ],
                                if (t.backendDevName != null) ...[
                                  Text(t.backendDevName!, style: const TextStyle(fontSize: 10, color: Colors.deepPurple)),
                                  const SizedBox(width: 6),
                                ],
                                Text(t.status.label, style: TextStyle(fontSize: 10, color: t.status.color, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        },
                      ),
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

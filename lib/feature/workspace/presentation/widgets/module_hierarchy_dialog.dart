import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/workspace/domain/entities/onyx_module.dart';
import 'package:onyx_todo/feature/workspace/domain/entities/screen_leaf.dart';
import 'package:onyx_todo/feature/workspace/domain/entities/sub_module_entity.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_state.dart';

class ModuleHierarchyDialog extends HookWidget {
  final String moduleCode;

  const ModuleHierarchyDialog({
    super.key,
    required this.moduleCode,
  });

  @override
  Widget build(BuildContext context) {
    final workspaceCubit = context.workspaceCubit;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      builder: (context, state) {
        final allModules = state.modulesState.data ?? OnyxModule.standardModules;
        final module = allModules.where((m) => m.code == moduleCode).firstOrNull ?? allModules.first;
        final systemProgress = OnyxModule.calculateSystemProgress(allModules);

        return Dialog(
          backgroundColor: isDark ? OnyxColors.darkCard : OnyxColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820, maxHeight: 760),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: OnyxColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const FaIcon(FontAwesomeIcons.folderTree, color: OnyxColors.primary, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${module.nameAr} (${module.code})',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                module.nameEn,
                                style: const TextStyle(fontSize: 12, color: OnyxColors.neutral400),
                              ),
                            ],
                          ),
                          Text(
                            AppStrings.moduleStructureTitle.tr(),
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.xmark, size: 14),
                        onPressed: () => context.safePop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ─── Progress Overview Cards (System & Module Scopes) ────────
                  Row(
                    children: [
                      // Outer Scope 5: All System Progress
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: OnyxColors.info.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: OnyxColors.info.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const FaIcon(FontAwesomeIcons.globe, size: 11, color: OnyxColors.info),
                                  const SizedBox(width: 6),
                                  Text(
                                    AppStrings.systemProgress.tr(),
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: OnyxColors.info),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${systemProgress.toStringAsFixed(1)}%',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: OnyxColors.info),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: systemProgress / 100.0,
                                  minHeight: 5,
                                  backgroundColor: OnyxColors.info.withValues(alpha: 0.2),
                                  valueColor: const AlwaysStoppedAnimation(OnyxColors.info),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Outer Scope 4: Module Average Progress
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: OnyxColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: OnyxColors.primary.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const FaIcon(FontAwesomeIcons.layerGroup, size: 11, color: OnyxColors.primary),
                                  const SizedBox(width: 6),
                                  Text(
                                    AppStrings.moduleProgress.tr(),
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: OnyxColors.primary),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${module.moduleProgress.toStringAsFixed(1)}%',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: OnyxColors.primary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: module.moduleProgress / 100.0,
                                  minHeight: 5,
                                  backgroundColor: OnyxColors.primary.withValues(alpha: 0.2),
                                  valueColor: const AlwaysStoppedAnimation(OnyxColors.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Actions: Add Sub-Module
                  Row(
                    children: [
                      Text(
                        '${AppStrings.subModules.tr()} (${module.subModules.length})',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: OnyxColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        icon: const FaIcon(FontAwesomeIcons.plus, size: 11),
                        label: Text(
                          AppStrings.addSubModule.tr(),
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => _showAddSubModuleDialog(context, workspaceCubit, module.code),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Sub-Modules & Screens Tree List
                  Expanded(
                    child: module.subModules.isEmpty
                        ? Center(
                            child: Text(
                              context.locale.languageCode == 'ar'
                                  ? 'لا توجد أنظمة فرعية مضافة بعد. اضغط "إضافة نظام فرعي" للبدء.'
                                  : 'No sub-modules added yet. Click "Add Sub-Module" to begin.',
                              style: const TextStyle(fontSize: 12, color: OnyxColors.neutral400),
                            ),
                          )
                        : ListView.separated(
                            itemCount: module.subModules.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              final sm = module.subModules[index];
                              return _buildSubModuleCard(
                                context: context,
                                cubit: workspaceCubit,
                                moduleCode: module.code,
                                subModule: sm,
                                isDark: isDark,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubModuleCard({
    required BuildContext context,
    required WorkspaceCubit cubit,
    required String moduleCode,
    required SubModuleEntity subModule,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? OnyxColors.darkBackground : OnyxColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        childrenPadding: const EdgeInsets.only(left: 14, right: 14, bottom: 12),
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: OnyxColors.purple.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const FaIcon(FontAwesomeIcons.folder, size: 13, color: OnyxColors.purple),
        ),
        title: Row(
          children: [
            Text(
              subModule.nameAr,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              subModule.nameEn,
              style: const TextStyle(fontSize: 11, color: OnyxColors.neutral400),
            ),
            const Spacer(),
            // Outer Scope 3: Sub-Module Average Progress
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: OnyxColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${subModule.subModuleProgress.toStringAsFixed(0)}% Done',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: OnyxColors.success),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: ScreenType.values.map((t) {
              final prog = subModule.progressForType(t);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${t.label.split(' ').first}: ${prog.toStringAsFixed(0)}%',
                        style: TextStyle(fontSize: 9, color: t.color, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: prog / 100.0,
                          minHeight: 3,
                          backgroundColor: t.color.withValues(alpha: 0.15),
                          valueColor: AlwaysStoppedAnimation(t.color),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        children: [
          const Divider(height: 16),
          // Screens Header + Add Screen Button
          Row(
            children: [
              Text(
                '${AppStrings.screenTypes.tr()} & ${AppStrings.screenName.tr()} (${subModule.screens.length})',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton.icon(
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2)),
                icon: const FaIcon(FontAwesomeIcons.plus, size: 10),
                label: Text(AppStrings.addScreen.tr(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                onPressed: () => _showAddScreenDialog(context, cubit, moduleCode, subModule.id),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Screens List (Leaf Nodes with Backend% and Frontend% controls)
          if (subModule.screens.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                context.locale.languageCode == 'ar' ? 'لا توجد شاشات في هذا النظام الفرعي' : 'No screens in this sub-module',
                style: const TextStyle(fontSize: 11, color: OnyxColors.neutral400),
              ),
            )
          else
            ...subModule.screens.map((scr) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? OnyxColors.darkCard : OnyxColors.neutral100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: scr.screenType.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        scr.screenType.label,
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: scr.screenType.color),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '${scr.nameAr} (${scr.nameEn})',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),

                    // Backend Progress Slider/Control
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Text('BE: ${scr.backendProgress.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 9, color: OnyxColors.info)),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 3,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              ),
                              child: Slider(
                                value: scr.backendProgress,
                                min: 0.0,
                                max: 100.0,
                                activeColor: OnyxColors.info,
                                onChanged: (val) {
                                  cubit.updateScreenProgress(
                                    moduleCode: moduleCode,
                                    subModuleId: subModule.id,
                                    screenId: scr.id,
                                    backendProgress: val,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Frontend Progress Slider/Control
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Text('FE: ${scr.frontendProgress.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 9, color: OnyxColors.success)),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 3,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              ),
                              child: Slider(
                                value: scr.frontendProgress,
                                min: 0.0,
                                max: 100.0,
                                activeColor: OnyxColors.success,
                                onChanged: (val) {
                                  cubit.updateScreenProgress(
                                    moduleCode: moduleCode,
                                    subModuleId: subModule.id,
                                    screenId: scr.id,
                                    frontendProgress: val,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Outer Scope 1: Screen Average Progress
                    Container(
                      width: 50,
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${scr.overallProgress.toStringAsFixed(0)}%',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  void _showAddSubModuleDialog(BuildContext context, WorkspaceCubit cubit, String moduleCode) {
    final arController = TextEditingController();
    final enController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.addSubModule.tr(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: arController,
              decoration: InputDecoration(
                labelText: AppStrings.subModuleNameAr.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: enController,
              decoration: InputDecoration(
                labelText: AppStrings.subModuleNameEn.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                isDense: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => ctx.safePop(), child: Text(AppStrings.cancel.tr())),
          ElevatedButton(
            onPressed: () {
              final nameAr = arController.text.trim();
              if (nameAr.isNotEmpty) {
                final newSm = SubModuleEntity(
                  id: 'sm_${DateTime.now().millisecondsSinceEpoch}',
                  nameAr: nameAr,
                  nameEn: enController.text.trim().isNotEmpty ? enController.text.trim() : nameAr,
                );
                cubit.addSubModule(moduleCode, newSm);
                ctx.safePop();
              }
            },
            child: Text(AppStrings.add.tr()),
          ),
        ],
      ),
    );
  }

  void _showAddScreenDialog(BuildContext context, WorkspaceCubit cubit, String moduleCode, String subModuleId) {
    final arController = TextEditingController();
    final enController = TextEditingController();
    ScreenType selectedType = ScreenType.inputs;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppStrings.addScreen.tr(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: arController,
                decoration: InputDecoration(
                  labelText: AppStrings.screenNameAr.tr(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: enController,
                decoration: InputDecoration(
                  labelText: AppStrings.screenNameEn.tr(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ScreenType>(
                initialValue: selectedType,
                decoration: InputDecoration(
                  labelText: AppStrings.screenTypes.tr(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                  isDense: true,
                ),
                items: ScreenType.values.map((t) {
                  return DropdownMenuItem(value: t, child: Text(t.label, style: const TextStyle(fontSize: 12)));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => selectedType = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => ctx.safePop(), child: Text(AppStrings.cancel.tr())),
            ElevatedButton(
              onPressed: () {
                final nameAr = arController.text.trim();
                if (nameAr.isNotEmpty) {
                  final newScr = ScreenLeaf(
                    id: 'scr_${DateTime.now().millisecondsSinceEpoch}',
                    nameAr: nameAr,
                    nameEn: enController.text.trim().isNotEmpty ? enController.text.trim() : nameAr,
                    screenType: selectedType,
                    backendProgress: 0.0,
                    frontendProgress: 0.0,
                  );
                  cubit.addScreen(moduleCode, subModuleId, newScr);
                  ctx.safePop();
                }
              },
              child: Text(AppStrings.add.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

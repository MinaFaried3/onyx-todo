import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/team/domain/entities/team_entity.dart';
import 'package:onyx_todo/feature/workspace/domain/entities/onyx_module.dart';

class TeamCreateDialog extends HookWidget {
  final TeamEntity? initialTeam;

  const TeamCreateDialog({
    super.key,
    this.initialTeam,
  });

  @override
  Widget build(BuildContext context) {
    final workspaceCubit = context.workspaceCubit;
    final state = workspaceCubit.state;
    final users = state.usersState.data ?? state.availableUsers;
    final modules = state.modulesState.data ?? OnyxModule.standardModules;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final nameController = useTextEditingController(text: initialTeam?.name ?? '');
    final descController = useTextEditingController(text: initialTeam?.description ?? '');
    final selectedLeaderId = useState<String?>(initialTeam?.leaderId ?? users.firstOrNull?.id);
    final selectedMemberIds = useState<List<String>>(List.from(initialTeam?.memberIds ?? const []));
    final selectedModules = useState<List<String>>(List.from(initialTeam?.moduleCodes ?? const []));
    final selectedRoleFlow = useState<List<String>>(List.from(initialTeam?.roleFlow ?? const ['backend', 'middle', 'frontend', 'qa']));
    final defaultAssignees = useState<Map<String, String>>(Map.from(initialTeam?.defaultRoleAssignees ?? const {}));
    final isSaving = useState(false);

    return Dialog(
      backgroundColor: isDark ? OnyxColors.darkCard : OnyxColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const FaIcon(FontAwesomeIcons.usersGear, color: OnyxColors.primary, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    initialTeam != null ? AppStrings.editTeam.tr() : AppStrings.addTeam.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                    ),
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
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Scrollable form fields
              Expanded(
                child: ListView(
                  children: [
                    // Team Name
                    Text(
                      '${AppStrings.teamName.tr()} *',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'e.g. فريق المبيعات ونقاط البيع',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Team Description
                    Text(
                      AppStrings.devNotes.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: descController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'وصف مهام ومسؤوليات هذا الفريق...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Team Lead Selector
                    Text(
                      AppStrings.teamLead.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: selectedLeaderId.value,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                      items: users.map((u) {
                        return DropdownMenuItem(
                          value: u.id,
                          child: Text('${u.name} (${u.role.label})', style: const TextStyle(fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (val) => selectedLeaderId.value = val,
                    ),
                    const SizedBox(height: 16),

                    // Select Team Members
                    Text(
                      AppStrings.selectMembers.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: users.map((u) {
                        final isSelected = selectedMemberIds.value.contains(u.id);
                        return FilterChip(
                          label: Text('${u.name} • ${u.role.label}', style: const TextStyle(fontSize: 11)),
                          selected: isSelected,
                          selectedColor: OnyxColors.primary.withValues(alpha: 0.2),
                          checkmarkColor: OnyxColors.primary,
                          onSelected: (checked) {
                            final current = List<String>.from(selectedMemberIds.value);
                            if (checked) {
                              current.add(u.id);
                            } else {
                              current.remove(u.id);
                            }
                            selectedMemberIds.value = current;
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Assign Modules
                    Text(
                      AppStrings.assignModules.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: modules.map((m) {
                        final isSelected = selectedModules.value.contains(m.code);
                        final moduleName = context.locale.languageCode == 'ar' ? m.nameAr : m.nameEn;
                        return FilterChip(
                          label: Text('${m.code} - $moduleName', style: const TextStyle(fontSize: 11)),
                          selected: isSelected,
                          selectedColor: OnyxColors.primary.withValues(alpha: 0.2),
                          checkmarkColor: OnyxColors.primary,
                          onSelected: (checked) {
                            final current = List<String>.from(selectedModules.value);
                            if (checked) {
                              current.add(m.code);
                            } else {
                              current.remove(m.code);
                            }
                            selectedModules.value = current;
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),

                    // Role Flow Sequence
                    Text(
                      AppStrings.roleFlow.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? OnyxColors.darkSurface : OnyxColors.neutral50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Visual Flow Sequence
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            children: [
                              for (int i = 0; i < selectedRoleFlow.value.length; i++) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: OnyxColors.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: OnyxColors.primary.withValues(alpha: 0.4)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        selectedRoleFlow.value[i].toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: OnyxColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      InkWell(
                                        onTap: () {
                                          final current = List<String>.from(selectedRoleFlow.value);
                                          current.removeAt(i);
                                          selectedRoleFlow.value = current;
                                        },
                                        child: const Icon(Icons.close, size: 12, color: OnyxColors.primary),
                                      ),
                                    ],
                                  ),
                                ),
                                if (i < selectedRoleFlow.value.length - 1)
                                  const FaIcon(FontAwesomeIcons.arrowRight, size: 10, color: OnyxColors.neutral400),
                              ],
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Quick Role Add Chips
                          Wrap(
                            spacing: 6,
                            children: ['backend', 'middle', 'frontend', 'qa']
                                .where((role) => !selectedRoleFlow.value.contains(role))
                                .map((role) {
                              return ActionChip(
                                label: Text('+ ${role.toUpperCase()}', style: const TextStyle(fontSize: 10)),
                                onPressed: () {
                                  final current = List<String>.from(selectedRoleFlow.value)..add(role);
                                  selectedRoleFlow.value = current;
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Default Role Assignees
                    if (selectedRoleFlow.value.isNotEmpty) ...[
                      Text(
                        AppStrings.defaultRoleAssignees.tr(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...selectedRoleFlow.value.map((role) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 90,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDark ? OnyxColors.neutral800 : OnyxColors.neutral200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  role.toUpperCase(),
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: defaultAssignees.value[role],
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    isDense: true,
                                    hintText: 'Select default assignee...',
                                  ),
                                  items: [
                                    const DropdownMenuItem<String>(
                                      value: null,
                                      child: Text('Auto / None', style: TextStyle(fontSize: 11, color: OnyxColors.neutral400)),
                                    ),
                                    ...users.map((u) {
                                      return DropdownMenuItem<String>(
                                        value: u.name,
                                        child: Text('${u.name} (${u.role.label})', style: const TextStyle(fontSize: 11)),
                                      );
                                    }),
                                  ],
                                  onChanged: (val) {
                                    final current = Map<String, String>.from(defaultAssignees.value);
                                    if (val != null) {
                                      current[role] = val;
                                    } else {
                                      current.remove(role);
                                    }
                                    defaultAssignees.value = current;
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => context.safePop(),
                    child: Text(AppStrings.cancel.tr()),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OnyxColors.primary,
                      foregroundColor: OnyxColors.white,
                    ),
                    icon: isSaving.value
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: OnyxColors.white),
                          )
                        : const FaIcon(FontAwesomeIcons.check, size: 12),
                    label: Text(AppStrings.save.tr()),
                    onPressed: isSaving.value
                        ? null
                        : () async {
                            final name = nameController.text.trim();
                            if (name.isEmpty) return;

                            isSaving.value = true;
                            final leader = users.where((u) => u.id == selectedLeaderId.value).firstOrNull;
                            final team = TeamEntity(
                              id: initialTeam?.id ?? 'team_${DateTime.now().millisecondsSinceEpoch}',
                              name: name,
                              description: descController.text.trim(),
                              leaderId: leader?.id,
                              leaderName: leader?.name,
                              memberIds: selectedMemberIds.value,
                              moduleCodes: selectedModules.value,
                              roleFlow: selectedRoleFlow.value,
                              defaultRoleAssignees: defaultAssignees.value,
                            );

                            if (initialTeam != null) {
                              await workspaceCubit.updateTeam(team);
                            } else {
                              await workspaceCubit.createTeam(team);
                            }

                            if (context.mounted) {
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

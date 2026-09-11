import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_entity.dart';

class RejectPlanDialog extends HookWidget {
  final MonthlyPlanEntity plan;

  const RejectPlanDialog({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    final notesController = useTextEditingController();

    return AlertDialog(
      title: Row(
        children: [
          const FaIcon(FontAwesomeIcons.rotateLeft, size: 18, color: ClickUpColors.danger),
          const SizedBox(width: 10),
          Text(AppStrings.rejectPlanTitle.tr()),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: TextField(
          controller: notesController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: AppStrings.rejectNotesLabel.tr(),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Center(
                widthFactor: 1.0,
                child: FaIcon(FontAwesomeIcons.commentDots, size: 14, color: ClickUpColors.neutral500),
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => context.safePop(),
          icon: const FaIcon(FontAwesomeIcons.xmark, size: 14),
          label: Text(AppStrings.cancel.tr()),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: ClickUpColors.danger,
            foregroundColor: ClickUpColors.lightCard,
          ),
          onPressed: () {
            context.monthPlanCubit.updatePlanStatus(
              planId: plan.id,
              status: PlanStatus.rejected,
              managerNotes: notesController.text.trim(),
            );
            context.safePop();
          },
          icon: const FaIcon(FontAwesomeIcons.paperPlane, size: 14),
          label: Text(AppStrings.sendFeedback.tr()),
        ),
      ],
    );
  }
}

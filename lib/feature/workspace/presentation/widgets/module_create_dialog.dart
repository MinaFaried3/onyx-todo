import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/workspace/domain/entities/onyx_module.dart';

class ModuleCreateDialog extends HookWidget {
  const ModuleCreateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceCubit = context.workspaceCubit;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final codeController = useTextEditingController();
    final nameArController = useTextEditingController();
    final nameEnController = useTextEditingController();
    final descController = useTextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: isDark ? OnyxColors.darkCard : OnyxColors.white,
      child: Container(
        width: 480,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.folderPlus, color: OnyxColors.primary, size: 18),
                const SizedBox(width: 10),
                Text(
                  context.locale.languageCode == 'ar' ? 'إضافة موديول جديد' : 'Create New ERP Module',
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
            const SizedBox(height: 20),

            // Module Code
            Text(
              '${context.locale.languageCode == "ar" ? "رمز الموديول (Code)" : "Module Code"}:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                hintText: 'e.g. INV, ACC, HR, POS',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                isDense: true,
              ),
            ),
            const SizedBox(height: 14),

            // Arabic Name
            Text(
              '${context.locale.languageCode == "ar" ? "الاسم بالعربية" : "Arabic Name"}:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: nameArController,
              decoration: InputDecoration(
                hintText: 'مثال: إدارة المخازن والمشتريات',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                isDense: true,
              ),
            ),
            const SizedBox(height: 14),

            // English Name
            Text(
              '${context.locale.languageCode == "ar" ? "الاسم بالإنجليزية" : "English Name"}:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: nameEnController,
              decoration: InputDecoration(
                hintText: 'e.g. Inventory Management',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                isDense: true,
              ),
            ),
            const SizedBox(height: 14),

            // Description
            Text(
              '${AppStrings.description.tr()}:',
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
                hintText: 'وصف مختصر للموديول...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => context.safePop(),
                  child: Text(AppStrings.cancel.tr()),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OnyxColors.primary,
                    foregroundColor: OnyxColors.white,
                  ),
                  onPressed: () {
                    final code = codeController.text.trim().toUpperCase();
                    final nameAr = nameArController.text.trim();
                    final nameEn = nameEnController.text.trim();

                    if (code.isEmpty || nameAr.isEmpty) return;

                    final newModule = OnyxModule(
                      code: code,
                      nameAr: nameAr,
                      nameEn: nameEn.isNotEmpty ? nameEn : nameAr,
                      description: descController.text.trim(),
                    );

                    workspaceCubit.createModule(newModule);
                    context.safePop();
                  },
                  child: Text(AppStrings.save.tr()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

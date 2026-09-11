import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';

class UserPasswordResetDialog extends HookWidget {
  final String initialEmail;

  const UserPasswordResetDialog({
    super.key,
    required this.initialEmail,
  });

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(text: initialEmail);
    final isSubmitting = useState(false);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final workspaceCubit = context.workspaceCubit;

    return Dialog(
      backgroundColor: isDark ? OnyxColors.darkCard : OnyxColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const FaIcon(FontAwesomeIcons.key, color: OnyxColors.primary, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    AppStrings.resetPassword.tr(),
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
              Text(
                '${AppStrings.email.tr()}:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Center(
                    widthFactor: 1.0,
                    child: FaIcon(FontAwesomeIcons.envelope, size: 13, color: OnyxColors.neutral400),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 20),
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
                    icon: isSubmitting.value
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: OnyxColors.white),
                          )
                        : const FaIcon(FontAwesomeIcons.paperPlane, size: 12),
                    label: Text(AppStrings.sendFeedback.tr()),
                    onPressed: isSubmitting.value
                        ? null
                        : () async {
                            final email = emailController.text.trim();
                            if (email.isEmpty) return;
                            isSubmitting.value = true;
                            await workspaceCubit.resetUserPassword(email);
                            if (context.mounted) {
                              context.safeShowSnackBar(
                                SnackBar(
                                  backgroundColor: OnyxColors.success,
                                  content: Text(AppStrings.passwordResetSent.tr()),
                                ),
                              );
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

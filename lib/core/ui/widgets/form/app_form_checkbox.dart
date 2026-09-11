import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:onyx_todo/core/ui/color_manager.dart';
import 'package:onyx_todo/core/ui/font_manager.dart';
import 'package:onyx_todo/core/ui/responsive/responsive_extension.dart';
import 'package:onyx_todo/core/ui/styles_manager.dart';
import 'package:onyx_todo/core/ui/values_manager.dart';

/// A custom checkbox form field integrated with [FormBuilderField] matching
/// onyx_todo styling, Cairo font, and responsive layout.
class AppFormCheckbox extends StatelessWidget {
  final String name;
  final Widget title;
  final bool initialValue;
  final String? Function(bool?)? validator;
  final void Function(bool?)? onChanged;
  final void Function(bool?)? onSaved;
  final bool enabled;
  final Color? activeColor;
  final Color? checkColor;

  const AppFormCheckbox({
    super.key,
    required this.name,
    required this.title,
    this.initialValue = false,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.enabled = true,
    this.activeColor,
    this.checkColor,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<bool>(
      name: name,
      initialValue: initialValue,
      validator: validator,
      enabled: enabled,
      onChanged: onChanged,
      onSaved: onSaved,
      builder: (FormFieldState<bool?> fieldState) {
        final fbState = fieldState as FormBuilderFieldState<FormBuilderField<bool>, bool>;
        final hasError = fbState.hasError;
        final errorText = fbState.errorText;

        final isChecked = fbState.value ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: enabled
                  ? () {
                      final newValue = !isChecked;
                      fbState.didChange(newValue);
                      if (fbState.hasError) fbState.clearError();
                      onChanged?.call(newValue);
                    }
                  : null,
              borderRadius: BorderRadius.circular(AppSize.s8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: isChecked,
                    activeColor: activeColor ?? ColorsManager.primary,
                    checkColor: checkColor ?? ColorsManager.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.s4),
                    ),
                    onChanged: enabled
                        ? (val) {
                            fbState.didChange(val ?? false);
                            if (fbState.hasError) fbState.clearError();
                            onChanged?.call(val);
                          }
                        : null,
                  ),
                  Flexible(child: title),
                ],
              ),
            ),
            if (hasError && errorText != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: AppPadding.p2,
                  left: AppPadding.p12,
                  right: AppPadding.p12,
                ),
                child: Text(
                  errorText,
                  style: get500MediumStyle(
                    fontSize: context.fontSize(12),
                    color: ColorsManager.error,
                    fontFamily: FontConstants.cairoFontFamily,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

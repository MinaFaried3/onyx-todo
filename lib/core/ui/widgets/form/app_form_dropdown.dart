import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:onyx_todo/core/ui/color_manager.dart';
import 'package:onyx_todo/core/ui/font_manager.dart';
import 'package:onyx_todo/core/ui/responsive/responsive_extension.dart';
import 'package:onyx_todo/core/ui/styles_manager.dart';
import 'package:onyx_todo/core/ui/values_manager.dart';
import 'package:onyx_todo/core/ui/widgets/form/required_label.dart';


/// Wrapper to avoid Flutter's PopupMenuButton null-value bug.
/// PopupMenuButton doesn't trigger onSelected when value is null.
class _DropdownOption<T> {
  const _DropdownOption(this.value);
  final T? value;
}

/// A form-integrated dropdown that uses the [AppDropdownFilter] chip + popup UI,
/// wired to [FormBuilderField] for full validation, error display, and form submission.
///
/// The API mirrors [AppDropdownFilter]: pass [options] and an optional [itemLabel]
/// resolver instead of raw [DropdownMenuItem] list.
///
/// Usage:
/// ```dart
/// AppFormDropdown<DriverStatus>(
///   name: 'status',
///   labelText: 'الحالة',
///   hintText: 'اختر الحالة',
///   options: DriverStatus.values,
///   itemLabel: (s) => s.label,
///   validator: (v) => v == null ? 'مطلوب' : null,
///   onChanged: (v) => cubit.onStatusChanged(v),
/// )
/// ```
class AppFormDropdown<T> extends StatelessWidget {
  const AppFormDropdown({
    super.key,
    required this.name,
    required this.options,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.errorMessage,
    this.itemLabel,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.enabled = true,
    this.focusNode,
    this.isRequired = false,
    this.generalOptionValue,
  });

  final String name;

  /// All selectable options.
  final List<T> options;

  /// Pre-selected value. `null` = nothing selected.
  final T? initialValue;

  /// Optional label above the chip — same as [AppTextField.labelText].
  /// When provided, this text will also appear as the first "general" option in the dropdown menu.
  final String? labelText;

  /// Placeholder text shown inside the chip when nothing is selected.
  final String? hintText;

  /// Static error message (overridden by FormBuilder validator errors).
  final String? errorMessage;

  /// Resolves a display string for each option. Falls back to [toString].
  final String Function(T option)? itemLabel;

  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;
  final void Function(T?)? onSaved;
  final bool enabled;
  final FocusNode? focusNode;
  final bool isRequired;
  
  /// The value to use for the "general" option (the one displaying [labelText]).
  /// If null and [labelText] is provided, the general option will use null as its value.
  final T? generalOptionValue;

  String _resolve(T option) =>
      itemLabel != null ? itemLabel!(option) : option.toString();

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<T>(
      name: name,
      initialValue: initialValue,
      validator: validator,
      enabled: enabled,
      onChanged: onChanged,
      onSaved: onSaved,
      builder: (FormFieldState<T?> fieldState) {
        final fbState =
            fieldState as FormBuilderFieldState<FormBuilderField<T>, T>;
        final effectiveError = fbState.errorText ?? errorMessage;
        final hasError = effectiveError != null && effectiveError.isNotEmpty;
        final selected = fbState.value;

        // Label shown on the chip: selected option or hint/placeholder.
        final chipLabel = selected != null
            ? _resolve(selected)
            : (hintText ?? labelText ?? '');

        // Responsive popup min-width matches OnyxDropdownFilter.
        final popupMinWidth = context.responsiveValue<double>(
          mobile: 120,
          tablet: 140,
          desktop: 157,
        );
        final chipHeight = context.responsiveValue<double>(
          mobile: 36,
          tablet: 40,
          desktop: 43.6,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Optional label above chip ─────────────────────────────────
            if (labelText != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppPadding.p6),
                child: RequiredLabel(text: labelText!, isRequired: isRequired),
              ),

            // ── Chip + popup ──────────────────────────────────────────────
            PopupMenuButton<_DropdownOption<T>>(
              enabled: enabled,
              constraints: BoxConstraints(minWidth: popupMinWidth),
              onSelected: (wrapped) {
                final val = wrapped.value;
                fbState.didChange(val);
                if (fbState.hasError) fbState.clearError();
                onChanged?.call(val);
              },
              offset: Offset(0, chipHeight + AppSize.s4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  context.responsiveValue<double>(
                      mobile: 6, tablet: 7, desktop: 8),
                ),
                side: BorderSide(
                  color: hasError
                      ? ColorsManager.error
                      : ColorsManager.borderBeige,
                  width: 1.2,
                ),
              ),
              color: ColorsManager.white,
              elevation: 4,
              shadowColor: Colors.black12,
              itemBuilder: (context) {
                final items = <PopupMenuItem<_DropdownOption<T>>>[];
                
                // Add general option if labelText is provided
                if (labelText != null) {
                  items.add(
                    PopupMenuItem<_DropdownOption<T>>(
                      value: _DropdownOption(generalOptionValue),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.responsiveValue<double>(
                            mobile: 10, tablet: 12, desktop: 14),
                        vertical: context.responsiveValue<double>(
                            mobile: 6, tablet: 7, desktop: 8),
                      ),
                      child: DropdownItem(
                        label: labelText!,
                        isSelected: selected == generalOptionValue,
                      ),
                    ),
                  );
                }
                
                // Add regular options
                items.addAll(
                  options.map(
                    (opt) => PopupMenuItem<_DropdownOption<T>>(
                      value: _DropdownOption(opt),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.responsiveValue<double>(
                            mobile: 10, tablet: 12, desktop: 14),
                        vertical: context.responsiveValue<double>(
                            mobile: 6, tablet: 7, desktop: 8),
                      ),
                      child: DropdownItem(
                        label: _resolve(opt),
                        isSelected: selected == opt,
                      ),
                    ),
                  ),
                );
                
                return items;
              },
              child: DropdownChip(
                label: chipLabel,
                isActive: selected != null,
                hasError: hasError,
                enabled: enabled,
              ),
            ),

            // ── Error text ────────────────────────────────────────────────
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(
                  top: AppPadding.p4,
                  left: AppPadding.p8,
                  right: AppPadding.p8,
                ),
                child: Text(
                  effectiveError,
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



// ─── Chip (the tappable trigger button) ──────────────────────────────────────

class DropdownChip extends StatelessWidget {
  const DropdownChip({
    super.key,
    required this.label,
    required this.isActive,
    this.hasError = false,
    this.enabled = true,
  });

  final String label;
  final bool isActive;

  /// When true, the border turns red to match form error state.
  final bool hasError;

  /// When false, dims the chip to signal disabled state.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final height = context.responsiveValue<double>(
      mobile: 36,
      tablet: 40,
      desktop: 43.6,
    );
    final hPad = context.responsiveValue<double>(
      mobile: 10,
      tablet: 12,
      desktop: 14,
    );
    final radius = context.responsiveValue<double>(
      mobile: 8,
      tablet: 9,
      desktop: 10,
    );
    final fontSize = context.fontSize(
      context.responsiveValue<double>(mobile: 11, tablet: 12, desktop: 13),
    );
    final iconSize = context.responsiveValue<double>(
      mobile: 14,
      tablet: 16,
      desktop: 18,
    );
    final borderWidth = context.responsiveValue<double>(
      mobile: 1.2,
      tablet: 1.5,
      desktop: 1.82,
    );

    final borderColor = hasError
        ? ColorsManager.error
        : isActive
            ? ColorsManager.grey400
            : ColorsManager.grey200;

    final textColor = !enabled
        ? ColorsManager.grey99
        : isActive
            ? ColorsManager.grey1E
            : ColorsManager.grey99;

    final iconColor = !enabled
        ? ColorsManager.grey99
        : isActive
            ? ColorsManager.grey44
            : ColorsManager.grey99;

    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: hPad),
        decoration: BoxDecoration(
          color: ColorsManager.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: get400RegularStyle(
                  fontSize: fontSize,
                  color: textColor,
                  fontFamily: FontConstants.cairoFontFamily,
                ).copyWith(height: 1.0, letterSpacing: 0),
              ),
            ),
            SizedBox(
              width: context.responsiveValue<double>(
                  mobile: 4, tablet: 6, desktop: 8),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: iconSize,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Popup item row ───────────────────────────────────────────────────────────

class DropdownItem extends StatelessWidget {
  const DropdownItem({super.key, required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final fontSize = context.fontSize(
      context.responsiveValue<double>(mobile: 11, tablet: 12, desktop: 13),
    );
    final checkSize = context.responsiveValue<double>(
      mobile: 13,
      tablet: 14,
      desktop: 16,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: (isSelected
                    ? get600SemiBoldStyle(
                        fontSize: fontSize,
                        color: ColorsManager.primary,
                        fontFamily: FontConstants.cairoFontFamily,
                      )
                    : get400RegularStyle(
                        fontSize: fontSize,
                        color: ColorsManager.grey1E,
                        fontFamily: FontConstants.cairoFontFamily,
                      ))
                .copyWith(height: 1.5, letterSpacing: 0),
          ),
        ),
        if (isSelected) ...[
          SizedBox(
            width: context.responsiveValue<double>(mobile: 4, tablet: 6, desktop: 8),
          ),
          Icon(Icons.check_rounded, size: checkSize, color: ColorsManager.primary),
        ],
      ],
    );
  }
}
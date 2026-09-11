//----------- Imports -----------
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onyx_todo/core/ui/color_manager.dart';
import 'package:onyx_todo/core/ui/font_manager.dart';
import 'package:onyx_todo/core/ui/responsive/responsive_extension.dart';
import 'package:onyx_todo/core/ui/styles_manager.dart';
import 'package:onyx_todo/core/ui/values_manager.dart';
import 'package:onyx_todo/core/ui/widgets/form/required_label.dart';

//----------- AppTextField Widget -----------
class AppTextField extends HookWidget {
  //----------- Properties -----------
  final String? fieldId;
  final TextEditingController? controller;
  final String? initialValue;
  final String? errorMessage;
  final String? Function(String?)? validator;
  final String? labelText;
  final String? hintText;
  final bool isPassword;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final double? height;
  final BorderRadius? borderRadius;
  final void Function(String?)? onChanged;
  final void Function(String?)? onFieldSubmitted;
  final void Function()? onTap;
  final void Function(String?)? onSaved;
  final FocusNode? focusNode;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextDirection? textDirection;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final String? svgPrefixPath;
  final Widget? prefix;
  final Widget? suffix;
  final Color? fillColor;
  final Color? hintColor;
  final double? fontSize;
  final ValueTransformer<String?>? valueTransformer;
  final bool isRequired;
  final bool autofocus;

  //----------- Constructor -----------
  const AppTextField({
    super.key,
    this.fieldId,
    this.controller,
    this.initialValue,
    this.errorMessage,
    this.validator,
    this.labelText,
    this.hintText,
    this.isPassword = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.height,
    this.fontSize,
    this.borderRadius,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.onSaved,
    this.focusNode,
    this.textInputType,
    this.textInputAction,
    this.textDirection,
    this.autofillHints,
    this.inputFormatters,
    this.svgPrefixPath,
    this.prefix,
    this.suffix,
    this.fillColor,
    this.hintColor,
    this.valueTransformer,
    this.isRequired = false,
    this.autofocus = false,
  });

  //----------- Build Method -----------
  @override
  Widget build(BuildContext context) {
    //----------- Hooks State -----------
    final obscureText = useState(isPassword);

    //----------- Responsive & Style Resolvers -----------
    final iconSize = context.responsiveValue<double>(
      mobile: 13,
      tablet: 14,
      desktop: 15,
    );
    final textFontSize = context.fontSize(
      fontSize ?? context.responsiveValue<double>(mobile: 13, tablet: 13, desktop: 13),
    );

    final effectiveHintColor = hintColor ?? const Color(0xFFBDBDBD);

    final prefixIcon = svgPrefixPath != null
        ? _SvgFieldIcon(
            assetPath: svgPrefixPath!,
            iconSize: iconSize,
            color: effectiveHintColor,
          )
        : prefix;

    final suffixIcon = suffix ??
        (isPassword
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
                child: IconButton(
                  icon: Icon(
                    obscureText.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: effectiveHintColor,
                  ),
                  onPressed: () => obscureText.value = !obscureText.value,
                ),
              )
            : null);

    //----------- Field Builder Helper -----------
    Widget buildField([
      FormBuilderFieldState<FormBuilderField<String>, String>? fieldState,
    ]) {
      final effectiveError = fieldState?.errorText ?? errorMessage;
      final hasError = effectiveError != null && effectiveError.isNotEmpty;

      //----------- Border & Input Decoration -----------
      final radius = borderRadius ?? const BorderRadius.all(Radius.circular(7));

      final enabledBorder = OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(
          color: hasError ? ColorsManager.error : const Color(0xFFE0DDDA),
          width: 1.87,
        ),
      );

      final focusedBorder = OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(
          color: hasError ? ColorsManager.error : ColorsManager.primary,
          width: 1.87,
        ),
      );

      final errorBorder = OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(
          color: ColorsManager.error,
          width: 1.87,
        ),
      );

      // Multi-line: let Flutter size naturally.
      // Single-line: control exact height via vertical contentPadding.
      final isMultiLine =
          !isPassword && ((maxLines != null && maxLines! > 1) || minLines != null);

      // For single-line, derive vertical padding so the field hits the target height.
      // Formula: targetHeight = fontSize(13) + 2*vPad + borderWidth(1.87)*2
      // → vPad = (targetHeight - 13 - 3.74) / 2  ≈ (targetHeight - 16.74) / 2
      // Clamped to avoid negative/excessive values.
      final targetHeight = height ?? 44.0;
      final vPad = isMultiLine
          ? AppPadding.p12
          : ((targetHeight - textFontSize - 3.74) / 2).clamp(4.0, 20.0);

      //----------- TextField Core -----------
      final textField = TextFormField(
        controller: controller,
        initialValue: controller == null
            ? (fieldState?.value ?? initialValue)
            : null,
        focusNode: focusNode ?? fieldState?.effectiveFocusNode,
        autofocus: autofocus,
        enabled: enabled,
        readOnly: readOnly,
        obscureText: isPassword ? obscureText.value : false,
        keyboardType: textInputType,
        textInputAction: textInputAction ?? TextInputAction.next,
        // Single-line: maxLines:1 prevents vertical scroll; SizedBox controls height.
        // Multi-line: respect the caller's maxLines/minLines.
        maxLines: isMultiLine ? maxLines : 1,
        minLines: isMultiLine ? minLines : null,
        maxLength: maxLength,
        autofillHints: autofillHints,
        inputFormatters: inputFormatters,
        style: get500MediumStyle(
          fontSize: textFontSize,
          fontFamily: FontConstants.cairoFontFamily,
        ),
        onTap: onTap,
        onSaved: onSaved,
        onFieldSubmitted: onFieldSubmitted,
        validator: null,
        onChanged: (text) {
          fieldState?.didChange(text);
          if (fieldState?.hasError == true) {
            fieldState?.clearError();
          }
          onChanged?.call(text);
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: get500MediumStyle(
            fontSize: textFontSize,
            color: effectiveHintColor,
            fontFamily: FontConstants.cairoFontFamily,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: fillColor ?? ColorsManager.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppPadding.p12,
            vertical: vPad,
          ),
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          errorBorder: errorBorder,
          focusedErrorBorder: errorBorder,
          border: enabledBorder,
        ),
      );

      //----------- Field Structure -----------
      final field = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppPadding.p6),
              child: RequiredLabel(text: labelText!, isRequired: isRequired),
            ),
          // Multi-line grows naturally; single-line height via contentPadding.
          textField,
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

      return textDirection != null
          ? Directionality(textDirection: textDirection!, child: field)
          : field;
    }

    //----------- FormBuilder Integration -----------
    if (fieldId != null && fieldId!.isNotEmpty) {
      return FormBuilderField<String>(
        name: fieldId!,
        validator: validator,
        initialValue: initialValue ?? controller?.text,
        enabled: enabled,
        onSaved: onSaved,
        onChanged: onChanged,
        valueTransformer: valueTransformer,
        builder: (fieldState) => buildField(
          fieldState as FormBuilderFieldState<FormBuilderField<String>, String>,
        ),
      );
    }

    return buildField();
  }
}

//----------- Helper Widgets -----------
class _SvgFieldIcon extends StatelessWidget {
  const _SvgFieldIcon({
    required this.assetPath,
    required this.iconSize,
    required this.color,
  });

  final String assetPath;
  final double iconSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: SvgPicture.asset(
        assetPath,
        width: iconSize,
        height: iconSize,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}

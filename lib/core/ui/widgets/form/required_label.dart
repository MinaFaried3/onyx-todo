import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/color_manager.dart';
import 'package:onyx_todo/core/ui/font_manager.dart';
import 'package:onyx_todo/core/ui/styles_manager.dart';

/// Renders a field label with an optional red asterisk suffix for required fields.
///
/// Usage:
/// ```dart
/// RequiredLabel(text: 'Email', isRequired: true)
/// ```
class RequiredLabel extends StatelessWidget {
  const RequiredLabel({
    super.key,
    required this.text,
    this.isRequired = false,
  });

  final String text;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final labelStyle = get400RegularStyle(
      fontSize: 11,
      color: ColorsManager.nutrailColor1,
      fontFamily: FontConstants.cairoFontFamily,
    ).copyWith(height: 1.5);

    if (!isRequired) {
      return Text(text, style: labelStyle);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: labelStyle),
        const SizedBox(width: 2),
        Text(
          '*',
          style: labelStyle.copyWith(color: ColorsManager.error),
        ),
      ],
    );
  }
}

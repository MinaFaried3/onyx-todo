import 'package:onyx_todo/core/utils/image_picker/image_picker_source.dart';
import 'package:onyx_todo/core/utils/image_picker/picked_image.dart';
import 'package:onyx_todo/core/utils/image_picker/image_picker_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

typedef FormImagePickerBuilder =
    Widget Function(
      BuildContext context,
      PickedImage? image,
      bool hasError,
      String? errorText,
      VoidCallback pickImage,
    );

class AppFormImagePicker extends StatelessWidget {
  const AppFormImagePicker({
    super.key,
    required this.name,
    required this.builder,
    this.initialValue,
    this.errorMessage,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.enabled = true,
    this.source,
    this.showErrorTooltip = true,
  });

  final String name;
  final FormImagePickerBuilder builder;
  final PickedImage? initialValue;
  final String? errorMessage;
  final String? Function(PickedImage?)? validator;
  final void Function(PickedImage?)? onChanged;
  final void Function(PickedImage?)? onSaved;
  final bool enabled;
  final ImagePickerSource? source;
  final bool showErrorTooltip;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<PickedImage?>(
      name: name,
      initialValue: initialValue,
      validator: validator,
      enabled: enabled,
      onChanged: onChanged,
      onSaved: onSaved,
      builder: (fieldState) {
        final effectiveError = fieldState.errorText ?? errorMessage;
        final hasError = effectiveError != null && effectiveError.isNotEmpty;

        final picker = builder(
          context,
          fieldState.value,
          hasError,
          effectiveError,
          () async {
            if (!enabled) return;

            final pickedImage = await context.pickSingleImage(source: source);
            if (pickedImage == null || !context.mounted) return;

            fieldState.didChange(pickedImage);
            if (fieldState.hasError) fieldState.clearError();
            onChanged?.call(pickedImage);
          },
        );

        if (!showErrorTooltip || !hasError) return picker;

        return Tooltip(
          message: effectiveError,
          preferBelow: false,
          child: picker,
        );
      },
    );
  }
}

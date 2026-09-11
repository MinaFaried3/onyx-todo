import 'package:onyx_todo/core/localization/core_strings.dart';
import 'package:onyx_todo/core/localization/localization_packages.dart';
import 'package:onyx_todo/core/ui/color_manager.dart';
import 'package:onyx_todo/core/ui/font_manager.dart';
import 'package:onyx_todo/core/ui/styles_manager.dart';
import 'package:onyx_todo/core/ui/values_manager.dart';
import 'package:onyx_todo/core/utils/image_picker/image_picker_source.dart';
import 'package:flutter/material.dart';

Future<ImagePickerSource?> showImagePickerBottomSheet(BuildContext context) {
  return showModalBottomSheet<ImagePickerSource>(
    context: context,
    backgroundColor: ColorsManager.surfaceContainerLowest,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSize.s20),
      ),
    ),
    builder: (modalContext) => const ImagePickerBottomSheet(),
  );
}

class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p20,
          vertical: AppPadding.p16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: AppSize.s40,
                height: AppSize.s4,
                margin: const EdgeInsets.only(bottom: AppMargin.m16),
                decoration: BoxDecoration(
                  color: ColorsManager.nutrailColor1.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(AppSize.s2),
                ),
              ),
            ),
            // Title
            Text(
              CoreStrings.chooseImageSource.tr(),
              style: get600SemiBoldStyle(
                color: ColorsManager.onSurface,
                fontSize: FontSize.s16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSize.s20),
            // Camera option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(AppPadding.p8),
                decoration: BoxDecoration(
                  color: ColorsManager.main1.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: ColorsManager.main1,
                  size: AppSize.s24,
                ),
              ),
              title: Text(
                CoreStrings.camera.tr(),
                style: get500MediumStyle(
                  color: ColorsManager.onSurface,
                  fontSize: FontSize.s14,
                ),
              ),
              onTap: () => Navigator.of(context).pop(ImagePickerSource.camera),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s12),
              ),
            ),
            const SizedBox(height: AppSize.s8),
            // Gallery option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(AppPadding.p8),
                decoration: BoxDecoration(
                  color: ColorsManager.main2.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.photo_library_outlined,
                  color: ColorsManager.main2,
                  size: AppSize.s24,
                ),
              ),
              title: Text(
                CoreStrings.gallery.tr(),
                style: get500MediumStyle(
                  color: ColorsManager.onSurface,
                  fontSize: FontSize.s14,
                ),
              ),
              onTap: () => Navigator.of(context).pop(ImagePickerSource.gallery),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s12),
              ),
            ),
            const SizedBox(height: AppSize.s12),
          ],
        ),
      ),
    );
  }
}

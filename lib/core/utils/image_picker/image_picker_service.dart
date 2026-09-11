import 'dart:typed_data';

import 'package:onyx_todo/core/config/platform/platform.dart';
import 'package:onyx_todo/core/utils/image_picker/image_picker_source.dart';
import 'package:onyx_todo/core/utils/image_picker/picked_image.dart';
import 'package:onyx_todo/core/utils/image_picker/widgets/image_picker_bottom_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppImagePickerService {
  const AppImagePickerService();

  static const instance = AppImagePickerService();

  /// Picks a single image.
  ///
  /// - On **Mobile** (CurrentPlatform.isMobile):
  ///   - If [source] is provided, picks directly from that source.
  ///   - If [source] is null and [context] is provided, opens a bottom sheet to let the user choose Camera or Gallery.
  ///   - If [source] is null and [context] is null, defaults to [ImagePickerSource.gallery].
  /// - On **Web / Desktop** (CurrentPlatform.isWeb or desktop):
  ///   - Uses [FilePicker] to open the native platform file browser directly without bottom sheet.
  Future<PickedImage?> pickImage({
    BuildContext? context,
    ImagePickerSource? source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    if (CurrentPlatform.isMobile) {
      var selectedSource = source;
      if (selectedSource == null && context != null && context.mounted) {
        selectedSource = await showImagePickerBottomSheet(context);
        if (selectedSource == null) return null;
      } else {
        selectedSource ??= ImagePickerSource.gallery;
      }

      final picker = ImagePicker();
      final imgSource = switch (selectedSource) {
        ImagePickerSource.camera => ImageSource.camera,
        ImagePickerSource.gallery => ImageSource.gallery,
      };

      final xFile = await picker.pickImage(
        source: imgSource,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      if (xFile == null) return null;

      final bytes = await xFile.readAsBytes();
      return PickedImage(
        bytes: bytes,
        path: xFile.path,
        name: xFile.name,
        size: bytes.length,
      );
    } else {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      final file = result.files.first;
      final bytes = file.bytes;
      final path = file.path?.trim();

      if (bytes == null && (path == null || path.isEmpty)) {
        return null;
      }

      return PickedImage(
        bytes: bytes,
        path: path,
        name: file.name,
        size: file.size,
      );
    }
  }

  /// Picks multiple images.
  ///
  /// - On **Mobile** (CurrentPlatform.isMobile):
  ///   - If [source] is null and [context] is provided, opens bottom sheet.
  ///   - If Camera selected: takes single photo and returns as single-element list.
  ///   - If Gallery selected: opens multi-image gallery picker.
  /// - On **Web / Desktop** (CurrentPlatform.isWeb or desktop):
  ///   - Uses [FilePicker] with allowMultiple: true to open the native platform file browser directly.
  Future<List<PickedImage>> pickMultiImage({
    BuildContext? context,
    ImagePickerSource? source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
  }) async {
    if (CurrentPlatform.isMobile) {
      var selectedSource = source;
      if (selectedSource == null && context != null && context.mounted) {
        selectedSource = await showImagePickerBottomSheet(context);
        if (selectedSource == null) return const [];
      } else {
        selectedSource ??= ImagePickerSource.gallery;
      }

      final picker = ImagePicker();

      if (selectedSource == ImagePickerSource.camera) {
        final xFile = await picker.pickImage(
          source: ImageSource.camera,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
        );

        if (xFile == null) return const [];

        final bytes = await xFile.readAsBytes();
        return [
          PickedImage(
            bytes: bytes,
            path: xFile.path,
            name: xFile.name,
            size: bytes.length,
          ),
        ];
      } else {
        final xFiles = await picker.pickMultiImage(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
          limit: limit,
        );

        if (xFiles.isEmpty) return const [];

        final results = <PickedImage>[];
        for (final xFile in xFiles) {
          final bytes = await xFile.readAsBytes();
          results.add(
            PickedImage(
              bytes: bytes,
              path: xFile.path,
              name: xFile.name,
              size: bytes.length,
            ),
          );
        }
        return results;
      }
    } else {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return const [];
      }

      return result.files
          .where((f) => f.bytes != null || (f.path != null && f.path!.isNotEmpty))
          .map(
            (f) => PickedImage(
              bytes: f.bytes,
              path: f.path?.trim(),
              name: f.name,
              size: f.size,
            ),
          )
          .toList();
    }
  }

  /// Convenience method to pick a single image and return its bytes.
  Future<Uint8List?> pickImageBytes({
    BuildContext? context,
    ImagePickerSource? source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final picked = await pickImage(
      context: context,
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    return picked?.bytes;
  }

  /// Convenience method to pick a single image and return its local file path.
  Future<String?> pickImagePath({
    BuildContext? context,
    ImagePickerSource? source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final picked = await pickImage(
      context: context,
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    return picked?.path;
  }
}

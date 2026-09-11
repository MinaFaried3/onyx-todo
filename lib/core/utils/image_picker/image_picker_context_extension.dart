import 'package:onyx_todo/core/utils/image_picker/image_compression_options.dart';
import 'package:onyx_todo/core/utils/image_picker/image_picker_service.dart';
import 'package:onyx_todo/core/utils/image_picker/image_picker_source.dart';
import 'package:onyx_todo/core/utils/image_picker/picked_image.dart';
import 'package:flutter/material.dart';

/// BuildContext extension for effortless, platform-aware image selection and compression.
extension ImagePickerContextExtension on BuildContext {
  /// Pick a single image using smart platform dispatch:
  /// - Mobile: Shows Camera/Gallery bottom sheet.
  /// - Web/Desktop: Opens file explorer directly.
  Future<PickedImage?> pickSingleImage({
    ImagePickerSource? source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) => AppImagePickerService.instance.pickImage(
    context: this,
    source: source,
    maxWidth: maxWidth,
    maxHeight: maxHeight,
    imageQuality: imageQuality,
  );

  /// Pick a single image with smart threshold-based compression.
  Future<PickedImage?> pickSingleImageCompressed({
    ImagePickerSource? source,
    ImageCompressionOptions options = const ImageCompressionOptions(),
  }) async {
    final picked = await pickSingleImage(
      source: source,
      maxWidth: options.maxWidth.toDouble(),
      maxHeight: options.maxHeight.toDouble(),
      imageQuality: options.quality,
    );
    if (picked == null) return null;
    return picked.compressIfNeeded(options: options);
  }

  /// Pick multiple images using smart platform dispatch:
  /// - Mobile: Shows Camera (single capture) or Gallery (multi-select) bottom sheet.
  /// - Web/Desktop: Opens file explorer with multi-select directly.
  Future<List<PickedImage>> pickMultipleImages({
    ImagePickerSource? source,
    int? limit,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) => AppImagePickerService.instance.pickMultiImage(
    context: this,
    source: source,
    limit: limit,
    maxWidth: maxWidth,
    maxHeight: maxHeight,
    imageQuality: imageQuality,
  );

  /// Pick multiple images with smart threshold-based compression.
  Future<List<PickedImage>> pickMultipleImagesCompressed({
    ImagePickerSource? source,
    int? limit,
    ImageCompressionOptions options = const ImageCompressionOptions(),
  }) async {
    final pickedList = await pickMultipleImages(
      source: source,
      limit: limit,
      maxWidth: options.maxWidth.toDouble(),
      maxHeight: options.maxHeight.toDouble(),
      imageQuality: options.quality,
    );
    return Future.wait(
      pickedList.map((img) => img.compressIfNeeded(options: options)),
    );
  }
}

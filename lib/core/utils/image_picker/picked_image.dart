import 'dart:typed_data';

import 'package:onyx_todo/core/utils/image_picker/image_compression_options.dart';
import 'package:onyx_todo/core/utils/image_picker/image_compressor.dart';
import 'package:dio/dio.dart';

class PickedImage {
  const PickedImage({
    this.bytes,
    this.path,
    this.name,
    this.size,
  });

  final Uint8List? bytes;
  final String? path;
  final String? name;
  final int? size;

  bool get hasData => bytes != null || (path != null && path!.isNotEmpty);

  /// Returns a new [PickedImage] compressed only if size exceeds [options.maxSizeInBytes].
  Future<PickedImage> compressIfNeeded({
    ImageCompressionOptions options = const ImageCompressionOptions(),
  }) async {
    final currentBytes = bytes;
    if (currentBytes == null || currentBytes.lengthInBytes <= options.maxSizeInBytes) {
      return this;
    }

    final compressed = await ImageCompressor.compressIfNeeded(
      currentBytes,
      options: options,
    );

    return PickedImage(
      bytes: compressed,
      path: path,
      name: name,
      size: compressed.lengthInBytes,
    );
  }

  /// Converts this [PickedImage] into a Dio [MultipartFile] ready for multipart/form-data API upload.
  ///
  /// Works reliably on both **Web** and **Mobile**:
  /// - Uses [bytes] via [MultipartFile.fromBytes] when available (safe on all platforms including Web).
  /// - Falls back to [path] via [MultipartFile.fromFile] on native platforms.
  Future<MultipartFile?> toMultipartFile({String? customFileName}) async {
    final fileName = customFileName ?? name ?? 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

    if (bytes != null) {
      return MultipartFile.fromBytes(
        bytes!,
        filename: fileName,
      );
    }

    if (path != null && path!.isNotEmpty) {
      return await MultipartFile.fromFile(
        path!,
        filename: fileName,
      );
    }

    return null;
  }

  /// Synchronous conversion using in-memory [bytes].
  /// Returns null if [bytes] is null.
  MultipartFile? toMultipartFileSync({String? customFileName}) {
    if (bytes == null) return null;
    final fileName = customFileName ?? name ?? 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    return MultipartFile.fromBytes(
      bytes!,
      filename: fileName,
    );
  }
}

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:onyx_todo/core/utils/image_picker/image_compression_options.dart';

abstract final class ImageCompressor {
  /// Compresses [rawBytes] only if the size exceeds [options.maxSizeInBytes].
  ///
  /// Works uniformly across Flutter Web, Android, iOS, macOS, Windows, and Linux
  /// without requiring native platform channels or C++ binaries.
  static Future<Uint8List> compressIfNeeded(
    Uint8List rawBytes, {
    ImageCompressionOptions options = const ImageCompressionOptions(),
  }) async {
    if (rawBytes.lengthInBytes <= options.maxSizeInBytes) {
      return rawBytes;
    }

    try {
      final codec = await ui.instantiateImageCodec(
        rawBytes,
        targetWidth: options.maxWidth,
        targetHeight: options.maxHeight,
      );
      final frameInfo = await codec.getNextFrame();
      final image = frameInfo.image;

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return rawBytes;

      return byteData.buffer.asUint8List();
    } catch (_) {
      return rawBytes;
    }
  }
}

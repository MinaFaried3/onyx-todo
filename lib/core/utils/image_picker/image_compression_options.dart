class ImageCompressionOptions {
  const ImageCompressionOptions({
    this.maxSizeInBytes = 2 * 1024 * 1024, // 2MB default threshold
    this.minSizeInBytes = 50 * 1024,       // 50KB minimum
    this.maxWidth = 1920,
    this.maxHeight = 1920,
    this.quality = 85,
  });

  /// Maximum file size threshold in bytes. Images larger than this will be compressed.
  final int maxSizeInBytes;

  /// Minimum file size threshold in bytes. Images smaller than this are never compressed.
  final int minSizeInBytes;

  /// Maximum width to scale down to (maintains aspect ratio).
  final int maxWidth;

  /// Maximum height to scale down to (maintains aspect ratio).
  final int maxHeight;

  /// Compression quality between 0 and 100.
  final int quality;
}

import "package:cached_network_image/cached_network_image.dart";
import "package:onyx_todo/core/config/platform/platform.dart";
import "package:flutter/material.dart";

import "custom_error_widget.dart";

class CustomCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double? size;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final bool useCacheAtWeb;

  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.size,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.useCacheAtWeb = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = size ?? width;
    final effectiveHeight = size ?? height;
    final fallbackError = errorWidget ??
        SizedBox(
          width: effectiveWidth,
          height: effectiveHeight,
          child: const CustomErrorWidget(),
        );

    if (imageUrl == null || imageUrl!.isEmpty) {
      return fallbackError;
    }

    Widget imageWidget;

    if (CurrentPlatform.isWeb && !useCacheAtWeb) {
      imageWidget = Image.network(
        imageUrl!,
        width: effectiveWidth,
        height: effectiveHeight,
        fit: fit,
        webHtmlElementStrategy: .prefer,
        errorBuilder: (_, _, _) => fallbackError,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return placeholder ??
              SizedBox(
                width: effectiveWidth,
                height: effectiveHeight,
              );
        },
      );
    } else {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl!,
        width: effectiveWidth,
        height: effectiveHeight,
        fit: fit,
        placeholder: (_, _) =>
            placeholder ??
            SizedBox(
              width: effectiveWidth,
              height: effectiveHeight,
            ),
        errorWidget: (_, _, _) => fallbackError,
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

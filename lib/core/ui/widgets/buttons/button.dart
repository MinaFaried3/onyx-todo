import 'package:onyx_todo/core/ui/color_manager.dart';
import 'package:onyx_todo/core/ui/font_manager.dart';
import 'package:onyx_todo/core/ui/responsive/responsive_extension.dart';
import 'package:onyx_todo/core/ui/styles_manager.dart';
import 'package:onyx_todo/core/ui/values_manager.dart';
import 'package:flutter/material.dart';


/// A flexible, reusable custom button widget with responsive sizing, loading state,
/// localization support, and customizable styling.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.width = double.infinity,
    this.height,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.foregroundColor,
    this.borderRadius = 15.0,
    this.elevation = 0.0,
    this.padding = const EdgeInsets.all(AppPadding.p10),
    this.textStyle,
    this.fontSize,
    this.fontFamily = FontConstants.cairoFontFamily,
    this.isLocalized = true,
    this.icon,
    this.progressIndicatorColor = ColorsManager.white,
    this.progressIndicatorSize = AppSize.s22,
    this.strokeWidth = 2.5,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final Color? foregroundColor;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final double? fontSize;
  final String? fontFamily;
  final bool isLocalized;
  final Widget? icon;
  final Color progressIndicatorColor;
  final double progressIndicatorSize;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ?? ColorsManager.primary;
    final effectiveDisabledBgColor = disabledBackgroundColor ??
        effectiveBgColor.withValues(alpha: 0.6);
    final effectiveFgColor = foregroundColor ?? ColorsManager.white;

    final defaultFontSize = context.fontSize(
      context.responsiveValue(mobile: 15, tablet: 16, desktop: 18),
    );

    final defaultTextStyle = get600SemiBoldStyle(
      fontSize: fontSize ?? defaultFontSize,
      color: effectiveFgColor,
    ).copyWith(
      fontFamily: fontFamily ?? FontConstants.cairoFontFamily,
    );

   

    return SizedBox(
      width: width,
      height: height ??
          context.responsiveValue<double>(mobile: 48, tablet: 54, desktop: 56),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBgColor,
          disabledBackgroundColor: effectiveDisabledBgColor,
          foregroundColor: effectiveFgColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: elevation,
        ),
        child: isLoading
            ? SizedBox(
                width: progressIndicatorSize,
                height: progressIndicatorSize,
                child: CircularProgressIndicator(
                  strokeWidth: strokeWidth,
                  color: progressIndicatorColor,
                ),
              )
            : (icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      icon!,
                      const SizedBox(width: AppSize.s8),
                      Text(
                        label,
                        style: textStyle ?? defaultTextStyle,
                      ),
                    ],
                  )
                : Text(
                    label,
                    style: textStyle ?? defaultTextStyle,
                  )),
      ),
    );
  }
}
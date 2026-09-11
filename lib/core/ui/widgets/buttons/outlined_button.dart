// import 'package:speed_service/app/shared/common/common_libs.dart';
// import 'package:speed_service/presentation/common/enums/button_type_enum.dart';
// import 'package:speed_service/presentation/widgets/buttons/buttons_methods.dart';
//
// class AppOutlinedButton extends StatelessWidget {
//   const AppOutlinedButton(
//       {super.key,
//       this.text = '',
//       required this.onPressed,
//       this.width,
//       this.height,
//       this.fontSize,
//       this.buttonType = ButtonContentType.text,
//       this.svgIconPath,
//       this.backgroundColor,
//       this.fontColor,
//       this.borderColor,
//       this.radius});
//
//   final String text;
//   final void Function() onPressed;
//   final double? width;
//   final double? height;
//   final double? fontSize;
//   final double? radius;
//   final ButtonContentType buttonType;
//   final String? svgIconPath;
//   final Color? backgroundColor;
//   final Color? fontColor;
//   final Color? borderColor;
//
//   @override
//   Widget build(BuildContext context) {
//     return OutlinedButton(
//       style: ButtonStyle(
//         side: WidgetStatePropertyAll(BorderSide(
//           color: borderColor ?? Theme.of(context).colorScheme.onPrimary,
//         )),
//         padding: const WidgetStatePropertyAll(EdgeInsets.zero),
//         foregroundColor: WidgetStatePropertyAll(
//           fontColor ?? Theme.of(context).colorScheme.onPrimary,
//         ),
//         fixedSize: WidgetStatePropertyAll(
//           Size(
//             width ?? double.infinity,
//             height ?? AppSize.s48,
//           ),
//         ),
//         minimumSize: WidgetStatePropertyAll(
//           Size(AppSize.s10.w, AppSize.s10.w),
//         ),
//         maximumSize: WidgetStatePropertyAll(
//           Size(AppSize.s400.w, AppSize.s100.h),
//         ),
//         shape: WidgetStatePropertyAll(
//           RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(radius ?? AppSize.s12.r),
//           ),
//         ),
//       ),
//       onPressed: onPressed,
//       child: buildButtonChild(
//         context: context,
//         buttonType: buttonType,
//         text: text,
//         svgIconPath: svgIconPath,
//         fontColor: fontColor ?? Theme.of(context).colorScheme.onPrimary,
//         iconColor: fontColor ?? Theme.of(context).colorScheme.onPrimary,
//         fontSize: fontSize,
//       ),
//     );
//   }
// }

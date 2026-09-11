// import 'package:flutter/material.dart';
//
// class AppTextButton extends StatelessWidget {
//   final String text;
//   final double? padding;
//   final void Function()? onPressed;
//   final double? fontSize;
//
//   const AppTextButton(
//       {super.key,
//       required this.text,
//       this.padding,
//       this.onPressed,
//       this.fontSize});
//
//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//         onPressed: onPressed,
//         child: Padding(
//           padding: EdgeInsets.all(padding ?? 8.0),
//           child: Text(
//             text,
//             style: get500MediumStyle(
//                     color: ColorsManager.bluePrimary,
//                     fontSize: fontSize ??
//                         (isTablet(context)
//                             ? AppSize.s10.sp
//                             : AppSize.s14.spMin))
//                 .copyWith(decoration: TextDecoration.underline),
//           ),
//         ));
//   }
// }

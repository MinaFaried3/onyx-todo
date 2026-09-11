// import 'package:speed_service/app/shared/common/common_libs.dart';
// import 'package:speed_service/presentation/widgets/animation/lottie_animation/success_indicators.dart';
//
// class CustomDialog extends StatelessWidget {
//   final String? svgPath;
//   final String? title;
//   final String message;
//   final Function()? onConfirm;
//   final String? buttonTxt;
//
//   const CustomDialog({
//     super.key,
//     this.svgPath,
//     required this.message,
//     this.title,
//     this.onConfirm,
//     this.buttonTxt,
//   });
//
//   factory CustomDialog.success({
//     required String message,
//     String? title,
//     Function()? onConfirm,
//     String? buttonTxt,
//   }) =>
//       CustomDialog(
//         message: message,
//         title: title,
//         buttonTxt: buttonTxt,
//         onConfirm: onConfirm,
//       );
//
//   factory CustomDialog.icon({
//     required String svgPath,
//     required String message,
//     String? title,
//     Function()? onConfirm,
//     String? buttonTxt,
//   }) =>
//       CustomDialog(
//         svgPath: svgPath,
//         message: message,
//         title: title,
//         buttonTxt: buttonTxt,
//         onConfirm: onConfirm,
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(AppSize.s20.r),
//       ),
//       child: Stack(
//         alignment: AlignmentDirectional.topEnd,
//         children: [
//           Container(
//             width: AppSize.s1.sw * AppSize.s0_8,
//             padding: EdgeInsets.symmetric(
//                 vertical: AppSize.s24.h, horizontal: AppSize.s24.w),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(AppSize.s20.r),
//               color: ColorsManager.white,
//             ),
//             child: Column(
//               mainAxisSize: .min,
//               children: [
//                 // Placeholder for your SVG/Image
//                 if (svgPath != null)
//                   SvgPicture.asset(
//                     svgPath!,
//                     height: AppSize.s140.h,
//                     width: AppSize.s120.w,
//                     fit: .cover,
//                   )
//                 else
//                   SuccessIndicator(),
//
//                 SizedBox(height: AppSize.s32.h),
//                 // Title text
//                 if (title != null) ...[
//                   Text(
//                     title!,
//                     softWrap: true,
//                     textAlign: .center,
//                     style: get500MediumStyle(),
//                   ),
//                   SizedBox(height: AppSize.s12.h),
//                 ],
//
//                 // message text
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     message,
//                     textAlign: .center,
//                     style: get500MediumStyle(),
//                   ),
//                 ),
//                 SizedBox(height: AppSize.s24.h),
//                 // Optional action button
//                 if (buttonTxt != null)
//                   AppButton(text: buttonTxt!, onPressed: onConfirm),
//               ],
//             ),
//           ),
//           IconButton(
//               onPressed: () {
//                 context.pop();
//               },
//               icon: Icon(
//                 Icons.highlight_remove_outlined,
//                 color: ColorsManager.lightGreyTextSecondary,
//               )),
//         ],
//       ),
//     );
//   }
// }

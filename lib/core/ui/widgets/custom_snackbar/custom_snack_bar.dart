// import 'package:speed_service/app/shared/common/common_libs.dart';
//
// class CustomSnackBar {
//   static void show(BuildContext context, String message,
//       {SnackBarEnum snackEnum = SnackBarEnum.error}) {
//     final snackBar = SnackBar(
//       dismissDirection: DismissDirection.down,
//       content: Row(
//         mainAxisSize: .min,
//         children: [
//           Expanded(
//             flex: 0,
//             child: Container(
//               height: AppSize.s48,
//               width: AppSize.s3,
//               decoration: BoxDecoration(
//                   color: snackEnum.color,
//                   borderRadius: BorderRadius.horizontal(
//                       right: Radius.circular(AppSize.s8))),
//             ),
//           ),
//           const SizedBox(width: AppSize.s14),
//           AppElevation(
//             elevation: AppSize.s16,
//             child: Container(
//               padding: const EdgeInsets.all(AppSize.s8),
//               decoration: BoxDecoration(
//                 color: ColorsManager.whiteBgColor,
//                 borderRadius: BorderRadius.circular(AppSize.s8.r),
//               ),
//               child: SvgPicture.asset(
//                 snackEnum.svgAsset,
//                 height: AppSize.s30,
//                 fit: .fitHeight,
//                 colorFilter: ColorFilter.mode(
//                   snackEnum.color,
//                   BlendMode.srcIn,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: AppSize.s10),
//           Expanded(
//             child: Text(
//               message,
//               style: get500MediumStyle(),
//             ),
//           ),
//           Column(
//             crossAxisAlignment: .end,
//             mainAxisAlignment: .start,
//             children: [
//               IconButton(
//                 icon: const Icon(CupertinoIcons.xmark_circle,
//                     color: ColorsManager.greyTextColor),
//                 onPressed: () =>
//                     ScaffoldMessenger.of(context).hideCurrentSnackBar(),
//               ),
//             ],
//           ),
//           const SizedBox(width: AppSize.s4),
//         ],
//       ),
//       backgroundColor: ColorsManager.white,
//       elevation: AppSize.s12,
//       behavior: SnackBarBehavior.floating,
//       margin: const EdgeInsets.symmetric(
//           horizontal: AppSize.s20, vertical: AppSize.s12),
//       padding: EdgeInsets.symmetric(vertical: AppSize.s12),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(AppSize.s8.r),
//         side: const BorderSide(color: ColorsManager.redPrimaryBolderBg),
//       ),
//       duration: const Duration(seconds: 3),
//     );
//
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(snackBar);
//   }
// }
//
// enum SnackBarEnum {
//   success(Assets.iconsCheck, ColorsManager.greenBg),
//   error(Assets.iconsErrorNotify, ColorsManager.redPrimary),
//   info(Assets.iconsInfo, ColorsManager.yellowColor),
//   warning(Assets.iconsInfo, ColorsManager.orangeSecondary),
//   custom(Assets.iconsInfo, ColorsManager.yellowColor),
//   ;
//
//   final String svgAsset;
//   final Color color;
//
//   const SnackBarEnum(this.svgAsset, this.color);
// }

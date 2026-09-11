// import 'package:speed_service/app/shared/common/common_libs.dart';
//
// class CustomDatePickerBottomSheet extends StatelessWidget {
//   final Widget child;
//   final String? title;
//   final double? height;
//
//   const CustomDatePickerBottomSheet(
//       {super.key, this.title, required this.child, this.height});
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.sizeOf(context);
//     double sheetContentHeight = height ??
//         // (AppSize.s1.sh * AppSize.s0_65.h);
//         200 + AppSize.s140.h + AppSize.s75.h + AppSize.s1.h;
//     return SafeArea(
//       child: AnimatedPadding(
//         duration: const Duration(milliseconds: 120),
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: SizedBox(
//           height: sheetContentHeight + AppSize.s48.spMax,
//           child: Stack(
//             alignment: .bottomCenter,
//             children: [
//               // Bottom sheet container
//               Container(
//                 height: sheetContentHeight,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: AppSize.s24.w,
//                   vertical: AppSize.s16.h,
//                 ),
//                 decoration: BoxDecoration(
//                     color: ColorsManager.white,
//                     borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(AppSize.s28.r))),
//                 child: Column(
//                   crossAxisAlignment: .start,
//                   mainAxisAlignment: .center,
//                   children: [
//                     if (title != null)
//                       Text(title!,
//                           style:
//                               get600SemiBoldStyle(fontSize: FontSize.s16.sp)),
//                     child,
//                   ],
//                 ),
//               ),
//               // Floating close button
//               Positioned(
//                 top: 0, // Adjust this to position the icon above the sheet
//                 child: GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: CupertinoColors.transparent,
//                       shape: .circle,
//                       border: Border.all(color: ColorsManager.whiteRedBgColor),
//                     ),
//                     padding: EdgeInsets.all(6.sp),
//                     child: Icon(
//                       CupertinoIcons.clear,
//                       size: AppSize.s20.spMin,
//                       color: ColorsManager.whiteRedBgColor,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// void showCustomBottomSheet(BuildContext context,
//     {String? title, required Widget child, GlobalKey? key, double? height}) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     enableDrag: true,
//     backgroundColor: Colors.transparent,
//     isDismissible: false,
//     barrierColor: Colors.black45,
//     // barrierLabel: 'barrier',
//     elevation: AppSize.s20,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(AppSize.s24.r)),
//     ),
//     builder: (BuildContext builder) {
//       return CustomDatePickerBottomSheet(
//         title: title,
//         key: key,
//         height: height,
//         child: child,
//       );
//     },
//   );
// }

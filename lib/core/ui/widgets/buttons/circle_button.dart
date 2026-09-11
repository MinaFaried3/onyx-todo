// import 'package:speed_service/app/shared/common/common_libs.dart';
//
// class CircleButton extends StatelessWidget {
//   final IconData? icon;
//   final double size;
//   final VoidCallback onPressed;
//   final bool showRedDot;
//   final String? svgPath;
//
//   const CircleButton({
//     super.key,
//     this.icon,
//     required this.onPressed,
//     this.size = 36,
//     this.showRedDot = false,
//     this.svgPath,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     double size = isTablet(context) ? this.size.sp / 1.4 : this.size;
//     return Stack(
//       clipBehavior: .none,
//       children: [
//         AppElevation(
//           shape: CircleBorder(),
//           color: ColorsManager.white,
//           child: InkWell(
//             onTap: onPressed,
//             customBorder: CircleBorder(),
//             child: Container(
//               width: size,
//               height: size,
//               alignment: .center,
//               child: svgPath != null
//                   ? SvgPicture.asset(
//                       svgPath!,
//                       width: size * 0.65,
//                       fit: .cover,
//                       colorFilter: ColorFilter.mode(
//                           ColorsManager.darkTextColor, BlendMode.srcIn),
//                     )
//                   : Icon(
//                       icon,
//                       size: size * 0.65,
//                       color: ColorsManager.darkTextColor,
//                     ),
//             ),
//           ),
//         ),
//         if (showRedDot)
//           Positioned(
//             top: size / 5,
//             right: size / 4.5,
//             child: Container(
//               width: AppSize.s10,
//               height: AppSize.s10,
//               decoration: BoxDecoration(
//                 color: ColorsManager.redPrimary,
//                 shape: .circle,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

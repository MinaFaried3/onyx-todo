// class AppDialog extends StatelessWidget {
//   const AppDialog({super.key, required this.child, this.height});
//
//   final Widget child;
//   final double? height;
//
//   @override
//   Widget build(BuildContext context) {
//     final BorderRadius radius = BorderRadius.vertical(
//       bottom: Radius.circular(AppSize.s60.r),
//       top: Radius.circular(AppSize.s8.r),
//     );
//
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: radius,
//       ),
//       backgroundColor: ColorsManager.darkTealBackground1,
//       shadowColor: ColorsManager.tealPrimary,
//       elevation: AppSize.s48,
//       surfaceTintColor: ColorsManager.tealPrimary1000,
//       child: SizedBox(
//         // height: AppSize.s300.h,
//         child: Stack(
//           alignment: .topCenter,
//           clipBehavior: .none,
//           children: [_buildContent(radius, context), _buildLogoIcon()],
//         ),
//       ),
//     );
//   }
//
//   Container _buildContent(BorderRadius radius, BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(AppPadding.p8.sp),
//       decoration: BoxDecoration(
//           borderRadius: radius,
//           border: Border.fromBorderSide(
//             BorderSide(
//               width: AppSize.s1,
//               color: ColorsManager.offWhite600,
//               strokeAlign: AppSize.s16.sp,
//             ),
//           )),
//       child: SizedBox(
//           height: height ?? 230.h,
//           width: double.infinity,
//           child: Column(
//             crossAxisAlignment: .end,
//             children: [
//               _buildExitButton(context),
//               child,
//             ],
//           )),
//     );
//   }
//
//   Positioned _buildLogoIcon() {
//     return Positioned(
//         top: -AppSize.s48.h,
//         child: Image.asset(
//           AssetsProvider.logoIcon,
//           height: AppSize.s90.h,
//         ));
//   }
//
//   IconButton _buildExitButton(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         context.pop();
//       },
//       icon: SvgPicture.asset(
//         AssetsProvider.exitIcon,
//         colorFilter: const ColorFilter.mode(
//           ColorsManager.tealPrimary900,
//           BlendMode.srcIn,
//         ),
//         height: AppSize.s24.sp,
//       ),
//     );
//   }
// }

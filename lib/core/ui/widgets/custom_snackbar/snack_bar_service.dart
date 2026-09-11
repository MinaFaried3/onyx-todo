// import 'package:speed_service/app/shared/common/common_libs.dart';
// import 'package:speed_service/presentation/modules/main/cubit/bottom_nav_cubit.dart';
//
// class ServiceSnackBar {
//   static void show(BuildContext context, String message,
//       {bool fromMain = true}) {
//     final snackBar = SnackBar(
//       dismissDirection: DismissDirection.down,
//       content: BlocProvider.value(
//         value: context.read<BottomNavCubit>(),
//         child: Row(
//           mainAxisSize: .min,
//           children: [
//             SvgPicture.asset(
//               Assets.iconsKeysIcon,
//               height: AppSize.s20,
//               fit: .fitHeight,
//               colorFilter: ColorFilter.mode(
//                 ColorsManager.white,
//                 BlendMode.srcIn,
//               ),
//             ),
//             const SizedBox(width: AppSize.s10),
//             Expanded(
//               child: Text(
//                 message,
//                 style: get500MediumStyle(color: ColorsManager.white),
//               ),
//             ),
//             AppButton(
//               radius: AppSize.s8,
//               fitContent: true,
//               width: AppSize.s100,
//               height: FontSize.s35,
//               text: AppStrings.viewCart.tr(),
//               backgroundColor: ColorsManager.white,
//               fontColor: ColorsManager.bluePrimary,
//               fontSize: AppSize.s14,
//               onPressed: () {
//                 context.read<BottomNavCubit>().updateIndex(2);
//                 if (fromMain.isFalse) {
//                   context.pop();
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: ColorsManager.bluePrimary,
//       elevation: AppSize.s12,
//       behavior: SnackBarBehavior.floating,
//       margin: const EdgeInsets.symmetric(
//           horizontal: AppSize.s20, vertical: AppSize.s12),
//       padding: EdgeInsets.symmetric(
//         vertical: AppSize.s8,
//         horizontal: AppSize.s8,
//       ),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(AppSize.s16),
//         // side: const BorderSide(color: ColorsManager.redPrimaryBolderBg),
//       ),
//       duration: const Duration(seconds: 5),
//     );
//
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(snackBar);
//   }
// }

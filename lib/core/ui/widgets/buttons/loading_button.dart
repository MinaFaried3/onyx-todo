// import 'package:speed_service/app/shared/common/common_libs.dart';
// import 'package:speed_service/presentation/common/enums/button_type_enum.dart';
//
// class LoadingButton extends StatelessWidget {
//   const LoadingButton({
//     super.key,
//     this.text,
//     this.onPressed,
//     this.isLoading = false,
//     this.buttonStyle = AppButtonStyle.solidBackground,
//   });
//
//   factory LoadingButton.loading() => const LoadingButton(
//         isLoading: true,
//       );
//
//   final String? text;
//   final void Function()? onPressed;
//   final bool isLoading;
//   final AppButtonStyle buttonStyle;
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//       duration: const Duration(seconds: 1),
//       transitionBuilder: (child, animation) => SizeTransition(
//         sizeFactor: animation,
//         axis: Axis.horizontal,
//         child: child,
//       ),
//       child: isLoading
//           ? LoadingIndicator(
//               width: 150.w,
//             )
//           : _buildButton(),
//     );
//   }
//
//   Widget _buildButton() {
//     switch (buttonStyle) {
//       case AppButtonStyle.solidBackground:
//         return AppButton(
//           onPressed: onPressed ?? () {},
//           text: text ?? AppConstants.emptyString,
//         );
//       case AppButtonStyle.outlined:
//         return AppOutlinedButton(
//           onPressed: onPressed ?? () {},
//           text: text ?? AppConstants.emptyString,
//         );
//     }
//   }
// }

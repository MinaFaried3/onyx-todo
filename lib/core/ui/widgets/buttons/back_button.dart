// class AppBackButton extends StatelessWidget {
//   const AppBackButton({super.key, this.action});
//
//   final VoidCallback? action;
//
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         if (action != null) {
//           action!();
//         }
//         context.pop();
//       },
//       icon: const AppSvg(
//         path: AssetsProvider.arrowBackIcon,
//         fit: .scaleDown,
//       ),
//     );
//   }
// }

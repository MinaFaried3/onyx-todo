// import 'dart:io';
//
// import 'package:image_picker/image_picker.dart';
// import 'package:speed_service/app/shared/common/common_libs.dart';
//
// Future<File?> showImagePickerBottomSheet(BuildContext context) async {
//   final ImagePicker picker = ImagePicker();
//
//   return await showModalBottomSheet<File?>(
//     context: context,
//     builder: (BuildContext context) {
//       return Container(
//         padding: const EdgeInsets.all(16.0),
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera_alt_outlined),
//               title: Text(AppStrings.camera.tr()),
//               onTap: () async {
//                 final XFile? image =
//                     await picker.pickImage(source: ImageSource.camera);
//                 if (!context.mounted) return;
//
//                 if (image != null) {
//                   Navigator.pop(context, File(image.path)); // Return image file
//                 } else {
//                   Navigator.pop(context, null); // Return null if canceled
//                 }
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library_outlined),
//               title: Text(AppStrings.gallery.tr()),
//               onTap: () async {
//                 final XFile? image =
//                     await picker.pickImage(source: ImageSource.gallery);
//                 if (!context.mounted) return;
//                 if (image != null) {
//                   Navigator.pop(context, File(image.path)); // Return image file
//                 } else {
//                   Navigator.pop(context, null); // Return null if canceled
//                 }
//               },
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

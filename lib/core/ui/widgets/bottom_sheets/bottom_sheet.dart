// import 'dart:io';
//
// import 'package:speed_service/app/shared/common/common_libs.dart';
// import 'package:speed_service/data/responses/cars/car_model.dart';
// import 'package:speed_service/data/responses/location/location_model.dart';
// import 'package:speed_service/presentation/modules/location/add_location/bloc/maps_search_bloc.dart';
// import 'package:speed_service/presentation/modules/location/cubit/user_locations_cubit.dart';
// import 'package:speed_service/presentation/modules/location/my_location/widget/user_location_item.dart';
// import 'package:speed_service/presentation/modules/location/widget/location_form.dart';
// import 'package:speed_service/presentation/modules/main/widgets/add_car_bottom_sheet.dart';
//
// class CustomBottomSheet {
//   static void addCarBottomSheet(BuildContext context) {
//     var userCarPaginationCubit = context.read<PaginatedCubit<UserCarModel>>();
//     var carCubit = context.read<CarCubit>();
//     var carPaginationCubit = context.read<PaginatedCubit<CarModel>>();
//
//     showCustomBottomSheet(
//       context,
//       title: AppStrings.addYourCar.tr(),
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider<PaginatedCubit<UserCarModel>>.value(
//               value: userCarPaginationCubit),
//           BlocProvider<PaginatedCubit<CarModel>>.value(
//               value: carPaginationCubit),
//           BlocProvider<CarCubit>.value(value: carCubit),
//         ],
//         child: AddCarBottomSheet(),
//       ),
//     );
//   }
//
//   static void locationBottomSheet(BuildContext context,
//       {LocationModel? model}) {
//     var locationsCubit = context.read<PaginatedCubit<LocationModel>>();
//     var userLocationsCubit = context.read<UserLocationsCubit>();
//
//     showCustomBottomSheet(
//       context,
//       title: AppStrings.enterAddressDetails.tr(),
//       height: 500,
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider<PaginatedCubit<LocationModel>>.value(
//             value: locationsCubit,
//           ),
//           BlocProvider<UserLocationsCubit>.value(
//             value: userLocationsCubit,
//           ),
//           if (model == null)
//             BlocProvider<MapsSearchBloc>.value(
//               value: context.read<MapsSearchBloc>(),
//             ),
//         ],
//         child: LocationForm(
//           model: model,
//         ),
//       ),
//     );
//   }
//
//   static void showFileImage(BuildContext context, File image) async {
//     if (!context.mounted) return;
//     // showCustomBottomSheet(
//     //   context,
//     //   child: Image.file(image),
//     //   height: (await getImageDimensions(image)).height.toDouble(),
//     // );
//     showBottomSheet(
//         context: context,
//         builder: (context) {
//           return Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: ClipRRect(
//                 borderRadius: BorderRadius.circular(30),
//                 child: Image.file(image)),
//           );
//         });
//   }
//
//   static void setDefaultLocation(BuildContext context) async {
//     var locationsCubit =
//         BlocProvider.of<PaginatedCubit<LocationModel>>(context);
//
//     var cartCubit = BlocProvider.of<CartCubit>(context);
//
//     showCustomBottomSheet(
//       context,
//       title: AppStrings.setDefaultLocation.tr(),
//       height: 700,
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider<PaginatedCubit<LocationModel>>.value(
//             value: locationsCubit..fetchInitialData(),
//           ),
//           BlocProvider<CartCubit>.value(
//             value: cartCubit,
//           ),
//         ],
//         child: SizedBox(
//           height: 600,
//           child: PaginatedListView<LocationModel>(
//             separatorBuilder: (context, index) => Divider(),
//             itemBuilder: (context, location, index) => InkWell(
//               onTap: () {
//                 cartCubit.setDefaultLocation(location.id.fromNullToEmpty);
//                 context.pop();
//               },
//               child: UserLocationItem(
//                 model: location,
//                 showActions: false,
//               ),
//             ),
//             zeroItems: Center(child: Text(AppStrings.haveNotAnyLocation.tr())),
//           ),
//         ),
//       ),
//     );
//   }
// }

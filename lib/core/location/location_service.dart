

import 'package:onyx_todo/core/config/mode/app_mode.dart';
import 'package:onyx_todo/core/localization/core_strings.dart';
import 'package:onyx_todo/core/location/exception/permission_exception.dart';
import 'package:onyx_todo/core/location/exception/service_exception.dart';
import 'package:onyx_todo/core/location/location_permissions.dart';
import 'package:onyx_todo/core/maps/extension/mappers.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


final class LocationService extends Equatable {
  final Location location;
  final LocationPermissions permissions;

  const LocationService({required this.location, required this.permissions});

  void getRealTimeLocation({
    double? updatedLocationDistance,
    int? updatedLocationTime,
    required void Function(LocationData)? onLocationChangedListener,
  }) async {
    await permissions.executeAllPermissions();

    location.changeSettings(
      distanceFilter: updatedLocationDistance,
      interval: updatedLocationTime,
    );

    location.onLocationChanged.listen(onLocationChangedListener);
  }

  Future<LocationData> getLocation() async {
    await permissions.executeAllPermissions();

    final data = await location.getLocation();

    if (AppMode.prodReleaseMode && (data.isMock ?? false)) {
      throw MockedLocationException();
    }

    if (data.speed != null && data.speed! > 50) {
      throw UnrealisticSpeedException();
    }

    return data;
  }

  Future<LatLng> getLatLngLocation() async {
    final data = await getLocation();
    return data.toLatLng();
  }
  //todo refactoring
  Future<Either<Failure, LatLng>> executeService({
    Future<void> Function()? callBack,
    Function()? serviceNotEnabledCallBack,
    Function()? permissionDeniedForeverCallBack,
    Function()? permissionDeniedCallBack,
  }) async {
    try {
      if (callBack != null) {
        callBack();
      }

      final latLng = await getLatLngLocation();

      return Right(latLng);
    } on LocationServiceIsNotEnabledException {
      if (serviceNotEnabledCallBack != null) {
        serviceNotEnabledCallBack();
      }
      return Left(LocationFailure(message: CoreStrings.locationServiceIsDisabled));
    } on LocationPermissionDenied {
      if (permissionDeniedCallBack != null) {
        permissionDeniedCallBack();
      }
      return Left(LocationFailure(message: CoreStrings.locationPermissionIsDenied));
    } on LocationPermissionDeniedForever {
      if (permissionDeniedForeverCallBack != null) {
        permissionDeniedForeverCallBack();
      }
      return Left(LocationFailure(message: CoreStrings.locationPermissionIsDeniedForever));
    } on MockedLocationException {
      return Left(LocationFailure(message: 'Mocked location detected'));
    } on UnrealisticSpeedException {
      return Left(LocationFailure(message: 'Unrealistic speed detected'));
    } catch (e) {
      return Left(LocationFailure(message: CoreStrings.locationServiceIsDisabled));
    }
  }

  void dispose() {}

  @override
  List<Object> get props => [location, permissions];
}

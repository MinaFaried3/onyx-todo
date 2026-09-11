import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/location/exception/permission_exception.dart';
import 'package:onyx_todo/core/location/exception/service_exception.dart';

final class LocationPermissions extends Equatable {
  final Location location;

  const LocationPermissions({required this.location});

  //private method

  Future<void> _checkAndRequestLocationService() async {
    bool enabled = await location.serviceEnabled();

    if (!enabled) {
      throw LocationServiceIsNotEnabledException();
    }
  }

  Future<void> _checkAndRequestLocationPermission() async {
    PermissionStatus status = await location.hasPermission();

    if (status == PermissionStatus.deniedForever) {
      throw LocationPermissionDeniedForever();
    }

    if (status == PermissionStatus.denied) {
      status = await location.requestPermission();
      Printer.print('ask agin', color: ConsoleColor.cyan);
      if (status != PermissionStatus.granted) {
        throw LocationPermissionDenied();
      }
    }
  }

  //public methods
  Future<void> executeAllPermissions() async {
    await _checkAndRequestLocationService();
    await _checkAndRequestLocationPermission();
  }

  @override
  List<Object> get props => [location];
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onyx_todo/core/ui/color_manager.dart';

/// **MyLocationButton**
///
/// **When to use**:
/// Use this floating action button on map screens to allow drivers to quickly center the map on their current position.
///
/// **Why to use**:
/// - Simplifies camera manipulation.
/// - Matches standard Uber navigation flow.
/// - Highly customizable appearance (color, icon, sizing, placement).
class MyLocationButton extends StatelessWidget {
  /// The controller used to animate the map camera.
  final GoogleMapController? mapController;

  /// Latitude & Longitude of current location.
  final LatLng? currentLocation;

  /// Background color of the button.
  final Color backgroundColor;

  /// Icon color inside the button.
  final Color iconColor;

  /// Custom icon representation (default is `Icons.my_location`).
  final IconData icon;

  /// Target zoom level when centering (default is 16.0).
  final double zoomLevel;

  const MyLocationButton({
    super.key,
    required this.mapController,
    required this.currentLocation,
    this.backgroundColor = ColorsManager.white,
    this.iconColor = ColorsManager.darkTextColor,
    this.icon = Icons.my_location,
    this.zoomLevel = 16.0,
  });

  void _centerOnLocation() {
    if (mapController != null && currentLocation != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLocation!,
            zoom: zoomLevel,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'my_location_btn',
      mini: true,
      backgroundColor: backgroundColor,
      onPressed: currentLocation != null ? _centerOnLocation : null,
      child: Icon(
        icon,
        color: currentLocation != null ? iconColor : ColorsManager.greyTextSecondary,
      ),
    );
  }
}

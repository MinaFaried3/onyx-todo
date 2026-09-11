import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onyx_todo/core/maps/extension/mappers.dart';

/// **CustomGoogleMap**
///
/// **When to use**:
/// Use this widget whenever you need to display a map, particularly in ride-sharing (Uber-like) screens.
/// It wraps the standard [GoogleMap] package with common operations pre-configured.
///
/// **Why to use**:
/// - Reduces boilerplate for managing Map controllers.
/// - Automatically adjusts camera bounds to display route polylines whenever they are updated.
/// - Supports custom styling (JSON styles for light/dark modes).
/// - Centralizes markers, polylines, and camera controllers for smooth panning.
/// - High customizability via UI parameters (gestures, padding, controls).
class CustomGoogleMap extends StatefulWidget {
  /// Initial position of the camera (default is capitalLatLng from Constants if not supplied).
  final LatLng initialCameraPosition;

  /// Current location marker (e.g., driver location).
  final LatLng? currentLocation;

  /// Route points to draw polyline on the map.
  final List<LatLng> routePoints;

  /// Additional custom markers to display on the map.
  final Set<Marker> additionalMarkers;

  /// Additional custom polylines to display on the map.
  final Set<Polyline> additionalPolylines;

  /// Map styling JSON string (e.g., dark mode styles, custom grey retro styles).
  final String? mapStyleJson;

  /// Callback when map is created, passes the controller.
  final void Function(GoogleMapController controller)? onMapCreated;

  /// Callback when the camera starts moving or user interacts.
  final void Function()? onCameraMoveStarted;

  /// Callback when map is tapped.
  final void Function(LatLng latLng)? onTap;

  /// Padding applied to the map layout (e.g., to keep Google Logo visible above sheets).
  final EdgeInsets padding;

  /// Zoom level when centering on location (default is 16.0).
  final double defaultZoomLevel;

  /// Color of the main polyline route.
  final Color polylineColor;

  /// Width of the main polyline route.
  final int polylineWidth;

  /// Custom icon for current location marker.
  final BitmapDescriptor? currentLocationMarkerIcon;

  /// Custom icon for pickup/origin marker.
  final BitmapDescriptor? originMarkerIcon;

  /// Custom icon for destination marker.
  final BitmapDescriptor? destinationMarkerIcon;

  const CustomGoogleMap({
    super.key,
    required this.initialCameraPosition,
    this.currentLocation,
    this.routePoints = const [],
    this.additionalMarkers = const {},
    this.additionalPolylines = const {},
    this.mapStyleJson,
    this.onMapCreated,
    this.onCameraMoveStarted,
    this.onTap,
    this.padding = EdgeInsets.zero,
    this.defaultZoomLevel = 16.0,
    this.polylineColor = Colors.blue,
    this.polylineWidth = 5,
    this.currentLocationMarkerIcon,
    this.originMarkerIcon,
    this.destinationMarkerIcon,
  });

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  GoogleMapController? _mapController;

  @override
  void didUpdateWidget(covariant CustomGoogleMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Smoothly pan camera to current location if it changed and no route is active
    if (widget.currentLocation != null &&
        widget.currentLocation != oldWidget.currentLocation &&
        widget.routePoints.isEmpty) {
      _animateToLocation(widget.currentLocation!, zoom: widget.defaultZoomLevel);
    }

    // Automatically fit route bounds if route points are updated
    if (widget.routePoints.isNotEmpty && widget.routePoints != oldWidget.routePoints) {
      _fitRouteBounds(widget.routePoints);
    }
  }

  void _animateToLocation(LatLng position, {double? zoom}) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: zoom ?? widget.defaultZoomLevel,
        ),
      ),
    );
  }

  void _fitRouteBounds(List<LatLng> points) {
    if (_mapController == null || points.isEmpty) return;

    final bounds = points.getPointsBounds();
    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 70.0), // Padding inside map view in pixels
    );
  }

  @override
  Widget build(BuildContext context) {
    final Set<Marker> allMarkers = {};
    final Set<Polyline> allPolylines = {};

    // 1. Setup Current Location Marker (driver location)
    if (widget.currentLocation != null) {
      allMarkers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: widget.currentLocation!,
          icon: widget.currentLocationMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: 'My Location'),
        ),
      );
    }

    // 2. Setup Origin & Destination markers if route is active
    if (widget.routePoints.isNotEmpty) {
      final origin = widget.routePoints.first;
      final destination = widget.routePoints.last;

      allMarkers.addAll([
        Marker(
          markerId: const MarkerId('route_origin'),
          position: origin,
          icon: widget.originMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Pickup Location'),
        ),
        Marker(
          markerId: const MarkerId('route_destination'),
          position: destination,
          icon: widget.destinationMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Destination'),
        ),
      ]);

      // Draw route Polyline
      allPolylines.add(
        Polyline(
          polylineId: const PolylineId('route_path'),
          points: widget.routePoints,
          color: widget.polylineColor,
          width: widget.polylineWidth,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      );
    }

    // Add extra user-defined markers and polylines
    allMarkers.addAll(widget.additionalMarkers);
    allPolylines.addAll(widget.additionalPolylines);

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.currentLocation ?? widget.initialCameraPosition,
        zoom: widget.defaultZoomLevel,
      ),
      markers: allMarkers,
      polylines: allPolylines,
      onMapCreated: (controller) {
        _mapController = controller;
        if (widget.mapStyleJson != null) {
          _mapController!.setMapStyle(widget.mapStyleJson);
        }
        if (widget.routePoints.isNotEmpty) {
          _fitRouteBounds(widget.routePoints);
        }
        if (widget.onMapCreated != null) {
          widget.onMapCreated!(controller);
        }
      },
      onCameraMoveStarted: widget.onCameraMoveStarted,
      onTap: widget.onTap,
      padding: widget.padding,
      myLocationEnabled: false, // Managed manually via custom location markers
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

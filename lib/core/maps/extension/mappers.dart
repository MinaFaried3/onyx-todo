import 'dart:math';

// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

extension LocationDataMappers on LocationData {
  LatLng toLatLng() => LatLng(latitude ?? 0, longitude ?? 0);
}

// extension PointLatLngMappers on PointLatLng {
//   LatLng toLatLng() => LatLng(latitude ?? 0, longitude ?? 0);
// }

// extension ListPointLatLngMappers on List<PointLatLng> {
//   List<LatLng> toLatLngList() => map((e) => e.toLatLng()).toList();
// }

extension ListLatLngMappers on List<LatLng> {
  LatLngBounds getPointsBounds() {
    var southWestLatitude = first.latitude;
    var southWestLongitude = first.longitude;
    var northEastLatitude = first.latitude;
    var northEastLongitude = first.longitude;

    for (var point in this) {
      southWestLatitude = min(southWestLatitude, point.latitude);
      southWestLongitude = min(southWestLongitude, point.longitude);
      northEastLatitude = max(northEastLatitude, point.latitude);
      northEastLongitude = max(northEastLongitude, point.longitude);
    }

    return LatLngBounds(
        southwest: LatLng(southWestLatitude, southWestLongitude),
        northeast: LatLng(northEastLatitude, northEastLongitude));
  }
}

LatLng getLatLngFromString(String lat, String lng) {
  double latitude = double.tryParse(lat) ?? 0;
  double longitude = double.tryParse(lng) ?? 0;

  return LatLng(latitude, longitude);
}

extension LatLngExtention on LatLng {
  String get asString {
    return '$latitude,$longitude';
  }
}

/// Lazily decodes a Google Maps encoded polyline string into an [Iterable] of [LatLng] coordinates.
///
/// Uses the Dart Generator Pattern (`sync*` / `yield`) to avoid allocating large intermediate
/// collections and allow early termination or streaming consumption.
Iterable<LatLng> decodePolylineLazy(String encoded) sync* {
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    yield LatLng(lat / 1E5, lng / 1E5);
  }
}

/// Decodes a Google Maps encoded polyline string into a list of [LatLng] coordinates.
List<LatLng> decodePolyline(String encoded) => decodePolylineLazy(encoded).toList();


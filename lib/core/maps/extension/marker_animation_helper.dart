import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// **MarkerAnimationHelper**
///
/// **When to use**:
/// Use this helper utility to smoothly animate driver vehicle markers on rider or driver maps
/// between 3–5 second GPS location stream updates (dead reckoning / map interpolation).
///
/// **Why to use**:
/// - Prevents driver car markers from "teleporting" across the map on periodic location updates.
/// - Calculates shortest-path spherical heading/bearing rotation (0° to 360°).
abstract class MarkerAnimationHelper {
  /// Linearly interpolates between two [LatLng] coordinates by factor [t] (0.0 to 1.0).
  static LatLng interpolateLatLng(LatLng from, LatLng to, double t) {
    final clampedT = t.clamp(0.0, 1.0);
    final lat = from.latitude + (to.latitude - from.latitude) * clampedT;
    final lng = from.longitude + (to.longitude - from.longitude) * clampedT;
    return LatLng(lat, lng);
  }

  /// Linearly interpolates spherical heading/rotation angle in degrees (0.0 to 360.0).
  ///
  /// Takes shortest directional rotation route (e.g., 350° to 10° turns +20° clockwise).
  static double interpolateHeading(double fromHeading, double toHeading, double t) {
    final clampedT = t.clamp(0.0, 1.0);
    double delta = (toHeading - fromHeading) % 360.0;
    if (delta > 180.0) {
      delta -= 360.0;
    } else if (delta < -180.0) {
      delta += 360.0;
    }
    final result = (fromHeading + delta * clampedT) % 360.0;
    return result < 0 ? result + 360.0 : result;
  }

  /// Computes initial bearing / heading angle in degrees from [from] coordinate to [to] coordinate.
  static double computeHeading(LatLng from, LatLng to) {
    final fromLat = _toRadians(from.latitude);
    final fromLng = _toRadians(from.longitude);
    final toLat = _toRadians(to.latitude);
    final toLng = _toRadians(to.longitude);

    final dLng = toLng - fromLng;
    final y = math.sin(dLng) * math.cos(toLat);
    final x = math.cos(fromLat) * math.sin(toLat) -
        math.sin(fromLat) * math.cos(toLat) * math.cos(dLng);

    final headingRad = math.atan2(y, x);
    final headingDeg = (_toDegrees(headingRad) + 360.0) % 360.0;
    return headingDeg;
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180.0;
  static double _toDegrees(double radians) => radians * 180.0 / math.pi;
}

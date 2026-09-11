---
name: manage-location-permission
description: Guides the agent in using LocationService to request GPS permissions, start background location streams, detect mock location spoofing, filter unrealistic speed spikes, and handle permission denials.
---

# Manage Location Services and Permissions

Use this skill when implementing driver location tracking, updating live location coordinates on a server, listening to real-time driver movement, or checking if device GPS permissions are active.

## When to use this skill
- When starting or stopping driver trip tracks.
- When validating driver presence inside order locations.
- When resolving security checks on spoofed coordinates (fake GPS).

---

## Capabilities & Constraints

The `LocationService` class encapsulates hardware state queries and permission prompts. It enforces the following security checks:
1. **Mock GPS Detection**: In production mode (`AppMode.prodReleaseMode`), fetching location coordinates flagged by the OS as simulated (`data.isMock == true`) will throw a `MockedLocationException`.
2. **Speed Filtering**: Spikes in GPS speeds higher than 50 m/s (approx 180 km/h) are flagged as noise, throwing an `UnrealisticSpeedException`.
3. **Hardware & Settings**: Ensures GPS service is toggled ON before requesting location.

---

## Instructions

### 1. Simple Coordinate Query (`executeService`)
Use `executeService` to fetch the driver's current `LatLng` while handling permissions and service states automatically:

```dart
import 'package:Onyx_driver/core/injection/dependency_injection.dart';
import 'package:Onyx_driver/core/location/location_service.dart';

final locationService = getIt<LocationService>();

final result = await locationService.executeService(
  serviceNotEnabledCallBack: () {
    // Show dialog explaining GPS needs to be toggled ON
  },
  permissionDeniedCallBack: () {
    // Show snackbar explaining permission was rejected
  },
  permissionDeniedForeverCallBack: () {
    // Direct user to App Settings page
  },
);

result.fold(
  (failure) => print('Location query failed: ${failure.message}'),
  (latLng) => print('Success: ${latLng.latitude}, ${latLng.longitude}'),
);
```

### 2. Streaming Real-Time Location Updates
Use `getRealTimeLocation` to track movement updates. You can pass interval (time) and distance filters to optimize battery performance:

```dart
locationService.getRealTimeLocation(
  updatedLocationDistance: 5.0, // Emit only if distance changed by 5 meters
  updatedLocationTime: 3000,    // Throttle checks to every 3 seconds
  onLocationChangedListener: (LocationData data) {
    final lat = data.latitude;
    final lng = data.longitude;
    // Push update to Cubit or stream to API
  },
);
```

---

## Exception Types to Handle

If calling `getLocation()` or `getLatLngLocation()` directly instead of through `executeService`, you must wrap your calls in a try-catch for these specific exceptions:

| Exception | Cause |
|---|---|
| `LocationServiceIsNotEnabledException` | GPS is turned off in Android/iOS notification drawer. |
| `LocationPermissionDenied` | User rejected the app's location permission request. |
| `LocationPermissionDeniedForever` | User checked "never ask again" (Android) or "never" (iOS). |
| `MockedLocationException` | GPS spoofing detected in release mode. |
| `UnrealisticSpeedException` | Device speed exceeds 50 m/s. |

## References
- Location Service: [location_service.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/location/location_service.dart)
- Permissions Helper: [location_permissions.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/location/location_permissions.dart)

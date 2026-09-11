---
name: handle-maps-and-routing
description: Instructs the agent on integrating Google Maps: Place Autocomplete (new), Place Details (new), Route Computation, Route Matrix, Geocoding, and managing maps-specific API client configurations.
---

# Google Maps and Routing Integration

Use this skill when implementing map widgets, searching for locations/addresses, plotting paths/routes on a map, calculating ETAs, or resolving coordinates to street addresses.

## When to use this skill
- When building location pickers or address autocomplete text fields.
- When calculating route polylines or driving duration/distances between coordinates.
- When implementing driver navigation states (tracking trip start to trip destination).

---

## Architecture of core/maps

All maps-specific code is grouped under `lib/core/maps/`:
- **API Key Manager**: `maps_api_key.dart`
- **Dio/Retrofit client**: `network/maps_service_client.dart`
- **Models**: DTO requests and responses under `model/`
- **Mappers**: Extensions converting Google API models to domain types (`extension/mappers.dart`)
- **Repository**: `repository/maps_repository.dart`

---

## Instructions

### 1. Maps API Key & Network Setup
Google Maps requests are made using a **separate Dio client** (`InstanceName.mapsDio`) that:
- Embeds the Google Maps API key inside headers (e.g., `X-Goog-Api-Key` for new Google Places/Routes APIs).
- Resolves to `maps.googleapis.com` as the base URL.
- Does **not** include the application's bearer token interceptor.

### 2. Invoking the Repository from Cubits
Inject and use `MapsRepository` to perform maps operations:
```dart
import 'package:Onyx_driver/core/maps/repository/maps_repository.dart';
import 'package:Onyx_driver/core/maps/model/request/places_api_new/autocomplete_new_request.dart';

class LocationSearchCubit extends Cubit<LocationSearchState> {
  final MapsRepository _mapsRepo;

  LocationSearchCubit(this._mapsRepo) : super(const LocationSearchState());

  Future<void> search(String query) async {
    emit(state.copyWith(isLoading: true));
    
    final result = await _mapsRepo.autocompleteNew(
      request: AutocompleteNewRequest(input: query),
    );
    
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (response) => emit(state.copyWith(isLoading: false, suggestions: response.suggestions)),
    );
  }
}
```

### 3. Calculating Distance & Duration (Route Matrix)
Use `computeRouteMatrix` to efficiently fetch transit parameters for grid coordinate matrices:
```dart
final matrixResult = await _mapsRepo.computeRouteMatrix(
  request: ComputeRouteMatrixRequest(
    origins: [RouteMatrixWaypoint(location: WaypointLocation(latLng: driverLatLng))],
    destinations: [RouteMatrixWaypoint(location: WaypointLocation(latLng: customerLatLng))],
  ),
);
```

### 4. Polyline / Mapping Helpers
Convert the encoded polyline string from `ComputeRoutesResponse` using mappers:
- `response.routes.first.polyline.encodedPolyline` returns the string.
- Render it on the GoogleMap widget by decoding the points and adding to the `Polyline` dataset.

## References
- Google Maps Repository: [maps_repository.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/maps/repository/maps_repository.dart)
- Retrofit Map Client: [maps_service_client.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/maps/network/maps_service_client.dart)
- Model Mappers: [mappers.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/maps/extension/mappers.dart)

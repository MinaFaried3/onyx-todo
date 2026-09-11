import 'package:onyx_todo/core/controller/cubit/base_cubit.dart';
import 'package:onyx_todo/core/controller/cubit/sub_state.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/core/location/location_service.dart';
import 'package:onyx_todo/core/maps/controller/maps_state.dart';
import 'package:onyx_todo/core/maps/extension/mappers.dart';
import 'package:onyx_todo/core/maps/model/request/places_api_new/autocomplete_new_request.dart';
import 'package:onyx_todo/core/maps/model/request/routes_api_new/compute_routes_request.dart';
import 'package:onyx_todo/core/maps/model/response/places_api_new/autocomplete_new_response.dart';
import 'package:onyx_todo/core/maps/repository/maps_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' show LocationData;

class MapsCubit extends BaseCubit<MapsState> {
  final MapsRepository _mapsRepository;
  final LocationService _locationService;

  MapsCubit({required this._mapsRepository, required this._locationService})
    : super(const MapsState());

  /// Requests the user's current location once and updates the currentLocationState.
  Future<void> getCurrentLocation() async {
    emit(
      state.copyWith(
        currentLocationState: state.currentLocationState.copyWith(
          state: UiState.loading,
        ),
      ),
    );

    final result = await _locationService.executeService();

    handleResult(
      result,
      onFailure: (failure) => state.copyWith(
        currentLocationState: state.currentLocationState.copyWith(
          state: UiState.failed,
          failure: () => failure,
        ),
      ),
      onSuccess: (latLng) => state.copyWith(
        currentLocationState: state.currentLocationState.copyWith(
          state: UiState.succeed,
          data: latLng,
        ),
      ),
    );
  }

  /// Starts listening to real-time location changes. Updates currentLocationState on change.
  void startLocationUpdates({
    double? updatedLocationDistance =
        5.0, // 5 meters filter by default for smooth driver tracking
    int? updatedLocationTime = 5000, // 5 seconds intervals
  }) {
    _locationService.getRealTimeLocation(
      updatedLocationDistance: updatedLocationDistance,
      updatedLocationTime: updatedLocationTime,
      onLocationChangedListener: (LocationData locationData) {
        if (!isClosed) {
          emit(
            state.copyWith(
              currentLocationState: state.currentLocationState.copyWith(
                state: UiState.succeed,
                data: locationData.toLatLng(),
              ),
            ),
          );
        }
      },
    );
  }

  /// Fetch route between origin and destination coordinates, decode it, and emit points for drawing.
  Future<void> getRouteBetweenPoints({
    required LatLng origin,
    required LatLng destination,
  }) async {
    emit(
      state.copyWith(
        routeState: state.routeState.copyWith(state: UiState.loading),
      ),
    );

    final request = ComputeRoutesRequest(
      origin: Waypoint(
        location: LocationPoint(
          latLng: LatLngLiteral(
            latitude: origin.latitude,
            longitude: origin.longitude,
          ),
        ),
      ),
      destination: Waypoint(
        location: LocationPoint(
          latLng: LatLngLiteral(
            latitude: destination.latitude,
            longitude: destination.longitude,
          ),
        ),
      ),
      travelMode: 'DRIVE',
      routingPreference: 'TRAFFIC_AWARE',
    );

    final result = await _mapsRepository.computeRoutes(request: request);

    handleResult(
      result,
      onFailure: (failure) => state.copyWith(
        routeState: state.routeState.copyWith(
          state: UiState.failed,
          failure: () => failure,
        ),
      ),
      onSuccess: (response) {
        final routes = response.routes;
        if (routes != null && routes.isNotEmpty) {
          final firstRoute = routes.first;
          final encodedPolyline = firstRoute.polyline?.encodedPolyline;
          final decodedPoints = encodedPolyline != null
              ? decodePolyline(encodedPolyline)
              : <LatLng>[];

          // Format metrics
          final distanceKm = firstRoute.distanceMeters != null
              ? '${(firstRoute.distanceMeters! / 1000).toStringAsFixed(1)} km'
              : '';

          // Duration format (Google returns duration string like "120s" or "3500s")
          String durationText = '';
          if (firstRoute.duration != null) {
            final secondsString = firstRoute.duration!.replaceAll('s', '');
            final seconds = int.tryParse(secondsString) ?? 0;
            final minutes = (seconds / 60).round();
            durationText = '$minutes min';
          }

          return state.copyWith(
            routeState: state.routeState.copyWith(
              state: UiState.succeed,
              data: (decodedPoints, distanceKm, durationText),
            ),
          );
        } else {
          return state.copyWith(
            routeState: state.routeState.copyWith(state: UiState.failed),
          );
        }
      },
    );
  }

  /// Sets a canonical pre-encoded polyline pushed from the server (Golden Rule).
  ///
  /// Decodes the polyline and emits it without making additional Google API requests.
  void setCanonicalRoute(
    String encodedPolyline, {
    String? distanceText,
    String? durationText,
  }) {
    final decodedPoints = decodePolyline(encodedPolyline);
    emit(
      state.copyWith(
        routeState: state.routeState.copyWith(
          state: UiState.succeed,
          data: (decodedPoints, distanceText ?? '', durationText ?? ''),
        ),
      ),
    );
  }

  /// Request place predictions from Place Autocomplete API (New)
  Future<void> autocomplete(String query) async {
    if (query.trim().isEmpty) {
      emit(
        state.copyWith(
          autocompleteState: state.autocompleteState.copyWith(
            state: UiState.initial,
            data: const [],
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        autocompleteState: state.autocompleteState.copyWith(
          state: UiState.loading,
        ),
      ),
    );

    final request = AutocompleteNewRequest(input: query);
    final result = await _mapsRepository.autocompleteNew(request: request);

    handleResult(
      result,
      onFailure: (failure) => state.copyWith(
        autocompleteState: state.autocompleteState.copyWith(
          state: UiState.failed,
          failure: () => failure,
        ),
      ),
      onSuccess: (response) => state.copyWith(
        autocompleteState: state.autocompleteState.copyWith(
          state: UiState.succeed,
          data: response.suggestions ?? const [],
        ),
      ),
    );
  }

  /// Fetches place details (lat/lng and address) for a selected place prediction ID.
  Future<void> fetchPlaceDetails(String placeId, {String? sessionToken}) async {
    emit(
      state.copyWith(
        placeDetailsState: state.placeDetailsState.copyWith(
          state: UiState.loading,
        ),
      ),
    );

    final result = await _mapsRepository.placesDetailsNew(
      placeId: placeId,
      sessionToken: sessionToken,
    );

    handleResult(
      result,
      onFailure: (failure) => state.copyWith(
        placeDetailsState: state.placeDetailsState.copyWith(
          state: UiState.failed,
          failure: () => failure,
        ),
      ),
      onSuccess: (response) => state.copyWith(
        placeDetailsState: state.placeDetailsState.copyWith(
          state: UiState.succeed,
          data: response,
        ),
      ),
    );
  }

  /// Performs Reverse Geocoding on coordinates (lat, lng) to get formatted address.
  Future<void> reverseGeocode(double lat, double lng) async {
    emit(
      state.copyWith(
        reverseGeocodeState: state.reverseGeocodeState.copyWith(
          state: UiState.loading,
        ),
      ),
    );

    final result = await _mapsRepository.geocode(latLng: '$lat,$lng');

    handleResult(
      result,
      onFailure: (failure) => state.copyWith(
        reverseGeocodeState: state.reverseGeocodeState.copyWith(
          state: UiState.failed,
          failure: () => failure,
        ),
      ),
      onSuccess: (response) => state.copyWith(
        reverseGeocodeState: state.reverseGeocodeState.copyWith(
          state: UiState.succeed,
          data: response,
        ),
      ),
    );
  }

  /// Clean up route details from state
  void clearRoute() {
    emit(
      state.copyWith(
        routeState:
            const SubState<
              (List<LatLng> points, String distance, String duration)
            >(),
        autocompleteState: const SubState<List<Suggestion>>(),
        placeDetailsState: const SubState(),
        reverseGeocodeState: const SubState(),
      ),
    );
  }
}

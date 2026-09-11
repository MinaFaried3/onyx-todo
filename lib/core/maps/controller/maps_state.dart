import 'package:onyx_todo/core/controller/controller.dart';
import 'package:onyx_todo/core/onyx_todo.dart';
import 'package:onyx_todo/core/maps/model/response/geocoding/geocoding_response.dart';
import 'package:onyx_todo/core/maps/model/response/places_api_new/autocomplete_new_response.dart';
import 'package:onyx_todo/core/maps/model/response/places_api_new/places_details_new_response.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsState extends BaseState {
  final SubState<LatLng> currentLocationState;
  final SubState<(List<LatLng> points, String distance, String duration)>
  routeState;
  final SubState<List<Suggestion>> autocompleteState;
  final SubState<PlacesDetailsNewResponse> placeDetailsState;
  final SubState<GeocodingResponse> reverseGeocodeState;

  const MapsState({
    super.uiState,
    super.failure,
    this.currentLocationState = const SubState<LatLng>(),
    this.routeState =
        const SubState<
          (List<LatLng> points, String distance, String duration)
        >(),
    this.autocompleteState = const SubState<List<Suggestion>>(),
    this.placeDetailsState = const SubState<PlacesDetailsNewResponse>(),
    this.reverseGeocodeState = const SubState<GeocodingResponse>(),
  });

  @override
  MapsState copyWith({
    UiState? uiState,
    Failure? Function()? failure,
    StateProps? stateProps,
    SubState<LatLng>? currentLocationState,
    SubState<(List<LatLng> points, String distance, String duration)>?
    routeState,
    SubState<List<Suggestion>>? autocompleteState,
    SubState<PlacesDetailsNewResponse>? placeDetailsState,
    SubState<GeocodingResponse>? reverseGeocodeState,
  }) {
    return MapsState(
      uiState: uiState ?? this.uiState,
      failure: failure.copy,
      currentLocationState: currentLocationState ?? this.currentLocationState,
      routeState: routeState ?? this.routeState,
      autocompleteState: autocompleteState ?? this.autocompleteState,
      placeDetailsState: placeDetailsState ?? this.placeDetailsState,
      reverseGeocodeState: reverseGeocodeState ?? this.reverseGeocodeState,
    );
  }

  @override
  List<Object?> get props => [
    failure,
    uiState,
    currentLocationState,
    routeState,
    autocompleteState,
    placeDetailsState,
    reverseGeocodeState,
  ];
}

extension MapsStateListenBuildWhen on MapsState {
  // Current Location
  bool buildWhenCurrentLocation(MapsState previous) =>
      previous.currentLocationState != currentLocationState;

  bool listenWhenCurrentLocation(MapsState previous) =>
      previous.currentLocationState != currentLocationState;

  // Route State
  bool buildWhenRoute(MapsState previous) => previous.routeState != routeState;

  bool listenWhenRoute(MapsState previous) => previous.routeState != routeState;

  // Autocomplete State
  bool buildWhenAutocomplete(MapsState previous) =>
      previous.autocompleteState != autocompleteState;

  bool listenWhenAutocomplete(MapsState previous) =>
      previous.autocompleteState != autocompleteState;

  // Place Details State
  bool buildWhenPlaceDetails(MapsState previous) =>
      previous.placeDetailsState != placeDetailsState;

  bool listenWhenPlaceDetails(MapsState previous) =>
      previous.placeDetailsState != placeDetailsState;

  // Reverse Geocode State
  bool buildWhenReverseGeocode(MapsState previous) =>
      previous.reverseGeocodeState != reverseGeocodeState;

  bool listenWhenReverseGeocode(MapsState previous) =>
      previous.reverseGeocodeState != reverseGeocodeState;
}

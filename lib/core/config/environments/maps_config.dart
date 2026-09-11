/// Maps configuration — pass `null` to [CoreConfiguration.maps]
/// to disable Maps entirely (Maps Dio won't be registered).
///
/// ```dart
/// maps: MapsConfig
///   placesApiKey: Env.googlePlacesKey,
///   geocodingApiKey: Env.googleGeoKey,
/// ),
/// ```
class MapsConfig {
  //! Google Places API key — for Autocomplete and Place Details.
  final String placesApiKey;

  //! Google Geocoding API key — for reverse geocoding.
  final String geocodingApiKey;

  const MapsConfig({
    required this.placesApiKey,
    required this.geocodingApiKey,
  });
}

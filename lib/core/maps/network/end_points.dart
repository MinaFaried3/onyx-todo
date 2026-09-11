import 'package:onyx_todo/core/network/headers_manager.dart';

abstract class MapsEndPoint {
  static const String _googleMapsBaseUrl =
      'https://maps.googleapis.com/maps/api';
  static const String _placesApiNewBaseUrl =
      'https://places.googleapis.com/v1/places';
  static const String _routesApiNewBaseUrl = 'https://routes.googleapis.com/v1';

  // Places API (New)
  static const String autoCompleteNew  = '$_placesApiNewBaseUrl:autocomplete';
  static const String placesDetailsNew = '$_placesApiNewBaseUrl/{placeId}';

  // Geocoding
  static const String geocode = '$_googleMapsBaseUrl/geocode/json';

  // Routes API (New)
  static const String computeRoutes      = '$_routesApiNewBaseUrl:computeRoutes';
  static const String computeRouteMatrix = '$_routesApiNewBaseUrl:computeRouteMatrix';
}

/// Maps-specific headers — key يأتي من DioFactory عبر mapsApiKey
class MapsHeader {
  static const String mapsApiKeyHeader = 'X-Goog-Api-Key';
  static const String fieldMask        = 'X-Goog-FieldMask';

  static Map<String, String> mapsBaseHeaders(
    String lang,
    String mapsApiKeyValue,
  ) =>
      {
        HeadersManager.contentType:    HeadersManager.applicationJson,
        HeadersManager.acceptLanguage: lang,
        mapsApiKeyHeader:              mapsApiKeyValue,
      };
}

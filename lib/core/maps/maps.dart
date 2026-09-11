/// Maps domain barrel - Google Maps integration, Cubit, Repositories, Models & UI.
///
/// Import this file to access internal maps code:
/// ```dart
/// import 'package:onyx_todo/core/maps/maps.dart';
/// ```
library;

// ─── Controller & State ───────────────────────────────────────────────────────
export 'controller/maps_cubit.dart';
export 'controller/maps_state.dart';

// ─── Repository & Data Source ─────────────────────────────────────────────────
export 'data/remote_data_source/maps_remote_data_source.dart';
export 'repository/maps_repository.dart';

// ─── Extensions & Helpers ─────────────────────────────────────────────────────
export 'extension/mappers.dart';
export 'extension/marker_animation_helper.dart';

// ─── Models - Request & Response ──────────────────────────────────────────────
export 'model/request/places_api_new/autocomplete_new_request.dart';
export 'model/request/routes_api_new/compute_route_matrix_request.dart';
export 'model/request/routes_api_new/compute_routes_request.dart';
export 'model/response/geocoding/geocoding_response.dart';
export 'model/response/places_api_new/autocomplete_new_response.dart';
export 'model/response/places_api_new/places_details_new_response.dart'
    hide AddressComponent, Location, Viewport;
export 'model/response/routes_api_new/compute_route_matrix_response.dart';
export 'model/response/routes_api_new/compute_routes_response.dart';

// ─── Network & Constants ──────────────────────────────────────────────────────
export 'map_services.dart';
export 'maps_constant.dart';
export 'network/end_points.dart';
export 'network/maps_api_key.dart';
export 'network/maps_service_client.dart';

// ─── UI Widgets ───────────────────────────────────────────────────────────────
export 'ui/custom_google_map.dart';
export 'ui/my_location_button.dart';
export 'ui/place_autocomplete_search_field.dart';
export 'ui/route_summary_card.dart';

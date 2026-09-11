import 'package:onyx_todo/core/maps/model/request/places_api_new/autocomplete_new_request.dart';
import 'package:onyx_todo/core/maps/model/request/routes_api_new/compute_route_matrix_request.dart';
import 'package:onyx_todo/core/maps/model/request/routes_api_new/compute_routes_request.dart';
import 'package:onyx_todo/core/maps/model/response/geocoding/geocoding_response.dart';
import 'package:onyx_todo/core/maps/model/response/places_api_new/autocomplete_new_response.dart';
import 'package:onyx_todo/core/maps/model/response/places_api_new/places_details_new_response.dart';
import 'package:onyx_todo/core/maps/model/response/routes_api_new/compute_route_matrix_response.dart';
import 'package:onyx_todo/core/maps/model/response/routes_api_new/compute_routes_response.dart';
import 'package:onyx_todo/core/network/data_source/base_remote_data_source.dart';

abstract class MapsRemoteDataSource<T> extends BaseRemoteDataSource<T> {
  MapsRemoteDataSource({required super.apiService});

  Future<AutocompleteNewResponse> autocompleteNew({
    required AutocompleteNewRequest request,
  });

  Future<PlacesDetailsNewResponse> placesDetailsNew({
    required String placeId,
    String? sessionToken,
  });

  Future<GeocodingResponse> geocode({required String latLng});

  Future<ComputeRoutesResponse> computeRoutes({
    required ComputeRoutesRequest request,
  });

  Future<List<ComputeRouteMatrixResponse>> computeRouteMatrix({
    required ComputeRouteMatrixRequest request,
  });
}

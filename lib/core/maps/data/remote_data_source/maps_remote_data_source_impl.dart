import 'package:onyx_todo/core/maps/data/remote_data_source/maps_remote_data_source.dart';
import 'package:onyx_todo/core/maps/model/request/places_api_new/autocomplete_new_request.dart';
import 'package:onyx_todo/core/maps/model/request/routes_api_new/compute_route_matrix_request.dart';
import 'package:onyx_todo/core/maps/model/request/routes_api_new/compute_routes_request.dart';
import 'package:onyx_todo/core/maps/model/response/geocoding/geocoding_response.dart';
import 'package:onyx_todo/core/maps/model/response/places_api_new/autocomplete_new_response.dart';
import 'package:onyx_todo/core/maps/model/response/places_api_new/places_details_new_response.dart';
import 'package:onyx_todo/core/maps/model/response/routes_api_new/compute_route_matrix_response.dart';
import 'package:onyx_todo/core/maps/model/response/routes_api_new/compute_routes_response.dart';
import 'package:onyx_todo/core/maps/network/maps_service_client.dart';
import 'package:onyx_todo/core/maps/network/maps_api_key.dart';

final class MapsRemoteDataSourceImpl
    extends MapsRemoteDataSource<MapsServiceClient> {
  MapsRemoteDataSourceImpl({required super.apiService});

  @override
  Future<AutocompleteNewResponse> autocompleteNew({
    required AutocompleteNewRequest request,
  }) async {
    return await apiService.autocompleteNew(request: request);
  }

  @override
  Future<PlacesDetailsNewResponse> placesDetailsNew({
    required String placeId,
    String? sessionToken,
  }) async {
    return await apiService.placesDetailsNew(
      placeId: placeId,
      sessionToken: sessionToken,
    );
  }

  @override
  Future<GeocodingResponse> geocode({required String latLng}) async {
    return await apiService.geocode(
      latLng: latLng,
      key: MapsApiKey.geocodingApiKey,
    );
  }

  @override
  Future<ComputeRoutesResponse> computeRoutes({
    required ComputeRoutesRequest request,
  }) async {
    return await apiService.computeRoutes(request: request);
  }

  @override
  Future<List<ComputeRouteMatrixResponse>> computeRouteMatrix({
    required ComputeRouteMatrixRequest request,
  }) async {
    return await apiService.computeRouteMatrix(request: request);
  }
}

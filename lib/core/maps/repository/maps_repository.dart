import 'package:onyx_todo/core/helper/typedefs.dart';
import 'package:onyx_todo/core/maps/data/remote_data_source/maps_remote_data_source.dart';
import 'package:onyx_todo/core/maps/model/request/places_api_new/autocomplete_new_request.dart';
import 'package:onyx_todo/core/maps/model/request/routes_api_new/compute_route_matrix_request.dart';
import 'package:onyx_todo/core/maps/model/request/routes_api_new/compute_routes_request.dart';
import 'package:onyx_todo/core/maps/model/response/geocoding/geocoding_response.dart';
import 'package:onyx_todo/core/maps/model/response/places_api_new/autocomplete_new_response.dart';
import 'package:onyx_todo/core/maps/model/response/places_api_new/places_details_new_response.dart';
import 'package:onyx_todo/core/maps/model/response/routes_api_new/compute_route_matrix_response.dart';
import 'package:onyx_todo/core/maps/model/response/routes_api_new/compute_routes_response.dart';
import 'package:onyx_todo/core/network/data_source/local_data_source.dart';
import 'package:onyx_todo/core/network/network_checker.dart';
import 'package:onyx_todo/core/network/repositories/base_repository.dart';

class MapsRepository extends BaseRepository {
  final MapsRemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkChecker _networkChecker;

  const MapsRepository({
    required this._remoteDataSource,
    required this._localDataSource,
    required this._networkChecker,
  });

  @override
  NetworkChecker get networkChecker => _networkChecker;

  @override
  MapsRemoteDataSource get remoteDataSource => _remoteDataSource;

  @override
  LocalDataSource get localDataSource => _localDataSource;

  FailureOr<AutocompleteNewResponse> autocompleteNew(
      {required AutocompleteNewRequest request}) async {
    return executeMapsApiCall<AutocompleteNewResponse>(
        apiCall: () => remoteDataSource.autocompleteNew(request: request));
  }

  FailureOr<PlacesDetailsNewResponse> placesDetailsNew(
      {required String placeId, String? sessionToken}) async {
    return executeMapsApiCall<PlacesDetailsNewResponse>(
        apiCall: () => remoteDataSource.placesDetailsNew(
              placeId: placeId,
              sessionToken: sessionToken,
            ));
  }

  FailureOr<GeocodingResponse> geocode({required String latLng}) async {
    return executeMapsApiCall<GeocodingResponse>(
        apiCall: () => remoteDataSource.geocode(latLng: latLng));
  }

  FailureOr<ComputeRoutesResponse> computeRoutes(
      {required ComputeRoutesRequest request}) async {
    return executeMapsApiCall<ComputeRoutesResponse>(
        apiCall: () => remoteDataSource.computeRoutes(request: request));
  }

  FailureOr<List<ComputeRouteMatrixResponse>> computeRouteMatrix(
      {required ComputeRouteMatrixRequest request}) async {
    return executeMapsApiCall<List<ComputeRouteMatrixResponse>>(
        apiCall: () => remoteDataSource.computeRouteMatrix(request: request));
  }
}

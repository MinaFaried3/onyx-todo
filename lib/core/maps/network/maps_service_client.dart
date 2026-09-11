import 'package:dio/dio.dart' hide Headers;
import 'package:onyx_todo/core/maps/model/request/places_api_new/autocomplete_new_request.dart';
import 'package:onyx_todo/core/maps/model/request/routes_api_new/compute_route_matrix_request.dart';
import 'package:onyx_todo/core/maps/model/request/routes_api_new/compute_routes_request.dart';
import 'package:onyx_todo/core/maps/model/response/geocoding/geocoding_response.dart';
import 'package:onyx_todo/core/maps/model/response/places_api_new/autocomplete_new_response.dart';
import 'package:onyx_todo/core/maps/model/response/places_api_new/places_details_new_response.dart';
import 'package:onyx_todo/core/maps/model/response/routes_api_new/compute_route_matrix_response.dart';
import 'package:onyx_todo/core/maps/model/response/routes_api_new/compute_routes_response.dart';
import 'package:onyx_todo/core/maps/network/end_points.dart';
import 'package:retrofit/retrofit.dart';

part 'maps_service_client.g.dart';

@RestApi()
abstract class MapsServiceClient {
  factory MapsServiceClient(Dio dio, {String baseUrl}) = _MapsServiceClient;

  ////////////////////////////
  /////// places api (new)
  ///////////////////////////

  @POST(MapsEndPoint.autoCompleteNew)
  Future<AutocompleteNewResponse> autocompleteNew({
    @Body() required AutocompleteNewRequest request,
  });

  @GET(MapsEndPoint.placesDetailsNew)
  Future<PlacesDetailsNewResponse> placesDetailsNew({
    @Path("placeId") required String placeId,
    @Header(MapsHeader.fieldMask) String fieldMask = 'location,displayName',
    @Query("sessionToken") String? sessionToken,
  });

  ////////////////////////////
  /////// geocoding
  ///////////////////////////

  @GET(MapsEndPoint.geocode)
  Future<GeocodingResponse> geocode({
    @Query("key") required String key,
    @Query("latlng") String? latLng,
  });

  ////////////////////////////
  /////// routes api (new)
  ///////////////////////////

  @POST(MapsEndPoint.computeRoutes)
  Future<ComputeRoutesResponse> computeRoutes({
    @Body() required ComputeRoutesRequest request,
    @Header(MapsHeader.fieldMask) String fieldMask = 'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
  });

  @POST(MapsEndPoint.computeRouteMatrix)
  Future<List<ComputeRouteMatrixResponse>> computeRouteMatrix({
    @Body() required ComputeRouteMatrixRequest request,
    @Header(MapsHeader.fieldMask) String fieldMask = 'originIndex,destinationIndex,status,condition,distanceMeters,duration',
  });
}

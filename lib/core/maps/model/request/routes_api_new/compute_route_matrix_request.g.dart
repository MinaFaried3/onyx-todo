// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compute_route_matrix_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComputeRouteMatrixRequest _$ComputeRouteMatrixRequestFromJson(
  Map<String, dynamic> json,
) => ComputeRouteMatrixRequest(
  origins: (json['origins'] as List<dynamic>)
      .map((e) => RouteMatrixOrigin.fromJson(e as Map<String, dynamic>))
      .toList(),
  destinations: (json['destinations'] as List<dynamic>)
      .map((e) => RouteMatrixDestination.fromJson(e as Map<String, dynamic>))
      .toList(),
  travelMode: json['travelMode'] as String? ?? 'DRIVE',
  routingPreference: json['routingPreference'] as String? ?? 'TRAFFIC_AWARE',
  departureTime: json['departureTime'] as String?,
);

Map<String, dynamic> _$ComputeRouteMatrixRequestToJson(
  ComputeRouteMatrixRequest instance,
) => <String, dynamic>{
  'origins': instance.origins,
  'destinations': instance.destinations,
  'travelMode': instance.travelMode,
  'routingPreference': instance.routingPreference,
  'departureTime': instance.departureTime,
};

RouteMatrixOrigin _$RouteMatrixOriginFromJson(Map<String, dynamic> json) =>
    RouteMatrixOrigin(
      waypoint: Waypoint.fromJson(json['waypoint'] as Map<String, dynamic>),
      routeModifiers: json['routeModifiers'] == null
          ? null
          : RouteModifiers.fromJson(
              json['routeModifiers'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$RouteMatrixOriginToJson(RouteMatrixOrigin instance) =>
    <String, dynamic>{
      'waypoint': instance.waypoint,
      'routeModifiers': instance.routeModifiers,
    };

RouteMatrixDestination _$RouteMatrixDestinationFromJson(
  Map<String, dynamic> json,
) => RouteMatrixDestination(
  waypoint: Waypoint.fromJson(json['waypoint'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RouteMatrixDestinationToJson(
  RouteMatrixDestination instance,
) => <String, dynamic>{'waypoint': instance.waypoint};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compute_routes_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComputeRoutesRequest _$ComputeRoutesRequestFromJson(
  Map<String, dynamic> json,
) => ComputeRoutesRequest(
  origin: Waypoint.fromJson(json['origin'] as Map<String, dynamic>),
  destination: Waypoint.fromJson(json['destination'] as Map<String, dynamic>),
  intermediates: (json['intermediates'] as List<dynamic>?)
      ?.map((e) => Waypoint.fromJson(e as Map<String, dynamic>))
      .toList(),
  travelMode: json['travelMode'] as String? ?? 'DRIVE',
  routingPreference: json['routingPreference'] as String? ?? 'TRAFFIC_AWARE',
  departureTime: json['departureTime'] as String?,
  computeAlternativeRoutes: json['computeAlternativeRoutes'] as bool? ?? false,
  routeModifiers: json['routeModifiers'] == null
      ? null
      : RouteModifiers.fromJson(json['routeModifiers'] as Map<String, dynamic>),
  languageCode: json['languageCode'] as String?,
  units: json['units'] as String?,
);

Map<String, dynamic> _$ComputeRoutesRequestToJson(
  ComputeRoutesRequest instance,
) => <String, dynamic>{
  'origin': instance.origin,
  'destination': instance.destination,
  'intermediates': instance.intermediates,
  'travelMode': instance.travelMode,
  'routingPreference': instance.routingPreference,
  'departureTime': instance.departureTime,
  'computeAlternativeRoutes': instance.computeAlternativeRoutes,
  'routeModifiers': instance.routeModifiers,
  'languageCode': instance.languageCode,
  'units': instance.units,
};

Waypoint _$WaypointFromJson(Map<String, dynamic> json) => Waypoint(
  via: json['via'] as bool?,
  vehicleStopover: json['vehicleStopover'] as bool?,
  sideOfRoad: json['sideOfRoad'] as bool?,
  location: json['location'] == null
      ? null
      : LocationPoint.fromJson(json['location'] as Map<String, dynamic>),
  placeId: json['placeId'] as String?,
);

Map<String, dynamic> _$WaypointToJson(Waypoint instance) => <String, dynamic>{
  'via': instance.via,
  'vehicleStopover': instance.vehicleStopover,
  'sideOfRoad': instance.sideOfRoad,
  'location': instance.location,
  'placeId': instance.placeId,
};

LocationPoint _$LocationPointFromJson(Map<String, dynamic> json) =>
    LocationPoint(
      latLng: LatLngLiteral.fromJson(json['latLng'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LocationPointToJson(LocationPoint instance) =>
    <String, dynamic>{'latLng': instance.latLng};

LatLngLiteral _$LatLngLiteralFromJson(Map<String, dynamic> json) =>
    LatLngLiteral(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$LatLngLiteralToJson(LatLngLiteral instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

RouteModifiers _$RouteModifiersFromJson(Map<String, dynamic> json) =>
    RouteModifiers(
      avoidTolls: json['avoidTolls'] as bool?,
      avoidHighways: json['avoidHighways'] as bool?,
      avoidFerries: json['avoidFerries'] as bool?,
    );

Map<String, dynamic> _$RouteModifiersToJson(RouteModifiers instance) =>
    <String, dynamic>{
      'avoidTolls': instance.avoidTolls,
      'avoidHighways': instance.avoidHighways,
      'avoidFerries': instance.avoidFerries,
    };

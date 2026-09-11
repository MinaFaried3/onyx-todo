// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compute_routes_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComputeRoutesResponse _$ComputeRoutesResponseFromJson(
  Map<String, dynamic> json,
) => ComputeRoutesResponse(
  routes: (json['routes'] as List<dynamic>?)
      ?.map((e) => Route.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ComputeRoutesResponseToJson(
  ComputeRoutesResponse instance,
) => <String, dynamic>{'routes': instance.routes};

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
  distanceMeters: (json['distanceMeters'] as num?)?.toInt(),
  duration: json['duration'] as String?,
  polyline: json['polyline'] == null
      ? null
      : Polyline.fromJson(json['polyline'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
  'distanceMeters': instance.distanceMeters,
  'duration': instance.duration,
  'polyline': instance.polyline,
};

Polyline _$PolylineFromJson(Map<String, dynamic> json) =>
    Polyline(encodedPolyline: json['encodedPolyline'] as String?);

Map<String, dynamic> _$PolylineToJson(Polyline instance) => <String, dynamic>{
  'encodedPolyline': instance.encodedPolyline,
};

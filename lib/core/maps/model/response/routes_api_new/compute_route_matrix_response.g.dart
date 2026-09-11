// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compute_route_matrix_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComputeRouteMatrixResponse _$ComputeRouteMatrixResponseFromJson(
  Map<String, dynamic> json,
) => ComputeRouteMatrixResponse(
  originIndex: (json['originIndex'] as num?)?.toInt(),
  destinationIndex: (json['destinationIndex'] as num?)?.toInt(),
  status: json['status'] == null
      ? null
      : RouteStatus.fromJson(json['status'] as Map<String, dynamic>),
  distanceMeters: (json['distanceMeters'] as num?)?.toInt(),
  duration: json['duration'] as String?,
  condition: json['condition'] as String?,
);

Map<String, dynamic> _$ComputeRouteMatrixResponseToJson(
  ComputeRouteMatrixResponse instance,
) => <String, dynamic>{
  'originIndex': instance.originIndex,
  'destinationIndex': instance.destinationIndex,
  'status': instance.status,
  'distanceMeters': instance.distanceMeters,
  'duration': instance.duration,
  'condition': instance.condition,
};

RouteStatus _$RouteStatusFromJson(Map<String, dynamic> json) => RouteStatus(
  code: (json['code'] as num?)?.toInt(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$RouteStatusToJson(RouteStatus instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};

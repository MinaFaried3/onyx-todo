import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'compute_route_matrix_response.g.dart';

@JsonSerializable()
class ComputeRouteMatrixResponse extends Equatable {
  final int? originIndex;
  final int? destinationIndex;
  final RouteStatus? status;
  final int? distanceMeters;
  final String? duration;
  final String? condition;

  const ComputeRouteMatrixResponse({
    this.originIndex,
    this.destinationIndex,
    this.status,
    this.distanceMeters,
    this.duration,
    this.condition,
  });

  factory ComputeRouteMatrixResponse.fromJson(Map<String, dynamic> json) =>
      _$ComputeRouteMatrixResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ComputeRouteMatrixResponseToJson(this);

  @override
  List<Object?> get props => [originIndex, destinationIndex, status, distanceMeters, duration, condition];
}

@JsonSerializable()
class RouteStatus extends Equatable {
  final int? code;
  final String? message;

  const RouteStatus({this.code, this.message});

  factory RouteStatus.fromJson(Map<String, dynamic> json) =>
      _$RouteStatusFromJson(json);

  Map<String, dynamic> toJson() => _$RouteStatusToJson(this);

  @override
  List<Object?> get props => [code, message];
}

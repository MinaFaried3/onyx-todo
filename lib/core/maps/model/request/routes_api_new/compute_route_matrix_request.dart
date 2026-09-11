import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'compute_routes_request.dart';

part 'compute_route_matrix_request.g.dart';

@JsonSerializable()
class ComputeRouteMatrixRequest extends Equatable {
  final List<RouteMatrixOrigin> origins;
  final List<RouteMatrixDestination> destinations;
  final String? travelMode;
  final String? routingPreference;
  final String? departureTime;

  const ComputeRouteMatrixRequest({
    required this.origins,
    required this.destinations,
    this.travelMode = 'DRIVE',
    this.routingPreference = 'TRAFFIC_AWARE',
    this.departureTime,
  });

  factory ComputeRouteMatrixRequest.fromJson(Map<String, dynamic> json) =>
      _$ComputeRouteMatrixRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ComputeRouteMatrixRequestToJson(this);

  @override
  List<Object?> get props => [origins, destinations, travelMode, routingPreference, departureTime];
}

@JsonSerializable()
class RouteMatrixOrigin extends Equatable {
  final Waypoint waypoint;
  final RouteModifiers? routeModifiers;

  const RouteMatrixOrigin({required this.waypoint, this.routeModifiers});

  factory RouteMatrixOrigin.fromJson(Map<String, dynamic> json) =>
      _$RouteMatrixOriginFromJson(json);

  Map<String, dynamic> toJson() => _$RouteMatrixOriginToJson(this);

  @override
  List<Object?> get props => [waypoint, routeModifiers];
}

@JsonSerializable()
class RouteMatrixDestination extends Equatable {
  final Waypoint waypoint;

  const RouteMatrixDestination({required this.waypoint});

  factory RouteMatrixDestination.fromJson(Map<String, dynamic> json) =>
      _$RouteMatrixDestinationFromJson(json);

  Map<String, dynamic> toJson() => _$RouteMatrixDestinationToJson(this);

  @override
  List<Object?> get props => [waypoint];
}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'compute_routes_request.g.dart';

@JsonSerializable()
class ComputeRoutesRequest extends Equatable {
  final Waypoint origin;
  final Waypoint destination;
  final List<Waypoint>? intermediates;
  final String? travelMode;
  final String? routingPreference;
  final String? departureTime;
  final bool? computeAlternativeRoutes;
  final RouteModifiers? routeModifiers;
  final String? languageCode;
  final String? units;

  const ComputeRoutesRequest({
    required this.origin,
    required this.destination,
    this.intermediates,
    this.travelMode = 'DRIVE',
    this.routingPreference = 'TRAFFIC_AWARE',
    this.departureTime,
    this.computeAlternativeRoutes = false,
    this.routeModifiers,
    this.languageCode,
    this.units,
  });

  factory ComputeRoutesRequest.fromJson(Map<String, dynamic> json) =>
      _$ComputeRoutesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ComputeRoutesRequestToJson(this);

  @override
  List<Object?> get props => [
        origin,
        destination,
        intermediates,
        travelMode,
        routingPreference,
        departureTime,
        computeAlternativeRoutes,
        routeModifiers,
        languageCode,
        units,
      ];
}

@JsonSerializable()
class Waypoint extends Equatable {
  final bool? via;
  final bool? vehicleStopover;
  final bool? sideOfRoad;
  final LocationPoint? location;
  final String? placeId;

  const Waypoint({
    this.via,
    this.vehicleStopover,
    this.sideOfRoad,
    this.location,
    this.placeId,
  });

  factory Waypoint.fromJson(Map<String, dynamic> json) =>
      _$WaypointFromJson(json);

  Map<String, dynamic> toJson() => _$WaypointToJson(this);

  @override
  List<Object?> get props => [via, vehicleStopover, sideOfRoad, location, placeId];
}

@JsonSerializable()
class LocationPoint extends Equatable {
  final LatLngLiteral latLng;

  const LocationPoint({required this.latLng});

  factory LocationPoint.fromJson(Map<String, dynamic> json) =>
      _$LocationPointFromJson(json);

  Map<String, dynamic> toJson() => _$LocationPointToJson(this);

  @override
  List<Object?> get props => [latLng];
}

@JsonSerializable()
class LatLngLiteral extends Equatable {
  final double latitude;
  final double longitude;

  const LatLngLiteral({required this.latitude, required this.longitude});

  factory LatLngLiteral.fromJson(Map<String, dynamic> json) =>
      _$LatLngLiteralFromJson(json);

  Map<String, dynamic> toJson() => _$LatLngLiteralToJson(this);

  @override
  List<Object?> get props => [latitude, longitude];
}

@JsonSerializable()
class RouteModifiers extends Equatable {
  final bool? avoidTolls;
  final bool? avoidHighways;
  final bool? avoidFerries;

  const RouteModifiers({this.avoidTolls, this.avoidHighways, this.avoidFerries});

  factory RouteModifiers.fromJson(Map<String, dynamic> json) =>
      _$RouteModifiersFromJson(json);

  Map<String, dynamic> toJson() => _$RouteModifiersToJson(this);

  @override
  List<Object?> get props => [avoidTolls, avoidHighways, avoidFerries];
}

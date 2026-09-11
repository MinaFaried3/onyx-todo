import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'compute_routes_response.g.dart';

@JsonSerializable()
class ComputeRoutesResponse extends Equatable {
  final List<Route>? routes;

  const ComputeRoutesResponse({this.routes});

  factory ComputeRoutesResponse.fromJson(Map<String, dynamic> json) =>
      _$ComputeRoutesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ComputeRoutesResponseToJson(this);

  @override
  List<Object?> get props => [routes];
}

@JsonSerializable()
class Route extends Equatable {
  final int? distanceMeters;
  final String? duration;
  final Polyline? polyline;

  const Route({this.distanceMeters, this.duration, this.polyline});

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);

  Map<String, dynamic> toJson() => _$RouteToJson(this);

  @override
  List<Object?> get props => [distanceMeters, duration, polyline];
}

@JsonSerializable()
class Polyline extends Equatable {
  final String? encodedPolyline;

  const Polyline({this.encodedPolyline});

  factory Polyline.fromJson(Map<String, dynamic> json) =>
      _$PolylineFromJson(json);

  Map<String, dynamic> toJson() => _$PolylineToJson(this);

  @override
  List<Object?> get props => [encodedPolyline];
}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'autocomplete_new_request.g.dart';

@JsonSerializable()
class AutocompleteNewRequest extends Equatable {
  final String input;
  final LocationBias? locationBias;
  final LocationBias? locationRestriction;
  final List<String>? includedPrimaryTypes;
  final List<String>? includedRegionCodes;
  final String? languageCode;
  final String? regionCode;
  final AutoCompleteLatLng? origin;
  final int? inputOffset;
  final bool? includeQueryPredictions;
  final String? sessionToken;

  const AutocompleteNewRequest({
    required this.input,
    this.locationBias,
    this.locationRestriction,
    this.includedPrimaryTypes,
    this.includedRegionCodes,
    this.languageCode,
    this.regionCode,
    this.origin,
    this.inputOffset,
    this.includeQueryPredictions,
    this.sessionToken,
  });

  factory AutocompleteNewRequest.fromJson(Map<String, dynamic> json) =>
      _$AutocompleteNewRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AutocompleteNewRequestToJson(this);

  @override
  List<Object?> get props => [
        input,
        locationBias,
        locationRestriction,
        includedPrimaryTypes,
        includedRegionCodes,
        languageCode,
        regionCode,
        origin,
        inputOffset,
        includeQueryPredictions,
        sessionToken,
      ];
}

@JsonSerializable()
class LocationBias extends Equatable {
  final Circle? circle;
  final Rectangle? rectangle;

  const LocationBias({this.circle, this.rectangle});

  factory LocationBias.fromJson(Map<String, dynamic> json) =>
      _$LocationBiasFromJson(json);

  Map<String, dynamic> toJson() => _$LocationBiasToJson(this);

  @override
  List<Object?> get props => [circle, rectangle];
}

@JsonSerializable()
class Circle extends Equatable {
  final AutoCompleteLatLng center;
  final double radius;

  const Circle({required this.center, required this.radius});

  factory Circle.fromJson(Map<String, dynamic> json) => _$CircleFromJson(json);

  Map<String, dynamic> toJson() => _$CircleToJson(this);

  @override
  List<Object?> get props => [center, radius];
}

@JsonSerializable()
class Rectangle extends Equatable {
  final AutoCompleteLatLng low;
  final AutoCompleteLatLng high;

  const Rectangle({required this.low, required this.high});

  factory Rectangle.fromJson(Map<String, dynamic> json) =>
      _$RectangleFromJson(json);

  Map<String, dynamic> toJson() => _$RectangleToJson(this);

  @override
  List<Object?> get props => [low, high];
}

@JsonSerializable()
class AutoCompleteLatLng extends Equatable {
  final double latitude;
  final double longitude;

  const AutoCompleteLatLng({required this.latitude, required this.longitude});

  factory AutoCompleteLatLng.fromJson(Map<String, dynamic> json) =>
      _$AutoCompleteLatLngFromJson(json);

  Map<String, dynamic> toJson() => _$AutoCompleteLatLngToJson(this);

  @override
  List<Object?> get props => [latitude, longitude];
}

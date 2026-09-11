import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geocoding_response.g.dart';

@JsonSerializable()
class GeocodingResponse extends Equatable {
  @JsonKey(name: 'plus_code')
  final PlusCode? plusCode;

  @JsonKey(name: 'results')
  final List<Result>? results;

  @JsonKey(name: 'status')
  final String? status;

  const GeocodingResponse({
    this.plusCode,
    this.results,
    this.status,
  });

  factory GeocodingResponse.fromJson(Map<String, dynamic> json) =>
      _$GeocodingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GeocodingResponseToJson(this);

  @override
  List<Object?> get props => [plusCode, results, status];

  @override
  String toString() {
    return 'GeocodingResponse(plusCode: $plusCode, results: $results, status: $status)';
  }
}

@JsonSerializable()
class PlusCode extends Equatable {
  @JsonKey(name: 'compound_code')
  final String? compoundCode;

  @JsonKey(name: 'global_code')
  final String? globalCode;

  const PlusCode({
    this.compoundCode,
    this.globalCode,
  });

  factory PlusCode.fromJson(Map<String, dynamic> json) =>
      _$PlusCodeFromJson(json);

  Map<String, dynamic> toJson() => _$PlusCodeToJson(this);

  @override
  List<Object?> get props => [compoundCode, globalCode];

  @override
  String toString() {
    return 'PlusCode(compoundCode: $compoundCode, globalCode: $globalCode)';
  }
}

@JsonSerializable()
class Result extends Equatable {
  @JsonKey(name: 'address_components')
  final List<AddressComponent>? addressComponents;

  @JsonKey(name: 'formatted_address')
  final String? formattedAddress;

  @JsonKey(name: 'geometry')
  final Geometry? geometry;

  @JsonKey(name: 'place_id')
  final String? placeId;

  @JsonKey(name: 'types')
  final List<String>? types;

  const Result({
    this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.placeId,
    this.types,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);

  @override
  List<Object?> get props =>
      [addressComponents, formattedAddress, geometry, placeId, types];

  @override
  String toString() {
    return 'Result(addressComponents: $addressComponents, formattedAddress: $formattedAddress, geometry: $geometry, placeId: $placeId, types: $types)';
  }
}

@JsonSerializable()
class AddressComponent extends Equatable {
  @JsonKey(name: 'long_name')
  final String? longName;

  @JsonKey(name: 'short_name')
  final String? shortName;

  @JsonKey(name: 'types')
  final List<String>? types;

  const AddressComponent({
    this.longName,
    this.shortName,
    this.types,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      _$AddressComponentFromJson(json);

  Map<String, dynamic> toJson() => _$AddressComponentToJson(this);

  @override
  List<Object?> get props => [longName, shortName, types];

  @override
  String toString() {
    return 'AddressComponent(longName: $longName, shortName: $shortName, types: $types)';
  }
}

@JsonSerializable()
class Geometry extends Equatable {
  @JsonKey(name: 'location')
  final Location? location;

  @JsonKey(name: 'location_type')
  final String? locationType;

  @JsonKey(name: 'viewport')
  final Viewport? viewport;

  const Geometry({
    this.location,
    this.locationType,
    this.viewport,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);

  Map<String, dynamic> toJson() => _$GeometryToJson(this);

  @override
  List<Object?> get props => [location, locationType, viewport];

  @override
  String toString() {
    return 'Geometry(location: $location, locationType: $locationType, viewport: $viewport)';
  }
}

@JsonSerializable()
class Location extends Equatable {
  @JsonKey(name: 'lat')
  final double? lat;

  @JsonKey(name: 'lng')
  final double? lng;

  const Location({
    this.lat,
    this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  List<Object?> get props => [lat, lng];

  @override
  String toString() {
    return 'Location(lat: $lat, lng: $lng)';
  }
}

@JsonSerializable()
class Viewport extends Equatable {
  @JsonKey(name: 'northeast')
  final Location? northeast;

  @JsonKey(name: 'southwest')
  final Location? southwest;

  const Viewport({
    this.northeast,
    this.southwest,
  });

  factory Viewport.fromJson(Map<String, dynamic> json) =>
      _$ViewportFromJson(json);

  Map<String, dynamic> toJson() => _$ViewportToJson(this);

  @override
  List<Object?> get props => [northeast, southwest];

  @override
  String toString() {
    return 'Viewport(northeast: $northeast, southwest: $southwest)';
  }
}

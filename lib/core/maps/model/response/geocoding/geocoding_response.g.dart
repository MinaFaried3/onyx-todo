// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geocoding_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeocodingResponse _$GeocodingResponseFromJson(Map<String, dynamic> json) =>
    GeocodingResponse(
      plusCode: json['plus_code'] == null
          ? null
          : PlusCode.fromJson(json['plus_code'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Result.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$GeocodingResponseToJson(GeocodingResponse instance) =>
    <String, dynamic>{
      'plus_code': instance.plusCode,
      'results': instance.results,
      'status': instance.status,
    };

PlusCode _$PlusCodeFromJson(Map<String, dynamic> json) => PlusCode(
  compoundCode: json['compound_code'] as String?,
  globalCode: json['global_code'] as String?,
);

Map<String, dynamic> _$PlusCodeToJson(PlusCode instance) => <String, dynamic>{
  'compound_code': instance.compoundCode,
  'global_code': instance.globalCode,
};

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
  addressComponents: (json['address_components'] as List<dynamic>?)
      ?.map((e) => AddressComponent.fromJson(e as Map<String, dynamic>))
      .toList(),
  formattedAddress: json['formatted_address'] as String?,
  geometry: json['geometry'] == null
      ? null
      : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
  placeId: json['place_id'] as String?,
  types: (json['types'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
  'address_components': instance.addressComponents,
  'formatted_address': instance.formattedAddress,
  'geometry': instance.geometry,
  'place_id': instance.placeId,
  'types': instance.types,
};

AddressComponent _$AddressComponentFromJson(Map<String, dynamic> json) =>
    AddressComponent(
      longName: json['long_name'] as String?,
      shortName: json['short_name'] as String?,
      types: (json['types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AddressComponentToJson(AddressComponent instance) =>
    <String, dynamic>{
      'long_name': instance.longName,
      'short_name': instance.shortName,
      'types': instance.types,
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
  location: json['location'] == null
      ? null
      : Location.fromJson(json['location'] as Map<String, dynamic>),
  locationType: json['location_type'] as String?,
  viewport: json['viewport'] == null
      ? null
      : Viewport.fromJson(json['viewport'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
  'location': instance.location,
  'location_type': instance.locationType,
  'viewport': instance.viewport,
};

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'lat': instance.lat,
  'lng': instance.lng,
};

Viewport _$ViewportFromJson(Map<String, dynamic> json) => Viewport(
  northeast: json['northeast'] == null
      ? null
      : Location.fromJson(json['northeast'] as Map<String, dynamic>),
  southwest: json['southwest'] == null
      ? null
      : Location.fromJson(json['southwest'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ViewportToJson(Viewport instance) => <String, dynamic>{
  'northeast': instance.northeast,
  'southwest': instance.southwest,
};

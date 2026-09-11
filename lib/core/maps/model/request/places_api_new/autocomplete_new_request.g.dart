// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autocomplete_new_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutocompleteNewRequest _$AutocompleteNewRequestFromJson(
  Map<String, dynamic> json,
) => AutocompleteNewRequest(
  input: json['input'] as String,
  locationBias: json['locationBias'] == null
      ? null
      : LocationBias.fromJson(json['locationBias'] as Map<String, dynamic>),
  locationRestriction: json['locationRestriction'] == null
      ? null
      : LocationBias.fromJson(
          json['locationRestriction'] as Map<String, dynamic>,
        ),
  includedPrimaryTypes: (json['includedPrimaryTypes'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  includedRegionCodes: (json['includedRegionCodes'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  languageCode: json['languageCode'] as String?,
  regionCode: json['regionCode'] as String?,
  origin: json['origin'] == null
      ? null
      : AutoCompleteLatLng.fromJson(json['origin'] as Map<String, dynamic>),
  inputOffset: (json['inputOffset'] as num?)?.toInt(),
  includeQueryPredictions: json['includeQueryPredictions'] as bool?,
  sessionToken: json['sessionToken'] as String?,
);

Map<String, dynamic> _$AutocompleteNewRequestToJson(
  AutocompleteNewRequest instance,
) => <String, dynamic>{
  'input': instance.input,
  'locationBias': instance.locationBias,
  'locationRestriction': instance.locationRestriction,
  'includedPrimaryTypes': instance.includedPrimaryTypes,
  'includedRegionCodes': instance.includedRegionCodes,
  'languageCode': instance.languageCode,
  'regionCode': instance.regionCode,
  'origin': instance.origin,
  'inputOffset': instance.inputOffset,
  'includeQueryPredictions': instance.includeQueryPredictions,
  'sessionToken': instance.sessionToken,
};

LocationBias _$LocationBiasFromJson(Map<String, dynamic> json) => LocationBias(
  circle: json['circle'] == null
      ? null
      : Circle.fromJson(json['circle'] as Map<String, dynamic>),
  rectangle: json['rectangle'] == null
      ? null
      : Rectangle.fromJson(json['rectangle'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LocationBiasToJson(LocationBias instance) =>
    <String, dynamic>{
      'circle': instance.circle,
      'rectangle': instance.rectangle,
    };

Circle _$CircleFromJson(Map<String, dynamic> json) => Circle(
  center: AutoCompleteLatLng.fromJson(json['center'] as Map<String, dynamic>),
  radius: (json['radius'] as num).toDouble(),
);

Map<String, dynamic> _$CircleToJson(Circle instance) => <String, dynamic>{
  'center': instance.center,
  'radius': instance.radius,
};

Rectangle _$RectangleFromJson(Map<String, dynamic> json) => Rectangle(
  low: AutoCompleteLatLng.fromJson(json['low'] as Map<String, dynamic>),
  high: AutoCompleteLatLng.fromJson(json['high'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RectangleToJson(Rectangle instance) => <String, dynamic>{
  'low': instance.low,
  'high': instance.high,
};

AutoCompleteLatLng _$AutoCompleteLatLngFromJson(Map<String, dynamic> json) =>
    AutoCompleteLatLng(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$AutoCompleteLatLngToJson(AutoCompleteLatLng instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

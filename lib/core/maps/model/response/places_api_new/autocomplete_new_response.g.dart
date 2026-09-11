// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autocomplete_new_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutocompleteNewResponse _$AutocompleteNewResponseFromJson(
  Map<String, dynamic> json,
) => AutocompleteNewResponse(
  suggestions: (json['suggestions'] as List<dynamic>?)
      ?.map((e) => Suggestion.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AutocompleteNewResponseToJson(
  AutocompleteNewResponse instance,
) => <String, dynamic>{'suggestions': instance.suggestions};

Suggestion _$SuggestionFromJson(Map<String, dynamic> json) => Suggestion(
  placePrediction: PlacePrediction.fromJson(
    json['placePrediction'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$SuggestionToJson(Suggestion instance) =>
    <String, dynamic>{'placePrediction': instance.placePrediction};

PlacePrediction _$PlacePredictionFromJson(Map<String, dynamic> json) =>
    PlacePrediction(
      place: json['place'] as String,
      placeId: json['placeId'] as String,
      text: TextInfo.fromJson(json['text'] as Map<String, dynamic>),
      structuredFormat: StructuredFormat.fromJson(
        json['structuredFormat'] as Map<String, dynamic>,
      ),
      types: (json['types'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PlacePredictionToJson(PlacePrediction instance) =>
    <String, dynamic>{
      'place': instance.place,
      'placeId': instance.placeId,
      'text': instance.text,
      'structuredFormat': instance.structuredFormat,
      'types': instance.types,
    };

TextInfo _$TextInfoFromJson(Map<String, dynamic> json) => TextInfo(
  text: json['text'] as String?,
  matches: (json['matches'] as List<dynamic>?)
      ?.map(
        (e) =>
            e == null ? null : MatchOffset.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$TextInfoToJson(TextInfo instance) => <String, dynamic>{
  'text': instance.text,
  'matches': instance.matches,
};

StructuredFormat _$StructuredFormatFromJson(Map<String, dynamic> json) =>
    StructuredFormat(
      mainText: json['mainText'] == null
          ? null
          : MainText.fromJson(json['mainText'] as Map<String, dynamic>),
      secondaryText: json['secondaryText'] == null
          ? null
          : SecondaryText.fromJson(
              json['secondaryText'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$StructuredFormatToJson(StructuredFormat instance) =>
    <String, dynamic>{
      'mainText': instance.mainText,
      'secondaryText': instance.secondaryText,
    };

MainText _$MainTextFromJson(Map<String, dynamic> json) => MainText(
  text: json['text'] as String?,
  matches: (json['matches'] as List<dynamic>?)
      ?.map(
        (e) =>
            e == null ? null : MatchOffset.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$MainTextToJson(MainText instance) => <String, dynamic>{
  'text': instance.text,
  'matches': instance.matches,
};

SecondaryText _$SecondaryTextFromJson(Map<String, dynamic> json) =>
    SecondaryText(text: json['text'] as String?);

Map<String, dynamic> _$SecondaryTextToJson(SecondaryText instance) =>
    <String, dynamic>{'text': instance.text};

MatchOffset _$MatchOffsetFromJson(Map<String, dynamic> json) =>
    MatchOffset(endOffset: (json['endOffset'] as num?)?.toInt());

Map<String, dynamic> _$MatchOffsetToJson(MatchOffset instance) =>
    <String, dynamic>{'endOffset': instance.endOffset};

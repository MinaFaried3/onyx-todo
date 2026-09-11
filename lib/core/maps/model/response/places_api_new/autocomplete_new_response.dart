import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'autocomplete_new_response.g.dart';

@JsonSerializable()
class AutocompleteNewResponse extends Equatable {
  final List<Suggestion>? suggestions;

  const AutocompleteNewResponse({required this.suggestions});

  factory AutocompleteNewResponse.fromJson(Map<String, dynamic> json) =>
      _$AutocompleteNewResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AutocompleteNewResponseToJson(this);

  @override
  List<Object?> get props => [suggestions];
}

@JsonSerializable()
class Suggestion extends Equatable {
  final PlacePrediction placePrediction;

  const Suggestion({required this.placePrediction});

  factory Suggestion.fromJson(Map<String, dynamic> json) =>
      _$SuggestionFromJson(json);

  Map<String, dynamic> toJson() => _$SuggestionToJson(this);

  @override
  List<Object?> get props => [placePrediction];
}

@JsonSerializable()
class PlacePrediction extends Equatable {
  final String place;
  final String placeId;
  final TextInfo text;
  final StructuredFormat structuredFormat;
  final List<String> types;

  const PlacePrediction({
    required this.place,
    required this.placeId,
    required this.text,
    required this.structuredFormat,
    required this.types,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) =>
      _$PlacePredictionFromJson(json);

  Map<String, dynamic> toJson() => _$PlacePredictionToJson(this);

  @override
  List<Object?> get props => [
        place,
        placeId,
        text,
        structuredFormat,
        types,
      ];
}

@JsonSerializable()
class TextInfo extends Equatable {
  final String? text;
  final List<MatchOffset?>? matches;

  const TextInfo({required this.text, required this.matches});

  factory TextInfo.fromJson(Map<String, dynamic> json) =>
      _$TextInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TextInfoToJson(this);

  @override
  List<Object?> get props => [text, matches];
}

@JsonSerializable()
class StructuredFormat extends Equatable {
  final MainText? mainText;
  final SecondaryText? secondaryText;

  const StructuredFormat({required this.mainText, required this.secondaryText});

  factory StructuredFormat.fromJson(Map<String, dynamic> json) =>
      _$StructuredFormatFromJson(json);

  Map<String, dynamic> toJson() => _$StructuredFormatToJson(this);

  @override
  List<Object?> get props => [mainText, secondaryText];
}

@JsonSerializable()
class MainText extends Equatable {
  final String? text;
  final List<MatchOffset?>? matches;

  const MainText({required this.text, required this.matches});

  factory MainText.fromJson(Map<String, dynamic> json) =>
      _$MainTextFromJson(json);

  Map<String, dynamic> toJson() => _$MainTextToJson(this);

  @override
  List<Object?> get props => [text, matches];
}

@JsonSerializable()
class SecondaryText extends Equatable {
  final String? text;

  const SecondaryText({required this.text});

  factory SecondaryText.fromJson(Map<String, dynamic> json) =>
      _$SecondaryTextFromJson(json);

  Map<String, dynamic> toJson() => _$SecondaryTextToJson(this);

  @override
  List<Object?> get props => [text];
}

@JsonSerializable()
class MatchOffset extends Equatable {
  final int? endOffset;

  const MatchOffset({required this.endOffset});

  factory MatchOffset.fromJson(Map<String, dynamic> json) =>
      _$MatchOffsetFromJson(json);

  Map<String, dynamic> toJson() => _$MatchOffsetToJson(this);

  @override
  List<Object?> get props => [endOffset];
}

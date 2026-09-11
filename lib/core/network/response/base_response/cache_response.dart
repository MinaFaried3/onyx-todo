import 'package:json_annotation/json_annotation.dart';
import 'cache_state.dart';

part 'cache_response.g.dart';

@JsonSerializable(explicitToJson: true)
class CacheResponse {
  final Map<String, CacheState>? general;
  final Map<String, CacheState>? personal;

  const CacheResponse({
    this.general,
    this.personal,
  });

  factory CacheResponse.fromJson(Map<String, dynamic> json) =>
      _$CacheResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CacheResponseToJson(this);
}

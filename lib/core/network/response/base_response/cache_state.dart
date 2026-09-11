import 'package:json_annotation/json_annotation.dart';

part 'cache_state.g.dart';

@JsonSerializable()
class CacheState {
  final int lastVersion;
  final String lastAction;

  const CacheState({
    required this.lastVersion,
    required this.lastAction,
  });

  factory CacheState.fromJson(Map<String, dynamic> json) =>
      _$CacheStateFromJson(json);

  Map<String, dynamic> toJson() => _$CacheStateToJson(this);
}

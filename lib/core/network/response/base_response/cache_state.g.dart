// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CacheState _$CacheStateFromJson(Map<String, dynamic> json) => CacheState(
  lastVersion: (json['lastVersion'] as num).toInt(),
  lastAction: json['lastAction'] as String,
);

Map<String, dynamic> _$CacheStateToJson(CacheState instance) =>
    <String, dynamic>{
      'lastVersion': instance.lastVersion,
      'lastAction': instance.lastAction,
    };

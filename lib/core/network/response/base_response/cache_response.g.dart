// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CacheResponse _$CacheResponseFromJson(Map<String, dynamic> json) =>
    CacheResponse(
      general: (json['general'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, CacheState.fromJson(e as Map<String, dynamic>)),
      ),
      personal: (json['personal'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, CacheState.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$CacheResponseToJson(CacheResponse instance) =>
    <String, dynamic>{
      'general': instance.general?.map((k, e) => MapEntry(k, e.toJson())),
      'personal': instance.personal?.map((k, e) => MapEntry(k, e.toJson())),
    };

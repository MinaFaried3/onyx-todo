// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseMeta _$ResponseMetaFromJson(Map<String, dynamic> json) => ResponseMeta(
  code: (json['code'] as num).toInt(),
  success: json['success'] as bool,
  message: json['message'] as String?,
  version: (json['version'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  timestamp: json['timestamp'] as String?,
);

Map<String, dynamic> _$ResponseMetaToJson(ResponseMeta instance) =>
    <String, dynamic>{
      'code': instance.code,
      'success': instance.success,
      'message': instance.message,
      'version': instance.version,
      'timestamp': instance.timestamp,
    };

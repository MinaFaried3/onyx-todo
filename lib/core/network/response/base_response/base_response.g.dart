// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse<T> _$BaseResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => BaseResponse<T>(
  meta: ResponseMeta.fromJson(json['meta'] as Map<String, dynamic>),
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
  cache: json['cache'] == null
      ? null
      : CacheResponse.fromJson(json['cache'] as Map<String, dynamic>),
  error: json['error'] == null
      ? null
      : ErrorResponse.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BaseResponseToJson<T>(
  BaseResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'meta': instance.meta.toJson(),
  'data': _$nullableGenericToJson(instance.data, toJsonT),
  'cache': instance.cache?.toJson(),
  'error': instance.error?.toJson(),
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);

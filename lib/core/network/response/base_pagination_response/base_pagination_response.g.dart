// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_pagination_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasePaginationResponse<T> _$BasePaginationResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => BasePaginationResponse<T>(
  meta: ResponseMeta.fromJson(json['meta'] as Map<String, dynamic>),
  data: json['data'] == null
      ? null
      : PaginatedList<T>.fromJson(
          json['data'] as Map<String, dynamic>,
          (value) => fromJsonT(value),
        ),
  cache: json['cache'] == null
      ? null
      : CacheResponse.fromJson(json['cache'] as Map<String, dynamic>),
  error: json['error'] == null
      ? null
      : ErrorResponse.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BasePaginationResponseToJson<T>(
  BasePaginationResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'meta': instance.meta.toJson(),
  'data': instance.data?.toJson((value) => toJsonT(value)),
  'cache': instance.cache?.toJson(),
  'error': instance.error?.toJson(),
};

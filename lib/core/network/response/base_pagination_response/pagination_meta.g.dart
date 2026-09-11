// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) =>
    PaginationMeta(
      page: (json['pageNumber'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      totalItems: (json['totalItems'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasNext: json['hasNext'] as bool,
      hasPrevious: json['hasPrevious'] as bool,
    );

Map<String, dynamic> _$PaginationMetaToJson(PaginationMeta instance) =>
    <String, dynamic>{
      'pageNumber': instance.page,
      'pageSize': instance.pageSize,
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
      'hasNext': instance.hasNext,
      'hasPrevious': instance.hasPrevious,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_query_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseQueryParameters _$BaseQueryParametersFromJson(Map<String, dynamic> json) =>
    BaseQueryParameters(
      page: (json['page'] as num?)?.toInt(),
      perPage: (json['perPage'] as num?)?.toInt(),
      search: json['search'] as String?,
      sortBy: json['sortBy'] as String?,
      sortOrder: $enumDecodeNullable(_$SortOrderEnumMap, json['sortOrder']),
      filters: json['filters'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$BaseQueryParametersToJson(
  BaseQueryParameters instance,
) => <String, dynamic>{
  'page': ?instance.page,
  'perPage': ?instance.perPage,
  'search': ?instance.search,
  'sortBy': ?instance.sortBy,
  'sortOrder': ?_$SortOrderEnumMap[instance.sortOrder],
  'filters': ?instance.filters,
};

const _$SortOrderEnumMap = {SortOrder.asc: 'asc', SortOrder.desc: 'desc'};

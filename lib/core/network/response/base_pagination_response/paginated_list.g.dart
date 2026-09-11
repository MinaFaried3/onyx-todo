// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedList<T> _$PaginatedListFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => PaginatedList<T>(
  items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
  meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaginatedListToJson<T>(
  PaginatedList<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'items': instance.items.map(toJsonT).toList(),
  'meta': instance.meta.toJson(),
};

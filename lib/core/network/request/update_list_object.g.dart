// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_list_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateListObject<TCreate, TUpdate, TDelete>
_$UpdateListObjectFromJson<TCreate, TUpdate, TDelete>(
  Map<String, dynamic> json,
  TCreate Function(Object? json) fromJsonTCreate,
  TUpdate Function(Object? json) fromJsonTUpdate,
  TDelete Function(Object? json) fromJsonTDelete,
) => UpdateListObject<TCreate, TUpdate, TDelete>(
  created: (json['created'] as List<dynamic>?)?.map(fromJsonTCreate).toList(),
  updated: (json['updated'] as List<dynamic>?)?.map(fromJsonTUpdate).toList(),
  deleted: (json['deleted'] as List<dynamic>?)?.map(fromJsonTDelete).toList(),
);

Map<String, dynamic> _$UpdateListObjectToJson<TCreate, TUpdate, TDelete>(
  UpdateListObject<TCreate, TUpdate, TDelete> instance,
  Object? Function(TCreate value) toJsonTCreate,
  Object? Function(TUpdate value) toJsonTUpdate,
  Object? Function(TDelete value) toJsonTDelete,
) => <String, dynamic>{
  'created': ?instance.created?.map(toJsonTCreate).toList(),
  'updated': ?instance.updated?.map(toJsonTUpdate).toList(),
  'deleted': ?instance.deleted?.map(toJsonTDelete).toList(),
};

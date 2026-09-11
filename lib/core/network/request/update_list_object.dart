import 'package:json_annotation/json_annotation.dart';

part 'update_list_object.g.dart';

@JsonSerializable(genericArgumentFactories: true, includeIfNull: false)
class UpdateListObject<TCreate, TUpdate, TDelete> {
  final List<TCreate>? created;
  final List<TUpdate>? updated;
  final List<TDelete>? deleted;

  const UpdateListObject({
    this.created,
    this.updated,
    this.deleted,
  });

  factory UpdateListObject.fromJson(
    Map<String, dynamic> json,
    TCreate Function(Object? json) fromJsonCreate,
    TUpdate Function(Object? json) fromJsonUpdate,
    TDelete Function(Object? json) fromJsonDelete,
  ) =>
      _$UpdateListObjectFromJson(
        json,
        fromJsonCreate,
        fromJsonUpdate,
        fromJsonDelete,
      );

  Map<String, dynamic> toJson(
    Object? Function(TCreate value) toJsonCreate,
    Object? Function(TUpdate value) toJsonUpdate,
    Object? Function(TDelete value) toJsonDelete,
  ) =>
      _$UpdateListObjectToJson(
        this,
        toJsonCreate,
        toJsonUpdate,
        toJsonDelete,
      );
}

import 'package:json_annotation/json_annotation.dart';
import 'pagination_meta.dart';

part 'paginated_list.g.dart';

@JsonSerializable(genericArgumentFactories: true, explicitToJson: true)
class PaginatedList<T> {
  final List<T> items;
  final PaginationMeta meta;

  const PaginatedList({
    required this.items,
    required this.meta,
  });

  factory PaginatedList.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedListFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginatedListToJson(this, toJsonT);
}

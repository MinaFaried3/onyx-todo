import 'package:json_annotation/json_annotation.dart';

part 'pagination_meta.g.dart';

@JsonSerializable()
class PaginationMeta {
  final int page;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const PaginationMeta({
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationMetaToJson(this);
}

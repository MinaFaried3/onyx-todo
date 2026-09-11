import 'package:json_annotation/json_annotation.dart';

part 'base_query_parameters.g.dart';

enum SortOrder {
  @JsonValue('asc')
  asc,
  @JsonValue('desc')
  desc;
}

@JsonSerializable(includeIfNull: false)
class BaseQueryParameters {
  final int? page;
  final int? perPage;
  final String? search;
  final String? sortBy;
  final SortOrder? sortOrder;
  final Map<String, dynamic>? filters;

  const BaseQueryParameters({
    this.page,
    this.perPage,
    this.search,
    this.sortBy,
    this.sortOrder,
    this.filters,
  });

  factory BaseQueryParameters.fromJson(Map<String, dynamic> json) =>
      _$BaseQueryParametersFromJson(json);

  Map<String, dynamic> toJson() => _$BaseQueryParametersToJson(this);

  /// Converts pagination, sorting, search, and flat filters to query parameters map for Dio.
  Map<String, dynamic> toQueryParameters() {
    final map = <String, dynamic>{};
    if (page != null) map['page'] = page;
    if (perPage != null) map['perPage'] = perPage;
    if (search != null && search!.isNotEmpty) map['search'] = search;
    if (sortBy != null && sortBy!.isNotEmpty) map['sortBy'] = sortBy;
    if (sortOrder != null) map['sortOrder'] = sortOrder!.name;
    if (filters != null) {
      map.addAll(filters!);
    }
    return map;
  }
}

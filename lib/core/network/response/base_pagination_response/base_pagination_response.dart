import 'package:json_annotation/json_annotation.dart';
import '../base_response/cache_response.dart';
import '../base_response/error_response.dart';
import '../base_response/response_meta.dart';
import 'paginated_list.dart';

part 'base_pagination_response.g.dart';

@JsonSerializable(genericArgumentFactories: true, explicitToJson: true)
class BasePaginationResponse<T> {
  final ResponseMeta meta;
  final PaginatedList<T>? data;
  final CacheResponse? cache;
  final ErrorResponse? error;

  const BasePaginationResponse({
    required this.meta,
    this.data,
    this.cache,
    this.error,
  });

  // Direct getters from meta
  bool get isSuccess => meta.success;
  int get code => meta.code;
  String? get message => meta.message;
  List<String>? get version => meta.version;
  String? get timestamp => meta.timestamp;

  factory BasePaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BasePaginationResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BasePaginationResponseToJson(this, toJsonT);
}

import 'package:json_annotation/json_annotation.dart';
import 'cache_response.dart';
import 'error_response.dart';
import 'response_meta.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true, explicitToJson: true)
class BaseResponse<T> {
  final ResponseMeta meta;
  final T? data;
  final CacheResponse? cache;
  final ErrorResponse? error;

  const BaseResponse({
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

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseResponseToJson(this, toJsonT);
}

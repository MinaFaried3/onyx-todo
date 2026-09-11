import 'package:json_annotation/json_annotation.dart';

part 'response_meta.g.dart';

@JsonSerializable()
class ResponseMeta {
  final int code;
  final bool success;
  final String? message;
  final List<String>? version;
  final String? timestamp;

  const ResponseMeta({
    required this.code,
    required this.success,
    this.message,
    this.version,
    this.timestamp,
  });

  factory ResponseMeta.fromJson(Map<String, dynamic> json) =>
      _$ResponseMetaFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseMetaToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'delete_item_identifier.g.dart';

@JsonSerializable(includeIfNull: false)
class DeleteItemIdentifier {
  final dynamic id;
  final String? status;

  const DeleteItemIdentifier({
    required this.id,
    this.status,
  });

  factory DeleteItemIdentifier.fromJson(Map<String, dynamic> json) =>
      _$DeleteItemIdentifierFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteItemIdentifierToJson(this);
}

import 'package:onyx_todo/core/helper/typedefs.dart';
import 'package:equatable/equatable.dart';

final class RealTimeEvent extends Equatable {
  final String type;
  final String? id;
  final Json data;
  final DateTime receivedAt;

  const RealTimeEvent({
    required this.type,
    this.id,
    required this.data,
    required this.receivedAt,
  });

  factory RealTimeEvent.fromJson(Json json) {
    return RealTimeEvent(
      type: json['type'] as String? ?? 'unknown',
      id: json['id'] as String?,
      data: json['data'] as Json? ?? json,
      receivedAt: DateTime.now(),
    );
  }

  factory RealTimeEvent.fromSse({
    String? id,
    String? event,
    required Json data,
  }) {
    return RealTimeEvent(
      type: event ?? data['type'] as String? ?? 'unknown',
      id: id,
      data: data,
      receivedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [type, id, data, receivedAt];
}

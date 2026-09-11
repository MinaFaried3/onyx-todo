import 'package:equatable/equatable.dart';

/// Base abstract class for all BLoC events in the application.
///
/// Feature events should extend or implement [BaseEvent]. Using Dart 3
/// `sealed class` for feature events enables exhaustive pattern matching.
abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];
}

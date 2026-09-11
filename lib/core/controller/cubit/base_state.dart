import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  final UiState? uiState;
  final Failure? failure;

  const BaseState({this.uiState, this.failure});

  BaseState copyWith({UiState? uiState, Failure? Function()? failure});

  @override
  List<Object?> get props;
}

extension FailureExtension on Failure? Function()? {
  Failure? get copy => this?.call();
}

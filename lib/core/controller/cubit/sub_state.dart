import 'package:onyx_todo/core/controller/cubit/base_state.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/core/ui/widgets/animation/lottie_animation/loading_indicator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class SubState<T> extends Equatable {
  final UiState state;
  final T? data;
  final Failure? failure;
  final String? message;

  const SubState({
    this.state = UiState.initial,
    this.data,
    this.failure,
    this.message,
  });

  bool get isInitial => state == .initial;

  bool get isLoading => state == .loading;

  bool get isSucceed => state == .succeed;

  bool get isFailed => state == .failed;

  bool get isLoadMore => state == .loadMore;

  @override
  List<Object?> get props => [state, data, failure, message];

  SubState<T> copyWith({
    UiState? state,
    T? data,
    Failure? Function()? failure,
    String? message,
  }) {
    return SubState<T>(
      state: state ?? this.state,
      data: data ?? this.data,
      failure: failure.copy,
      message: message ?? this.message,
    );
  }

  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T? data) succeed,
    required R Function(Failure? failure) failed,
    required R Function() loadMore,
  }) => switch (state) {
    .initial => initial(),
    .loading => loading(),
    .succeed => succeed(data),
    .failed => failed(failure),
    .loadMore => loadMore(),
  };

  R maybeWhen<R>({
    R Function()? initial,
    R Function()? loading,
    R Function(T? data)? succeed,
    R Function(Failure? failure)? failed,
    R Function()? loadMore,
    required R Function() orElse,
  }) => switch (state) {
    .initial => initial?.call() ?? orElse(),
    .loading => loading?.call() ?? orElse(),
    .succeed => succeed?.call(data) ?? orElse(),
    .failed => failed?.call(failure) ?? orElse(),
    .loadMore => loadMore?.call() ?? orElse(),
  };

  Widget maybeWhenWidgets({
    Widget Function()? initial,
    Widget Function()? loading,
    Widget Function(T? data)? succeed,
    Widget Function(Failure? failure)? failed,
    Widget Function()? loadMore,
    required Widget Function() orElse,
  }) => switch (state) {
    .initial => initial?.call() ?? orElse(),
    .loading =>
      loading?.call() ??
          Stack(
            children: [
              orElse(),
              Positioned.fill(
                child: Container(color: Colors.white.withValues(alpha: 0.75)),
              ),
              const Align(alignment: Alignment.center, child: LoadingIndicator()),
            ],
          ),
    .succeed => succeed?.call(data) ?? orElse(),
    .failed => failed?.call(failure) ?? orElse(),
    .loadMore => loadMore?.call() ?? orElse(),
  };

  R? whenOrNull<R>({
    R Function()? initial,
    R Function()? loading,
    R Function(T? data)? succeed,
    R Function(Failure? failure)? failed,
    R Function()? loadMore,
  }) => switch (state) {
    .initial => initial?.call(),
    .loading => loading?.call(),
    .succeed => succeed?.call(data),
    .failed => failed?.call(failure),
    .loadMore => loadMore?.call(),
  };
}

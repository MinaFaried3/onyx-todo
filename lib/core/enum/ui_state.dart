import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/widgets/animation/lottie_animation/loading_indicator.dart';

enum UiState { initial, loading, succeed, failed, loadMore }

extension UiStateCheck on UiState {
  bool get isInitial => this == .initial;

  bool get isLoading => this == .loading;

  bool get isSucceed => this == .succeed;

  bool get isFailed => this == .failed;

  bool get isLoadMore => this == .loadMore;
}

extension UiStateX on UiState {
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function() succeed,
    required T Function() failed,
    required T Function() loadMore,
  }) => switch (this) {
    .initial => initial(),
    .loading => loading(),
    .succeed => succeed(),
    .failed => failed(),
    .loadMore => loadMore(),
  };

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function()? succeed,
    T Function()? failed,
    T Function()? loadMore,
    required T Function() orElse,
  }) => switch (this) {
    .initial => initial?.call() ?? orElse(),
    .loading => loading?.call() ?? orElse(),
    .succeed => succeed?.call() ?? orElse(),
    .failed => failed?.call() ?? orElse(),
    .loadMore => loadMore?.call() ?? orElse(),
  };

  Widget maybeWhenWidgets<T>({
    Widget Function()? initial,
    Widget Function()? loading,
    Widget Function()? succeed,
    Widget Function()? failed,
    Widget Function()? loadMore,
    required Widget Function() orElse,
  }) => switch (this) {
    .initial => initial?.call() ?? orElse(),
    .loading =>
      loading?.call() ??
          Stack(
            children: [
              orElse(),
              Positioned.fill(
                child: Container(color: Colors.white.withValues(alpha: 0.75)),
              ),
              const Align(alignment: .center, child: LoadingIndicator()),
            ],
          ),
    .succeed => succeed?.call() ?? orElse(),
    .failed => failed?.call() ?? orElse(),
    .loadMore => loadMore?.call() ?? orElse(),
  };

  T? whenOrNull<T>({
    T Function()? initial,
    T Function()? loading,
    T Function()? succeed,
    T Function()? failed,
    T Function()? loadMore,
  }) => switch (this) {
    .initial => initial?.call(),
    .loading => loading?.call(),
    .succeed => succeed?.call(),
    .failed => failed?.call(),
    .loadMore => loadMore?.call(),
  };
}

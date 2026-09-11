import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

export 'package:bloc_concurrency/bloc_concurrency.dart'
    show restartable, droppable, sequential, concurrent;

/// Custom [EventTransformer] that debounces incoming events by [duration].
///
/// Useful for text search input, autocomplete fields, or high-frequency user interactions.
EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) {
    return restartable<E>()(
      events.asyncExpand((event) async* {
        await Future<void>.delayed(duration);
        yield event;
      }),
      mapper,
    );
  };
}

/// Functional Programming (FP) module for onyx_todo.
///
/// Built on [fpdart: ^1.2.0], offering pure, composable abstractions
/// that seamlessly blend with Flutter's Clean Architecture and BLoC pattern:
/// - [Option]: Null-safety without null reference exceptions
/// - [Either]: Disjoint union for error handling without throwing exceptions
/// - [Unit]: Functional representation of void operations ([unit])
/// - [IO] / [IORef] / [IOOption] / [IOEither]: Synchronous side effects and safe computations
/// - [Task] / [TaskOption] / [TaskEither]: Lazy async computations and composable network pipelines
/// - [Reader] / [ReaderTask] / [ReaderTaskEither]: Pure functional dependency injection
/// - [State] / [StateAsync]: Pure state machines and transitions
/// - [Predicate]: Declarative composable boolean logic
/// - [Iterable] & [Map] extensions: Safe functional collections operations
library onyx_todo.fp;

import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:fpdart/fpdart.dart';

export 'package:fpdart/fpdart.dart';

// ─── Nullable <-> Option Extensions ──────────────────────────────────────────

extension NullableToOptionExtension<T> on T? {
  /// Converts a nullable value [T?] into an [Option<T>].
  Option<T> toOption() => Option.fromNullable(this);
}

extension StringOptionExtension on Option<String> {
  /// Filters out empty or whitespace-only strings.
  Option<String> filterNotBlank() =>
      filter((str) => str.trim().isNotEmpty);
}

// ─── Either Ergonomic Extensions ─────────────────────────────────────────────

extension EitherErgonomicsExtension<L, R> on Either<L, R> {
  /// Returns the right value if present, or `null`.
  R? getOrNull() => match((_) => null, (r) => r);

  /// Returns the left failure value if present, or `null`.
  L? getLeftOrNull() => match((l) => l, (_) => null);

  /// Checks if this either contains a successful Right value matching [predicate].
  bool exists(bool Function(R value) predicate) =>
      match((_) => false, predicate);
}

// ─── TaskEither Extensions ───────────────────────────────────────────────────

extension TaskEitherErgonomicsExtension<L, R> on TaskEither<L, R> {
  /// Runs the task and returns the right value if present, or `null`.
  Future<R?> getOrNull() async => (await run()).getOrNull();

  /// Runs the task and returns the right value or [defaultValue].
  Future<R> getOrElseFuture(R Function(L left) defaultValue) async =>
      (await run()).getOrElse(defaultValue);
}

// ─── Iterable FP Extensions ───────────────────────────────────────────────────

extension FpIterableExtension<T> on Iterable<T> {
  /// Finds the first element matching [predicate] and wraps in an [Option].
  Option<T> find(bool Function(T item) predicate) {
    for (final item in this) {
      if (predicate(item)) return Some(item);
    }
    return const None();
  }
}

// ─── Predicate Typedef & Utilities ───────────────────────────────────────────

/// Predicate function representing a boolean test on type [T].
typedef Predicate<T> = bool Function(T value);

abstract final class PredicateUtils {
  /// Combines a list of predicates using logical AND (all must match).
  static Predicate<T> all<T>(Iterable<Predicate<T>> predicates) =>
      (value) => predicates.every((p) => p(value));

  /// Combines a list of predicates using logical OR (at least one must match).
  static Predicate<T> any<T>(Iterable<Predicate<T>> predicates) =>
      (value) => predicates.any((p) => p(value));

  /// Inverts a predicate.
  static Predicate<T> not<T>(Predicate<T> predicate) =>
      (value) => !predicate(value);
}

// ─── Safe IO Decoders ────────────────────────────────────────────────────────

abstract final class FpIO {
  /// Safely wraps a synchronous decoder/parser in an [IOEither<Failure, T>].
  static IOEither<Failure, T> tryCatch<T>(
    T Function() computation, {
    String? errorMessage,
  }) =>
      IOEither.tryCatch(
        computation,
        (error, stack) => ServerFailure(
          code: 500,
          message: errorMessage ?? error.toString(),
        ),
      );
}

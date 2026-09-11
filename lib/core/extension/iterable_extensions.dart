/// High-performance lazy generator extensions on [Iterable].
///
/// Follows the Dart Generator Pattern (`sync*` / `yield`) to eliminate
/// intermediate list allocations, enable lazy evaluation, and support early termination.
extension LazyIterableGeneratorX<T> on Iterable<T> {
  /// Lazily chunks this iterable into sub-lists of at most [size] elements.
  ///
  /// Useful for batching API requests, database bulk inserts, or multipart uploads
  /// without materializing all chunks in memory simultaneously.
  ///
  /// ```dart
  /// final batches = items.chunks(100);
  /// for (final batch in batches) {
  ///   await uploadBatch(batch);
  /// }
  /// ```
  Iterable<List<T>> chunks(int size) sync* {
    if (size <= 0) {
      throw ArgumentError.value(size, 'size', 'Chunk size must be greater than zero.');
    }
    var chunk = <T>[];
    for (final element in this) {
      chunk.add(element);
      if (chunk.length == size) {
        yield chunk;
        chunk = <T>[];
      }
    }
    if (chunk.isNotEmpty) {
      yield chunk;
    }
  }

  /// Lazily interleaves [separator] between adjacent elements of this iterable.
  ///
  /// Useful for UI builders, breadcrumb separators, or text joins without
  /// allocating intermediate collections.
  ///
  /// ```dart
  /// final widgets = items.map((e) => Text(e)).separatedBy(const Divider());
  /// ```
  Iterable<T> separatedBy(T separator) sync* {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return;

    yield iterator.current;
    while (iterator.moveNext()) {
      yield separator;
      yield iterator.current;
    }
  }

  /// Lazily yields elements matching [test], including the first element that fails the test.
  ///
  /// ```dart
  /// final steps = path.takeWhileInclusive((step) => !step.isDestination);
  /// ```
  Iterable<T> takeWhileInclusive(bool Function(T element) test) sync* {
    for (final element in this) {
      yield element;
      if (!test(element)) break;
    }
  }
}

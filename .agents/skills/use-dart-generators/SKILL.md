---
name: use-dart-generators
description: Guides the agent on identifying, auditing, and applying Dart generators (sync*, async*, yield, yield*) for lazy evaluation, incremental streaming, recursive traversal, and memory-optimized collection pipelines.
---

# Dart Generators: `sync*` & `async*` Pattern

Use this skill when auditing collection transformations, designing streaming APIs, implementing recursive tree/graph algorithms, building lazy batching pipelines, or optimizing memory allocations.

---

## The Core Principle

> **Use generators when values should be produced lazily, incrementally, recursively, or progressively over time.**
> **Do NOT use generators when they add abstraction without a measurable architectural, performance, or memory benefit.**

---

## 1. When to Use `sync*` (Synchronous Lazy Generator)

Use `sync*` when the function naturally produces a sequence of elements lazily, intermediate collections can be eliminated, or recursion is involved.

### Key Use Cases for `sync*`
1. **Recursive Tree / Hierarchy Traversal**:
   Eliminates intermediate `List` allocations and spread operators at every tree depth.
   ```dart
   // ✅ GOOD: Lazy recursive traversal with yield* (0 intermediate List allocations)
   Iterable<ScreenEntity> get navigableDescendants sync* {
     if (isNavigable) yield this;
     if (children case final children?) {
       for (final child in children) {
         yield* child.navigableDescendants;
       }
     }
   }
   ```
2. **Early-Terminating Searches ($O(1)$ first match)**:
   When consumers call `.first`, `.firstOrNull`, `.any()`, or `.take(n)` on sequences where generating all items would be wasteful.
   ```dart
   // ✅ GOOD: Terminates immediately on the first navigable item
   ScreenEntity? get defaultScreen => navigableScreens.firstOrNull;
   ```
3. **Lazy Batching / Chunking Pipelines**:
   Yielding fixed chunks of large lists or iterables without materializing all chunks simultaneously.
   ```dart
   // ✅ GOOD: Lazily generates batches for network/DB processing
   Iterable<List<T>> chunks(int size) sync* {
     var chunk = <T>[];
     for (final item in this) {
       chunk.add(item);
       if (chunk.length == size) {
         yield chunk;
         chunk = <T>[];
       }
     }
     if (chunk.isNotEmpty) yield chunk;
   }
   ```
4. **Lazy Item Interleaving / Separators**:
   Inserting separators between elements without creating intermediate lists.
   ```dart
   // ✅ GOOD: Lazy interleaving
   Iterable<T> separatedBy(T separator) sync* {
     final it = iterator;
     if (!it.moveNext()) return;
     yield it.current;
     while (it.moveNext()) {
       yield separator;
       yield it.current;
     }
   }
   ```
5. **Streaming / Incremental Decoders**:
   Parsing packed binary/encoded strings (such as Google Maps encoded polylines) on demand.
   ```dart
   // ✅ GOOD: Lazy polyline coordinate decoding
   Iterable<LatLng> decodePolylineLazy(String encoded) sync* {
     int index = 0, len = encoded.length;
     int lat = 0, lng = 0;
     while (index < len) {
       // decode delta lat & lng...
       yield LatLng(lat / 1E5, lng / 1E5);
     }
   }
   ```

---

## 2. When to Use `async*` (Asynchronous Stream Generator)

Use `async*` when multiple asynchronous values are produced progressively over time, or pagination naturally streams items to consumers.

### Key Use Cases for `async*`
1. **Incremental Multi-Page Polling / Pagination Stream**:
   ```dart
   // ✅ GOOD: Incremental pagination stream
   Stream<List<Item>> fetchAllPagesStream(int initialPage) async* {
     var page = initialPage;
     while (true) {
       final result = await repository.fetchPage(page);
       yield result.items;
       if (!result.meta.hasNextPage) break;
       page++;
     }
   }
   ```
2. **BLoC Event Transformers (Debounce / Throttle)**:
   ```dart
   // ✅ GOOD: Stream expansion with async*
   EventTransformer<E> debounce<E>(Duration duration) {
     return (events, mapper) => restartable<E>()(
       events.asyncExpand((event) async* {
         await Future<void>.delayed(duration);
         yield event;
       }),
       mapper,
     );
   }
   ```
3. **Polling / Exponential Backoff Retry Streams**:
   ```dart
   // ✅ GOOD: Stream yielding status with backoff
   Stream<ConnectionStatus> monitorConnectionWithBackoff() async* {
     var attempt = 0;
     while (true) {
       final status = await checkHealth();
       yield status;
       if (status == ConnectionStatus.connected) break;
       await Future<void>.delayed(Duration(seconds: 1 << attempt++));
     }
   }
   ```

---

## 3. Explicitly Reject Bad Generator Candidates

Do NOT introduce a generator in these situations:

| Anti-Pattern | Why it is Bad | Correct Pattern |
|---|---|---|
| Single Async Value | Wrapping a single Future in `async*` adds stream overhead without benefit | `Future<User> getUser()` |
| Small Materialized Collections | Small lists (enum values, 2-10 items) already in memory get slower with generator state machines | `users.where(...).map(...).toList()` |
| Random Access Required | Callers needing `items[index]` or `.length` (e.g. `ListView.builder`, DataTables) require `List` | Keep as `List<T>` |
| Existing Stream Transformations | Wrapping an existing `Stream` in `async*` when `stream.map()` / `stream.where()` suffices | `stream.where((e) => e.isValid)` |
| Over-Engineering / Style Alone | Introducing generators simply to look "advanced" or functional | Keep simplest idiomatic Dart |

---

## 4. Decision Framework

Before writing a generator, answer:
1. **Why is lazy/incremental generation useful here?**
2. **Can the consumer terminate early before consuming all elements?**
3. **Does it eliminate intermediate collection allocations or simplify recursion (`yield*`)?**
4. **Is `Iterable<T>` or `Stream<T>` genuinely the expected API?**
5. **Would a standard collection method (`.where()`, `.map()`) or a standard `Future` be simpler?**

If the answers do not establish a measurable benefit, **do not use a generator**.

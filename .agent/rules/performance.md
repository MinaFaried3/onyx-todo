# Performance Rules

Performance matters, but don't optimize prematurely.

## Always Do

- Use `const` constructors for all widgets where possible
- Use `ListView.builder`, `GridView.builder` — never generate lists with `children: []`
- Keep expensive operations out of `build()` — no API calls, no heavy computation
- Use `BlocListener` for side-effects, `BlocBuilder`/`AppBlocConsumer` for UI
- Cache values that are expensive to compute

## When to Optimize

Only optimize when there's a proven bottleneck. Profile first.

## Parallelize Independent Async Operations

When two or more `await` calls are **independent** (neither produces data consumed by the other), use `Future.wait` to run them concurrently instead of sequentially:

```dart
// ❌ BAD — sequential, total time = sum of both
final token = await getToken();
final lang = await getLanguage();

// ✅ GOOD — parallel, total time = max of both
final [token, lang] = await Future.wait([getToken(), getLanguage()]);
```

**Rules:**
- Only parallelize when calls are truly independent — never if the second `await` depends on the result of the first
- Never parallelize if one call is a guard/condition for the other (e.g., permission check before action)
- Never parallelize if both calls share mutable state that could race
- `Future.wait` fails fast — if any future throws, the whole batch throws. Use `try-catch` if partial failure is acceptable
- For nullable platform-specific calls (`?.method()`), use `?? Future.value()` to provide a fallback in the list

## Dart Generators & Lazy Evaluation (`sync*` / `async*`)

Use Dart generators when lazy, incremental, recursive, or streaming evaluation provides a real benefit:
- **`sync*` with `yield*` for Recursive Trees**: Avoids allocating and spreading intermediate `List` collections at every depth of hierarchy traversal.
- **Early-Terminating Searches**: Expose sequences as `Iterable<T>` when callers consume only `.firstOrNull`, `.first`, or `.take(n)` to avoid processing remaining items.
- **Lazy Batching / Chunking**: Use `.chunks(size)` from `onyx_todo` to process large collections in batches without materializing all sublists at once.
- **`async*` for Progressive Streams**: Use for paginated streams, debounce event transformers, or exponential backoff loops.
- **Never abuse generators**: Do NOT convert simple small lists, single-result `Future` operations, or collections requiring index access (`[i]`, `.length`).

## Avoid

- Unnecessary rebuilds (use `const` and `BlocSelector` when only part of state changes)
- Large widget trees that could be extracted
- Repeated `MediaQuery.of(context)` calls — use responsive extension
- Heavy JSON parsing or serialization in the UI thread
- Unbounded `Stream` subscriptions without proper disposal

## Specific to This Project

- The theme is computed once — don't recreate `ThemeData` or mutate it
- `get_it` lookups are cheap — no need to cache DI results in variables
- Maps widgets are expensive — avoid rebuilding map controllers unnecessarily
- Use `RepaintBoundary` for complex maps or animations if jank appears

## Google Maps checklist (when adding map screens)

- Dispose `GoogleMapController` in `State.dispose`
- Cancel location stream subscriptions (`LocationService.dispose`)
- Debounce marker/polyline/camera updates (batch `setState` / cubit emits)
- Wrap the map in `RepaintBoundary` if profiling shows jank
- Avoid rebuilding the map widget on unrelated bloc state (use `BlocSelector` / narrow `buildWhen`)

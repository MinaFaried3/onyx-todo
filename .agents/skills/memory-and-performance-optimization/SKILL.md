---
name: memory-and-performance-optimization
description: Guides the agent on diagnosing and optimizing Flutter memory leaks, reducing unnecessary builds, handling streams and controllers disposal, optimizing lists, and parallelizing concurrent async calls safely.
---

# Memory and Performance Optimization

Use this skill when profiling the application, resolving UI jank/lag, fixing memory leaks (OOM errors), refactoring complex lists or maps, or conducting performance code reviews.

## When to use this skill
- When building pages containing complex lists, animations, or Google Maps.
- When managing local state controllers, long-lived streams, or location trackers.
- When performing heavy JSON serialization or multiple concurrent API queries.

---

## 1. Preventing Memory Leaks (Flutter Hooks & Clean Code)

### Controller Disposal & Lifecycle Rule (Flutter Hooks)
Every local controller (`ScrollController`, `TextEditingController`, `AnimationController`, `PageController`, `TabController`, etc.) must be closed.
**Rule:** Use `flutter_hooks` (`HookWidget`, `useTextEditingController`, `useScrollController`, `useAnimationController`, `useFocusNode`, `useRef`, `useEffect`) instead of `StatefulWidget` to eliminate manual disposal boilerplate and guarantee zero memory leaks.

```dart
// ❌ BAD: Memory leak - controller is never disposed in StatelessWidget
class SearchBox extends StatelessWidget {
  final controller = TextEditingController(); // Never do this in StatelessWidget
  ...
}

// ❌ OLD / VERBOSE: Boilerplate StatefulWidget with manual disposal
class SearchBox extends StatefulWidget {
  const SearchBox({super.key});
  @override
  State<SearchBox> createState() => _SearchBoxState();
}

// ✅ BEST: Flutter Hooks (automatic resource disposal, 0 boilerplate)
class SearchBox extends HookWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    // Automatically allocated & disposed when widget is unmounted
    final controller = useTextEditingController();
    final debounceTimer = useRef<Timer?>(null);

    useEffect(() {
      return () => debounceTimer.value?.cancel();
    }, const []);

    return TextField(controller: controller);
  }
}
```

### Stream & Subscription Management
Long-lived streams (such as location updates from `LocationService` or custom event channels) must be closed.
- In `HookWidget`, use `useEffect` and return a cleanup callback that calls `.cancel()`.
- In Cubits, close any active subscriptions inside the `close()` override of the Cubit.

```dart
// ✅ Cancelling stream in Cubit
class LocationTrackerCubit extends Cubit<LocationState> {
  final LocationService _locationService;
  StreamSubscription<LocationData>? _subscription;

  LocationTrackerCubit(this._locationService) : super(const LocationState());

  void startTracking() {
    _subscription = _locationService.location.onLocationChanged.listen((data) {
      emit(state.copyWith(latLng: data.toLatLng()));
    });
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel(); // Cancel to avoid memory leak
    return super.close();
  }
}
```

---

## 2. Rebuild Optimization (Flyweight Pattern & Repaint Boundaries)

### Standalone Public Class Widgets vs Helper Methods & Private Classes
**Rule 1: No Private Widget Classes**
Every widget must be a standalone public class declared in its own dedicated file under an appropriate directory (`lib/core/ui/widgets/...` or `lib/feature/.../presentation/widgets/`). NEVER declare private widget classes (`class _MyWidget extends StatelessWidget / StatefulWidget`) or nest widgets within another file.

**Rule 2: Class Widgets vs Helper Methods**
Always extract sub-widgets into standalone `StatelessWidget` / `HookWidget` classes rather than helper methods (e.g., `Widget _buildHeader()`).
- **Why?** When you use a helper method, updating the parent widget forces the helper method to re-run and rebuild. Standalone class widgets can use `const` constructors, have their own lifecycle, and are optimized by Flutter to skip rebuilding if their inputs haven't changed.
- **Why not helper methods?** Flutter cannot automatically optimize method calls inside `build()` because they are treated as direct inline extensions of the parent build method.

```dart
// ❌ BAD: Rebuilds helper method every time the parent builds
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(), // Rebuilds even if it doesn't need to
      ],
    );
  }

  Widget _buildHeader() {
    return Container(child: Text('Header'));
  }
}

// ✅ GOOD: Extracted standalone public class widget using const in its own file
class MyHeaderWidget extends StatelessWidget {
  const MyHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Header');
  }
}
```

### RepaintBoundaries for Heavy Animations and Maps
Wrap widgets that update frequently (such as animated counters, map overlays, or progress spinners) in a `RepaintBoundary`. This prevents the entire tree from repainting when only a subtree changes.

```dart
RepaintBoundary(
  child: AnimatedVehicleMarker(position: latLng),
)
```

---

## 3. Optimizing Lists and Virtualization

### Use ListView.builder and GridView.builder
Never use `Column(children: list.map(...))` or `ListView(children: [...])` for dynamic or large datasets.
Always use `ListView.builder` or `GridView.builder` to enable view virtualization (only building widgets currently visible on screen).

---

## 4. Concurrent Async Calls (`Future.wait`)

When multiple asynchronous operations are independent (neither depends on the other's result), parallelize them with `Future.wait`:

```dart
// ❌ BAD: Sequential execution (total time = sum of calls)
final user = await authRepo.getUser();
final categories = await categoryRepo.getCategories();

// ✅ GOOD: Concurrent execution (total time = max of calls)
final [user, categories] = await Future.wait([
  authRepo.getUser(),
  categoryRepo.getCategories(),
]);
```

---

## 5. Dart Generators & Lazy Evaluation (`sync*` / `async*`)

Use Dart generators (`sync*`, `async*`, `yield`, `yield*`) where lazy, incremental, recursive, or progressive evaluation provides measurable memory or performance benefits.

- **`sync*` with `yield*` for Recursive Trees**: Traverses hierarchies without allocating intermediate `List` collections at every depth.
- **Early-Terminating Iterables**: Exposes sequences as `Iterable<T>` so callers calling `.firstOrNull`, `.take(n)`, or `.any()` terminate in $O(1)$ without computing the entire dataset.
- **Lazy Batching / Chunking**: Use `.chunks(size)` from `onyx_todo` to process large batches incrementally.
- **`async*` for Progressive Streams**: Use for multi-page pagination streams, event transformers (`debounce`), or polling with backoff.
- **Do NOT abuse generators**: Keep simple small collections as Lists; never convert a single `Future<T>` to `Stream<T> async*`; never replace Lists when random access (`[index]`, `.length`) is needed.

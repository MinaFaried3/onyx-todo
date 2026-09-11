# State Management Rules

Project uses **flutter_bloc (Cubit)** — this is non-negotiable.

## Cubit Pattern

Every Cubit extends `BaseCubit<FeatureState>` (or uses `SafeRequestHandler<FeatureState>`).

API operations must use `handleResult` from `SafeRequestHandler` to handle `Either<Failure, T>` results, returning the updated state from `onSuccess` and `onFailure` callbacks for single-emission efficiency:

```dart
class FeatureCubit extends BaseCubit<FeatureState> {
  final FeatureRepository _repo;

  FeatureCubit(this._repo) : super(const FeatureState());

  Future<void> doSomething() async {
    emit(state.copyWith(uiState: UiState.loading));
    final result = await _repo.call();
    handleResult(
      result,
      onFailure: (failure) => state.copyWith(
        uiState: UiState.failed,
        failure: () => failure,
      ),
      onSuccess: (data) => state.copyWith(
        uiState: UiState.succeed,
        data: data,
      ),
    );
  }
}
```

## State Rules

- States extend `BaseState` which provides `UiState` + `Failure`
- States are immutable — use `copyWith` for updates
- **CRITICAL Failure Copy Rule**: In any state `copyWith` method, ALWAYS declare `Failure? Function()? failure` and assign `failure: failure.copy`.
  - When emitting failure: pass `failure: () => failure`
  - When emitting success or neutral states: omit `failure` (or pass `() => null`), so `failure.copy` evaluates to `null` and clears any previous failure without stale errors persisting.
  - NEVER use `failure: failure ?? this.failure` or raw `failure: failure`. Always use `Failure? Function()? failure` with `failure: failure.copy`.
- State names must be meaningful: `LoginState`, `OrderDetailsState`, not `HomeState2`
- Handle all `UiState` values: `initial`, `loading`, `succeed`, `failed`

### State Definition Example

```dart
class FeatureState extends BaseState {
  final SubState<FeatureData> featureSubState;

  const FeatureState({
    this.featureSubState = const SubState<FeatureData>(),
    super.uiState,
    super.failure,
  });

  @override
  FeatureState copyWith({
    SubState<FeatureData>? featureSubState,
    UiState? uiState,
    Failure? Function()? failure,
  }) {
    return FeatureState(
      featureSubState: featureSubState ?? this.featureSubState,
      uiState: uiState ?? this.uiState,
      failure: failure.copy,
    );
  }

  @override
  List<Object?> get props => [featureSubState, uiState, failure];
}
```

## SubState Direct Status Pattern & Encapsulation

When working with `SubState<T>` instances (e.g. `state.routeState`, `state.maintenanceMode`, `mySubState`):

1. **Direct Status Getters**: Always use the direct status getters on the `SubState` instance:
   - ✅ `subState.isLoading` (NEVER `subState.state.isLoading` or `subState.state == UiState.loading`)
   - ✅ `subState.isSucceed` (NEVER `subState.state.isSucceed` or `subState.state == UiState.succeed`)
   - ✅ `subState.isFailed` (NEVER `subState.state.isFailed` or `subState.state == UiState.failed`)
   - ✅ `subState.isInitial` (NEVER `subState.state.isInitial` or `subState.state == UiState.initial`)
   - ✅ `subState.isLoadMore` (NEVER `subState.state.isLoadMore` or `subState.state == UiState.loadMore`)

2. **Functional Pattern Matching**: Use `when`, `maybeWhen`, `maybeWhenWidgets`, `whenOrNull` directly on the `SubState` instance:
   ```dart
   // ✅ Clean functional matching with type-safe data and failure callbacks
   subState.when(
     initial: () => const InitialView(),
     loading: () => const LoadingView(),
     succeed: (data) => DataView(data: data),
     failed: (failure) => ErrorView(failure: failure),
     loadMore: () => const LoadMoreView(),
   );
   ```

## Registration

Cubits are registered as factories in get_it:

```dart
di.registerFactoryCubit<FeatureCubit, FeatureState>(
  () => FeatureCubit(di()),
);
```

Never register Cubits as singletons.

## Dart 3

Use `sealed class` for complex state hierarchies when needed:

```dart
sealed class OrderState extends BaseState {
  // exhaustive matching guaranteed
}
```

Use `Switch expressions` in BlocBuilder/AppBlocConsumer handlers.

## Strict Don'ts

- Never put API calls inside UI
- Never put navigation inside repositories
- Never mix state management solutions
- Never create giant Cubits — split by responsibility
- Never emit unnecessary states (avoid rapid duplicate emits)
- Never skip error state handling
- Never access `.state.isLoading` or compare `.state == UiState.*` on a `SubState` instance — always use `subState.isLoading`, `subState.isSucceed`, etc.
- Never use `subState.state == SubState.Loading` (invalid and forbidden)
- Never use `failure: failure ?? this.failure` or raw `failure: failure` in `copyWith` — always use `Failure? Function()? failure` and `failure: failure.copy`
- Never call raw `context.read<MyCubit>()` repeatedly inside widgets or callbacks — always access Cubits via a typed `BuildContext` extension getter (e.g., `context.sidebarCubit`) and store it in a local variable (`final cubit = context.sidebarCubit;`) at the top of `build()` to eliminate redundant $O(N)$ widget tree lookups.
- Never mount multiple `AppBlocConsumer` or `EntityBlocConsumer` widgets (or active `BlocListener`s) listening to the same BLoC/Cubit in the same widget hierarchy. `AppBlocConsumer` registers an active listener that runs `DefaultAppErrorHandler` (`errorStateActions`) on failure. Multiple consumers cause duplicate listener executions (toasts/logs/snackbars). Use `BlocBuilder` / `AppBlocBuilder` for pure presentation components (KPIs, tables, headers), and set `enableBaseListener: false` on modal dialog consumers when they manage local error handling.

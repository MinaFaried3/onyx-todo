---
name: cubit-state-management
description: Instructs the agent on structuring BLoC Cubits and States: extending BaseState, using the SafeEmitter mixin, registering cubits in DI, and using AppBlocConsumer with UiState exhaustiveness.
---

# Cubit State Management

Use this skill when implementing local or global business logic flows, managing screen rendering
states, and handling background request progress in the UI.

## When to use this skill

- When creating a new cubit and state class under `lib/feature/[feature]/presention/controller/`.
- When wiring screen interaction events to repository calls.
- When handling loading spinner displays, error dialogs, or page reload triggers.

---

## Instructions

### Step 1: Define the State

All state classes must extend `BaseState` and override the `props` list. A `copyWith` method should
be provided to make immutable mutations simple:

```dart
import 'package:Onyx_driver/core/controller/helper/base_state.dart';
import 'package:Onyx_driver/core/enum/ui_state.dart';
import 'package:Onyx_driver/core/network/error/app_failures.dart';

class MyFeatureState extends BaseState {
  final MyPayloadData? data;

  const MyFeatureState({
    required super.uiState,
    super.failure,
    this.data,
  });

  factory MyFeatureState.initial() => const MyFeatureState(
        uiState: UiState.initial,
      );

  MyFeatureState copyWith({
    UiState? uiState,
    Failure? Function()? failure,
    MyPayloadData? data,
  }) {
    return MyFeatureState(
      uiState: uiState ?? this.uiState,
      failure: failure.copy,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [uiState, failure, data];
}
```

### Step 2: Define the Cubit

Extend `Cubit<MyState>` and apply the `SafeEmitter<MyState>` and `SafeRequestHandler<MyState>` mixins. This mixin avoids crashes/logs
when emitting states to closed cubits or emitting identical states:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Onyx_driver/core/controller/helper/safe_emitter.dart';
import 'package:Onyx_driver/core/enum/ui_state.dart';

class MyFeatureCubit extends Cubit<MyFeatureState> with SafeEmitter<MyFeatureState> {
  final MyFeatureRepository _repo;

  MyFeatureCubit(this._repo) : super(MyFeatureState.initial());

  Future<void> performOperation(String param) async {
    emit(state.copyWith(uiState: UiState.loading));
    
    final result = await _repo.getFeatureData(param);
    
    result.fold(
      (failure) => emit(state.copyWith(uiState: UiState.failed, failure: () => failure)),
      (data) => emit(state.copyWith(uiState: UiState.succeed, data: data)),
    );
  }
}
```

### Step 3: Register in Dependency Injection (`di`)

Add the factory registration inside `lib/core/injection/dependency_injection.dart`:

```dart
di.registerFactoryCubit<MyFeatureCubit, MyFeatureState>(
  () => MyFeatureCubit(di()),
);
```

### Step 4: Consume in presentation UI (AppBlocConsumer vs BlocBuilder)

Use `AppBlocConsumer` on the screen when handling mutations, errors, and side-effects. It intercepts `UiState.failed` and automatically shows error alerts/snackbars to the user.

> [!IMPORTANT]
> **Single Consumer Rule**: NEVER mount multiple `AppBlocConsumer` or `EntityBlocConsumer` widgets (or active `BlocListener`s) listening to the same BLoC/Cubit in the same widget tree. `AppBlocConsumer` has `enableBaseListener: true` by default, which executes `DefaultAppErrorHandler` (`errorStateActions`). Having multiple consumers in the tree causes duplicate listener executions (e.g. 5x duplicate toasts/snackbars/logs).
> - **Pure Presentation (KPIs, tables, headers)**: ALWAYS use `BlocBuilder` / `AppBlocBuilder`.
> - **Dialogs / Modals with local error handling**: Set `enableBaseListener: false` on `AppBlocConsumer`.
> - **Active Clarification**: If confused about state definitions, API schemas, or business flows, always ask the user directly for clarification to ensure 100% precision and quality.

Use the `uiState.when` or `maybeWhenWidgets` extensions for clean conditional rendering:

```dart
import 'package:flutter/material.dart';
import 'package:Onyx_driver/core/controller/helper/app_bloc_consumer.dart';
import 'package:Onyx_driver/core/enum/ui_state.dart';
import 'package:Onyx_driver/core/extension/context_extensions.dart';

class MyFeatureScreen extends StatelessWidget {
  const MyFeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBlocConsumer<MyFeatureCubit, MyFeatureState>(
        listener: (context, state) {
          if (state.uiState == UiState.succeed) {
            context.safeShowSnackBar("Operation succeeded!");
            context.safePop(); // Safe pop from extensions
          }
        },
        builder: (context, state) {
          return state.uiState.maybeWhenWidgets(
            loading: () => const Center(child: CircularProgressIndicator()),
            orElse: () => Column(
              children: [
                Text('Data: ${state.data?.someField ?? ""}'),
                ElevatedButton(
                  onPressed: () => context.read<MyFeatureCubit>().performOperation("input"),
                  child: const Text('Start'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### Step 5: Working with SubState<T> (Direct Status Pattern)

When defining state slices or sub-features inside a state using `SubState<T>`:

1. **State Definition**:
```dart
class FeatureState extends BaseState {
  final SubState<FeatureData> featureData;

  const FeatureState({
    this.featureData = const SubState<FeatureData>(),
    super.uiState,
    super.failure,
  });

  @override
  FeatureState copyWith({
    SubState<FeatureData>? featureData,
    UiState? uiState,
    Failure? Function()? failure,
  }) {
    return FeatureState(
      featureData: featureData ?? this.featureData,
      uiState: uiState ?? this.uiState,
      failure: failure.copy,
    );
  }

  @override
  List<Object?> get props => [featureData, uiState, failure];
}
```

2. **Status Checking (Direct Getters)**:
   - ✅ `state.featureData.isLoading` (NEVER `state.featureData.state.isLoading` or `state.featureData.state == UiState.loading`)
   - ✅ `state.featureData.isSucceed` (NEVER `state.featureData.state.isSucceed` or `state.featureData.state == UiState.succeed`)
   - ✅ `state.featureData.isFailed` (NEVER `state.featureData.state.isFailed` or `state.featureData.state == UiState.failed`)
   - ✅ `state.featureData.isInitial` (NEVER `state.featureData.state.isInitial` or `state.featureData.state == UiState.initial`)
   - ✅ `state.featureData.isLoadMore` (NEVER `state.featureData.state.isLoadMore` or `state.featureData.state == UiState.loadMore`)

3. **Pattern Matching with SubState**:
```dart
state.featureData.when(
  initial: () => const InitialView(),
  loading: () => const LoadingIndicator(),
  succeed: (data) => DataView(data: data),
  failed: (failure) => ErrorView(failure: failure),
  loadMore: () => const LoadMoreIndicator(),
);
```

## References

- Base State
  Class: [base_state.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/controller/helper/base_state.dart)
- Sub State
  Class: [sub_state.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/controller/cubit/sub_state.dart)
- Safe
  Emitter: [safe_emitter.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/controller/helper/safe_emitter.dart)
- App Bloc
  Consumer: [app_bloc_consumer.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/controller/helper/app_bloc_consumer.dart)
- UI State
  Enum: [ui_state.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/enum/ui_state.dart)
- Error State
  Actions: [error_state_actions.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/controller/helper/error_state_actions.dart)

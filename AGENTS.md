# AI Engineering Rules

You are a senior Flutter engineer working on a production driver app. Write code like a human team member, not like an AI.

## Source of Truth

All detailed rules are in `.agent/rules/`. This file is the entry point. Read the relevant rule files before generating code.

## Priority Order (highest to lowest)

1. `.agent/rules/architecture.md` — feature-first Clean Architecture, strict layer separation
2. `.agent/rules/clean_code.md` — meaningful naming, Dart 3 features, no over-engineering
3. `.agent/rules/flutter.md` — Flutter best practices, widget reuse, const constructors
4. `.agent/rules/state_management.md` — Cubit pattern, BaseState, immutable states
5. `.agent/rules/ui_rules.md` — design system, widget reuse, no hardcoded values
6. `.agent/rules/performance.md` — optimize when needed, not prematurely
7. `.agent/rules/forbidden_patterns.md` — never add tests, never rewrite unrelated code

## Also Read

- `.agent/rules/ai_behavior.md` — how to think and behave like a senior dev
- `.agent/rules/form.md` — form architecture rules (AppForm, AppFormController, AppTextField)
- `.agent/rules/networking.md` — API layer rules (Dio + Retrofit + fpdart)
- `.agent/rules/project_context.md` — project identity and constraints

## Platform Awareness

Every solution **must work on web, Android, and iOS**. Use these utilities:

| Concern | Source |
|---|---|
| Environment/platform flags | `AppMode` from `core/config/mode/app_mode.dart` (`devMobile`, `prodWeb`, `devDebugMobile`, etc.) |
| Device info (OS, version, name) | `getIt<AppDeviceInfo>()` from `core/utils/app_device_info/app_device_info.dart` |
| Platform enum dispatch | `CurrentPlatform` from `core/config/platform/platform.dart` (`isMobile`, `isDesktop`, `isWeb`, `handle<T>()`) |

**Never assume mobile-only APIs** (e.g., `dart:io` Platform, GPS, local file system) — always guard with `AppMode` or `CurrentPlatform` checks. For testing patterns, see `test/core/config/platform/platform_test.dart`.

## Core Principles

- Respect existing architecture — no new patterns unless asked
- Reuse existing components — search first, build second
- Never over-engineer — write what's needed, nothing more
- Write human-like production code — not textbook or AI-perfect
- Match existing project style exactly — conventions > ideals
- Handle errors properly — loading, success, error states always
- **SafeContext** — in callbacks and async gaps, use `safePop()`, `safePush()`, `safeGo()`, `readIfMounted()`, `safeShowSnackBar()` from `core/extension/context_extensions.dart` to avoid calling context on unmounted widgets
- **BLoC Reading** — Always use a typed `BuildContext` extension getter (e.g., `context.sidebarCubit` from `core/extension/bloc_reader.dart`). Store it in a local variable (`final cubit = context.sidebarCubit;`) at the top of `build()` / method instead of calling `context.read<MyCubit>()` repeatedly inside callbacks to eliminate redundant $O(N)$ widget tree lookups.
- **SubState Direct Status Pattern** — When checking the status of any `SubState<T>` instance (e.g., `state.routeState`, `state.maintenanceMode`), ALWAYS use direct status getters (`subState.isLoading`, `subState.isSucceed`, `subState.isFailed`, `subState.isInitial`, `subState.isLoadMore`) or functional pattern matching (`subState.when`, `subState.maybeWhenWidgets`). NEVER access `.state.isLoading`, `.state.isSucceed`, or compare `.state == UiState.*` / `subState.state == SubState.Loading`.
- **State Failure Copy Pattern** — In any state `copyWith`, always declare `Failure? Function()? failure` and assign `failure: failure.copy`. In cubit emissions, pass `failure: () => failure` on failure, and omit `failure` (or pass `() => null`) on success/neutral emissions so `failure.copy` resets previous errors cleanly.
- **Logging** — NEVER use raw `print()`. Always use `Printer.print` or `Printer.log` from `onyx_todo` to clearly identify the source of printed logs.
- **Localization & UI Strings** — All user-facing strings must be localized using `easy_localization` in `assets/translation/ar-EG.json` and `assets/translation/en-US.json` (and `ur-PK.json` where applicable). Every string key must be declared as a `static const String` in `AppStrings` (`lib/core/localization/app_strings.dart`) and invoked via `AppStrings.keyName.tr()`. Never hardcode raw string literals in UI widgets.
- **No Private Widget Classes** — Every widget must be a standalone public class in its own dedicated file under an appropriate directory (`lib/core/ui/widgets/...` or `lib/feature/.../presentation/widgets/`). NEVER declare private widget classes (`class _MyWidget extends StatelessWidget / StatefulWidget`) or nest widgets within another file.
- **Flutter Hooks Over StatefulWidget** — For any widget lifecycle needs, text controllers, focus nodes, animations, local state, or debounce timers, ALWAYS use `flutter_hooks` (`HookWidget`, `useTextEditingController`, `useFocusNode`, `useState`, `useEffect`, `useRef`, `useAnimationController`, etc.) instead of regular Flutter `StatefulWidget` / `State<T>` to eliminate boilerplate lifecycle code, prevent memory leaks, and guarantee automatic resource disposal.

## Flutter Commands

Always use `fvm flutter` instead of `flutter` for any command (build, run, pub, analyze, etc.). Example: `fvm flutter build apk`, `fvm flutter pub get`, `fvm flutter analyze`.

## Critical: No Testing

**Never add tests** of any kind (unit, widget, integration) unless the user explicitly asks for them. This is non-negotiable. Focus all effort on production code.

## Dart 3

Use modern Dart 3 features:
- `sealed class` for state/failure hierarchies
- `Switch expressions` for exhaustive matching
- `Records` for lightweight compound returns
- `Pattern matching` (`if-case`, destructuring)
- `Enhanced enums` with members
- `Dot shorthands` for enums (use `.value` instead of `Enum.value`)
- `Initializing formals` for private fields (e.g., `MyClass({required this._field})`)
- Never use `!` (null assertion) when patterns or null-aware access works
- Destructure `Future.wait` results with `final [a, b] = ...` — never use `results[0]`, `results[1]`
- Use type pattern `switch` over `runtimeType` dispatch — eliminates `as` casts

## Async Performance

When multiple `await` calls are independent (neither produces data consumed by the other), use `Future.wait` to run them concurrently:

```dart
// ❌ Sequential — total time = sum
final a = await callA();
final b = await callB();

// ✅ Parallel — total time = max
final [a, b] = await Future.wait([callA(), callB()]);
```

**Never** parallelize if:
- The second `await` depends on the first's result
- One call is a guard/condition for the other
- Both share mutable state that could race
- **Image Picking & Multipart Uploads** — Always use `context.pickSingleImage()` / `context.pickSingleImageCompressed()` / `context.pickMultipleImages()` from `package:onyx_todo/core/utils/utils.dart` (Camera/Gallery bottom sheet on Mobile, direct file explorer on Web). Use `compressIfNeeded()` for smart threshold-based compression. Always use `await pickedImage.toMultipartFile()` for API uploads to guarantee multi-platform compatibility without `dart:io` crashes.
- **Paginated API Calls** — Always use `executePaginatedApiCall<Model>` from `BaseRepository` for paginated endpoints. Return `FutureBasePagRes<Model>` in remote data sources and `FailureOrPaginated<Model>` in repositories. Never discard `PaginationMeta`, never use deprecated `executePaginationApiCall`, and never use ad-hoc tuples `(List<T>, int)`.
- **Dart Generators (`sync*` / `async*`)** — Use generators for lazy collection processing, recursive tree traversal (`yield*`), early-terminating pipelines, and progressive streaming. Never use generators for small static collections or when random-access indexing (`[i]`, `.length`) is required.
- **Single BLoC Consumer / Listener Pattern (`AppBlocConsumer` / `EntityBlocConsumer`)** — NEVER mount multiple `AppBlocConsumer`, `EntityBlocConsumer`, or active `BlocConsumer`/`BlocListener` widgets listening to the same BLoC/Cubit in the same widget hierarchy or screen flow. `AppBlocConsumer` and `EntityBlocConsumer` enable `enableBaseListener: true` by default, which registers an automatic listener to execute `DefaultAppErrorHandler.handleError` (`errorStateActions`). Having multiple consumers in the tree (e.g. at screen level, top-content cards, and modal dialog) causes a single error or mutation event to execute listeners multiple times concurrently (e.g., 5 duplicate toasts/snackbars/logs). For pure UI/presentation widgets (KPI cards, summary headers, table views, banner widgets), ALWAYS use `BlocBuilder`, `AppBlocBuilder`, or `AppBlocSelector`. For dialogs and scoped modals that manage their own mutations and toasts, set `enableBaseListener: false` on `AppBlocConsumer` and avoid duplicate listeners on parent screens.
- **Active Clarification & Ambiguity Escalation (Ask When Confused / Quality First)** — At any point during a task, if you encounter any ambiguity, underspecified requirement, unclear backend API field names/schemas, conflicting architectural patterns, or confusing requirements: **DO NOT guess or assume**. **Directly ask the user** specific clarifying questions to confirm the correct schema, behavior, or approach. Ensuring 100% precision, correctness, and production quality is the highest priority. It is always better to ask and get it right the first time than to ship speculative code.




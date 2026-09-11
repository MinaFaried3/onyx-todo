# Gemini CLI — Onyx Driver

Senior Flutter engineer. Production driver app. ~226 Dart files.

## Flutter Commands
Always use `fvm flutter` instead of `flutter` (e.g., `fvm flutter build apk`, `fvm flutter pub get`, `fvm flutter analyze`).

## Rules
- **No tests** unless explicitly requested
- Reuse existing components (search first, create second)
- Match existing architecture and conventions
- Dart 3: sealed classes, switch expressions, records, pattern matching, dot shorthands (use `.value` instead of `Enum.value`), initializing formals (`MyClass({required this._field})`). Never use experimental primary constructors.
- No over-engineering, no fake helpers, NEVER use raw print (always use Printer.print or Printer.log from onyx_todo)
- No obvious comments
- **SafeContext** — in callbacks and async gaps, use `safePop()`, `safePush()`, `safeGo()`, `readIfMounted()`, `safeShowSnackBar()` from `core/extension/context_extensions.dart`
- **BLoC Reading** — Always use typed `BuildContext` extension getters (e.g. `context.sidebarCubit`) and store in a local variable (`final cubit = context.sidebarCubit;`) to avoid redundant $O(N)$ tree lookups
- **SubState Direct Status Pattern** — When checking the status of any `SubState<T>` instance, ALWAYS use direct getters (`subState.isLoading`, `subState.isSucceed`, `subState.isFailed`, `subState.isInitial`, `subState.isLoadMore`) or functional pattern matching (`subState.when`, `subState.maybeWhenWidgets`). NEVER access `.state.isLoading`, `.state.isSucceed`, or compare `.state == UiState.*` / `subState.state == SubState.Loading`.
- **State Failure Copy** — In any state `copyWith`, always declare `Failure? Function()? failure` and assign `failure: failure.copy`. Pass `failure: () => failure` in cubit failures, and omit `failure` on success/neutral emissions so `failure.copy` resets errors cleanly
- **Image Picking & Multipart Uploads** — Always use `context.pickSingleImage()` / `context.pickSingleImageCompressed()` / `context.pickMultipleImages()` from `package:onyx_todo/core/utils/utils.dart` (Camera/Gallery bottom sheet on Mobile, direct file explorer on Web). Use `compressIfNeeded()` for smart threshold-based compression. Always use `await pickedImage.toMultipartFile()` for API uploads to guarantee multi-platform compatibility without `dart:io` crashes.
- **Paginated API Calls** — Always use `executePaginatedApiCall<Model>` from `BaseRepository` for paginated endpoints. Return `FutureBasePagRes<Model>` in remote data sources and `FailureOrPaginated<Model>` in repositories. Never discard `PaginationMeta`, never use deprecated `executePaginationApiCall`, and never use ad-hoc tuples `(List<T>, int)`.
- **Form Pattern** — Two modes: **(1) Integrated** (login, registration, create/edit screens with validation + submit): use `AppForm` + `useAppFormController()`, submit via `formController.submit()`, handle API errors via `formController.handleFailure(failure)`. **(2) Standalone** (search bars, filters, single inputs): use `AppTextField` directly with `controller` + `onChanged`, no `fieldId` needed. See `.agent/rules/form.md`
- **Localization & UI Strings** — All user-facing strings must be localized using `easy_localization` in `assets/translation/ar-EG.json` and `assets/translation/en-US.json` (and `ur-PK.json` where applicable). Every string key must be declared as a `static const String` in `AppStrings` (`lib/core/localization/app_strings.dart`) and invoked via `AppStrings.keyName.tr()`. Never hardcode raw string literals in UI widgets.
- **No Private Widget Classes** — Every widget must be a standalone public class in its own dedicated file under an appropriate directory (`lib/core/ui/widgets/...` or `lib/feature/.../presentation/widgets/`). Never declare private widget classes (`class _MyWidget extends StatelessWidget / StatefulWidget`) or nest widgets within another file.
- **Flutter Hooks Over StatefulWidget** — For any widget lifecycle needs, text controllers, focus nodes, animations, local state, or debounce timers, ALWAYS use `flutter_hooks` (`HookWidget`, `useTextEditingController`, `useFocusNode`, `useState`, `useEffect`, `useRef`, `useAnimationController`, etc.) instead of regular Flutter `StatefulWidget` / `State<T>`.
- **Dart Generators (`sync*` / `async*`)** — Use generators for lazy collection processing, recursive tree traversal (`yield*`), early-terminating pipelines, and progressive streaming. Never use generators for small static collections or when random-access indexing (`[i]`, `.length`) is required.
- **Single BLoC Consumer / Listener Pattern** — NEVER mount multiple `AppBlocConsumer`, `EntityBlocConsumer`, or active `BlocConsumer`/`BlocListener` widgets listening to the same BLoC/Cubit in the same widget hierarchy. `AppBlocConsumer` and `EntityBlocConsumer` enable `enableBaseListener: true` by default, triggering `errorStateActions` / toasts / logs on failure. For pure presentation widgets (KPIs, tables, headers), ALWAYS use `BlocBuilder` / `AppBlocBuilder`. For dialogs/forms with local mutation handling, set `enableBaseListener: false` on `AppBlocConsumer`.
- **Active Clarification & Ambiguity Escalation** — If you are ever confused, encounter ambiguous requirements, or see unknown backend API field schemas during any task, DO NOT guess or assume. Directly ask the user clarifying questions to guarantee quality and precision.

## Stack
State: flutter_bloc Cubit + BaseState | DI: get_it | Routing: go_router typed routes + guards | API: Dio + Retrofit + fpdart Either | Localization: easy_localization (ar/en/ur) | Maps: Google Maps APIs | Storage: Hive + secure_storage | Firebase: Analytics, Crashlytics, Messaging, Remote Config, Performance

Data flow: Screen → Cubit → Repository → DataSource → API (returns Either<Failure, T>)
For detailed rules: `.agent/rules/`




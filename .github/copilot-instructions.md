You are a senior Flutter engineer on Onyx Driver — a production driver app. Feature-first Clean Architecture with ~226 Dart files.

### Platform Awareness
Every solution **must work on web, Android, and iOS**:
- **AppMode** (`core/config/mode/app_mode.dart`) — flags: `devMobile`, `prodWeb`, `devDebugMobile`, etc.
- **AppDeviceInfo** — via `getIt<AppDeviceInfo>()` for OS, version, device name
- **CurrentPlatform** (`core/config/platform/platform.dart`) — `isMobile`, `isDesktop`, `isWeb`, `handle<T>()`
- Never assume mobile-only APIs (`dart:io` Platform, GPS, filesystem) — guard with AppMode/CurrentPlatform

### Flutter Commands
Always use `fvm flutter` instead of `flutter` (e.g., `fvm flutter build`, `fvm flutter pub get`).

### Critical
- **No tests** — never generate test code unless explicitly asked
- **Reuse** existing widgets (AppButton, TextFormField, CustomSnackbar, etc.) before creating new ones
- **Match** existing conventions exactly — no new patterns
- **Dart 3** — sealed classes, switch expressions, records, pattern matching, destructuring, dot shorthands (use `.value` instead of `Enum.value`), initializing formals (`MyClass({required this._field})`). Never use experimental primary constructors.
- **No** over-engineering, fake helpers, print debugging, or obvious comments. NEVER use raw `print()`, always use `Printer.print` or `Printer.log` from `onyx_todo`.
- **SafeContext** — in callbacks and async gaps, use `safePop()`, `safePush()`, `safeGo()`, `readIfMounted()`, `safeShowSnackBar()` from `core/extension/context_extensions.dart`
- **BLoC Reading** — Always use typed `BuildContext` extension getters (e.g. `context.sidebarCubit`) and store in a local variable (`final cubit = context.sidebarCubit;`) to avoid redundant $O(N)$ tree lookups
- **State Failure Copy** — In any state `copyWith`, always declare `Failure? Function()? failure` and assign `failure: failure.copy`. Pass `failure: () => failure` in cubit failures, and omit `failure` on success/neutral emissions so `failure.copy` resets errors cleanly
- **Image Picking & Multipart Uploads** — Always use `context.pickSingleImage()` / `context.pickSingleImageCompressed()` / `context.pickMultipleImages()` from `package:onyx_todo/core/utils/utils.dart` (Camera/Gallery bottom sheet on Mobile, direct file explorer on Web). Use `compressIfNeeded()` for smart threshold-based compression. Always use `await pickedImage.toMultipartFile()` for API uploads to guarantee multi-platform compatibility without `dart:io` crashes.
- **Paginated API Calls** — Always use `executePaginatedApiCall<Model>` from `BaseRepository` for paginated endpoints. Return `FutureBasePagRes<Model>` in remote data sources and `FailureOrPaginated<Model>` in repositories. Never discard `PaginationMeta`, never use deprecated `executePaginationApiCall`, and never use ad-hoc tuples `(List<T>, int)`.
- **Form Pattern** — Two modes: **(1) Integrated** (login, registration, create/edit screens with validation + submit): use `AppForm` + `useAppFormController()`, submit via `formController.submit()`, handle API errors via `formController.handleFailure(failure)`. **(2) Standalone** (search bars, filters, single inputs): use `AppTextField` directly with `controller` + `onChanged`, no `fieldId` needed. See `.agent/rules/form.md`
- **Rule Syncing** — When updating any AI rule or skill, ALWAYS sync all AI config files (`.agent/rules/*.md`, `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `.github/copilot-instructions.md`, `GEMINI.md`, `.instructions.md`, `docs/ai/ai_rules.md`) across `Onyx_Onyxboard`, `onyx_todo`, and `Onyx`
- **Localization & UI Strings** — All user-facing strings must be localized using `easy_localization` in `assets/translation/ar-EG.json` and `assets/translation/en-US.json` (and `ur-PK.json` where applicable). Every string key must be declared as a `static const String` in `AppStrings` (`lib/core/localization/app_strings.dart`) and invoked via `AppStrings.keyName.tr()`. Never hardcode raw string literals in UI widgets.
- **No Private Widget Classes** — Every widget must be a standalone public class in its own dedicated file under an appropriate directory (`lib/core/ui/widgets/...` or `lib/feature/.../presentation/widgets/`). Never declare private widget classes (`class _MyWidget extends StatelessWidget / StatefulWidget`).
- **Flutter Hooks Over StatefulWidget** — For any widget lifecycle needs, text controllers, focus nodes, animations, local state, or debounce timers, ALWAYS use `flutter_hooks` (`HookWidget`, `useTextEditingController`, `useFocusNode`, `useState`, `useEffect`, `useRef`, `useAnimationController`, etc.) instead of regular Flutter `StatefulWidget` / `State<T>`.
- **Dart Generators (`sync*` / `async*`)** — Use generators for lazy collection processing, recursive tree traversal (`yield*`), early-terminating pipelines, and progressive streaming. Never use generators for small static collections or when random-access indexing is required.
- **Single BLoC Consumer / Listener Pattern** — NEVER mount multiple `AppBlocConsumer`, `EntityBlocConsumer`, or active `BlocConsumer`/`BlocListener` widgets listening to the same BLoC/Cubit in the same widget hierarchy. For pure presentation (KPIs, tables, headers), use `BlocBuilder` / `AppBlocBuilder`. For dialogs/forms with local mutation handling, set `enableBaseListener: false`.
- **SubState Direct Status Pattern** — When checking the status of any `SubState<T>` instance, ALWAYS use direct getters (`subState.isLoading`, `subState.isSucceed`, `subState.isFailed`, `subState.isInitial`, `subState.isLoadMore`) or functional pattern matching (`subState.when`, `subState.maybeWhenWidgets`). NEVER access `.state.isLoading`, `.state.isSucceed`, or compare `.state == UiState.*` / `subState.state == SubState.Loading`.
- **Active Clarification & Ambiguity Escalation** — If you are ever confused, encounter ambiguous requirements, or see unknown backend API field schemas during any task, DO NOT guess or assume. Directly ask the user clarifying questions to guarantee quality and precision.

### Stack
State: flutter_bloc Cubit + BaseState | DI: get_it | Routing: go_router | API: Dio + Retrofit + dartz Either | Localization: easy_localization | Maps: Google Maps | Storage: Hive + secure_storage

### Data Flow
Screen → Cubit → Repository → DataSource → API (returns Either<Failure, T>)

### Async Performance
When multiple `await` calls are independent, use `Future.wait` to run them concurrently instead of sequentially. Never parallelize if one call depends on the result of another, or if one is a guard/condition for the other.

For full rules see `.agent/rules/` and `AGENTS.md`.




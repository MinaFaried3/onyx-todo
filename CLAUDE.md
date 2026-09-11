# Claude Code — Raad Driver

You are a senior Flutter engineer on this team. Write human production code.

## Project

Raad Driver — Flutter driver app for "Speed Service App". Feature-first Clean Architecture. ~226 Dart files.

## Golden Rules

1. **No tests** — never add testing code unless explicitly asked
2. **Reuse over create** — search existing widgets, models, services first
3. **Match existing style** — conventions > best-practice ideals
4. **Dart 3** — use sealed classes, switch expressions, records, pattern matching, destructuring, dot shorthands (use `.value` instead of `Enum.value`), initializing formals (`MyClass({required this._field})`). Never use experimental primary constructors.
5. **No over-engineering** — write what's needed, nothing more
6. **No Private Widget Classes** — every widget must be a standalone public class in its own dedicated file under an appropriate directory (`lib/core/ui/widgets/...` or `lib/feature/.../presentation/widgets/`). Never declare private widget classes (`class _MyWidget extends StatelessWidget / StatefulWidget`).
7. **Flutter Hooks Over StatefulWidget** — for any widget lifecycle needs, text controllers, focus nodes, animations, local state, or debounce timers, ALWAYS use `flutter_hooks` (`HookWidget`, `useTextEditingController`, `useFocusNode`, `useState`, `useEffect`, `useRef`, `useAnimationController`, etc.) instead of regular Flutter `StatefulWidget` / `State<T>`.
8. **Dart Generators (`sync*` / `async*`)** — use generators for lazy sequences, recursive tree traversal (`yield*`), early-terminating pipelines, and progressive streaming. Never use generators for small static collections or when random-access indexing (`[i]`, `.length`) is required.
9. **Single BLoC Consumer / Listener Pattern** — NEVER mount multiple `AppBlocConsumer`, `EntityBlocConsumer`, or active `BlocConsumer`/`BlocListener` widgets listening to the same BLoC/Cubit in the same widget hierarchy. For pure presentation (KPIs, tables, headers), use `BlocBuilder`. For dialogs/forms with local mutation handling, set `enableBaseListener: false`.
10. **Active Clarification & Ambiguity Escalation** — If you are ever confused, encounter ambiguous requirements, or see unknown backend API field schemas during any task, DO NOT guess or assume. Directly ask the user clarifying questions to guarantee quality and precision.
11. **SubState Direct Status Pattern** — When checking the status of any `SubState<T>` instance, ALWAYS use direct getters (`subState.isLoading`, `subState.isSucceed`, `subState.isFailed`, `subState.isInitial`, `subState.isLoadMore`) or functional pattern matching (`subState.when`, `subState.maybeWhenWidgets`). NEVER access `.state.isLoading`, `.state.isSucceed`, or compare `.state == UiState.*` / `subState.state == SubState.Loading`.

## Architecture

```
feature/ → data/ (sources, models, repos) + presention/ (cubits, screens)
core/ → network, DI (get_it), navigation (go_router), UI (theme, widgets)
```

Data flow: Screen → Cubit → Repository → DataSource → Dio/Retrofit → Either<Failure, T>

## Key Patterns

| Concern | How |
|---|---|
| State | flutter_bloc Cubit + BaseState (UiState: initial/loading/succeed/failed) |
| SubState | Direct getters (`subState.isLoading`, `subState.isSucceed`, `subState.when()`), never `.state.isLoading` |
| DI | get_it — lazySingletons for services, factories for cubits |
| Routing | go_router typed routes + route guards (AuthGuard, GuestGuard) |
| API | Dio + Retrofit + BaseRepository template methods |
| Errors | sealed class Failure + fpdart Either |
| Localization | easy_localization + AppStrings constants (ar-EG / en-US / ur-PK) |
| Theme | ThemeManager + color/font/values managers |
| Storage | Hive + flutter_secure_storage |
| Maps | Google Maps + Places/Routes/Geocoding APIs |
| Async | Use `Future.wait` for independent parallel awaits, never sequential for unrelated calls |
| SafeContext | Use `safePop()`, `safePush()`, `safeGo()`, `readIfMounted()`, `safeShowSnackBar()` in callbacks/async gaps — import from `core/extension/context_extensions.dart` |
| BLoC Reading | Always access BLoCs via typed getter extension (e.g. `context.sidebarCubit`) and store in local variable (`final cubit = context.sidebarCubit;`) at top of `build()` |
| Failure Copy | In `copyWith`, declare `Failure? Function()? failure` and assign `failure: failure.copy`. Pass `failure: () => failure` on cubit error emissions |

## Platform Awareness

Every solution **must work on web, Android, and iOS**. Use these utilities:

| Concern | Source |
|---|---|
| Environment/platform flags | `AppMode` from `core/config/mode/app_mode.dart` (`devMobile`, `prodWeb`, `devDebugMobile`, etc.) |
| Device info (OS, version, name) | `getIt<AppDeviceInfo>()` from `core/utils/app_device_info/app_device_info.dart` |
| Platform enum dispatch | `CurrentPlatform` from `core/config/platform/platform.dart` (`isMobile`, `isDesktop`, `isWeb`, `handle<T>()`) |

**Never assume mobile-only APIs** (e.g., `dart:io` Platform, GPS, local file system) — always guard with `AppMode` or `CurrentPlatform` checks. See `test/core/config/platform/platform_test.dart` for testing patterns.

## Strict No-Nos

- No tests unless asked
- No new architecture patterns
- No fake utilities or helpers
- No rewriting unrelated code
- No comments explaining obvious code
- **BLoC Reading** — Always use typed `BuildContext` extension getters (e.g. `context.sidebarCubit`) and store in a local variable (`final cubit = context.sidebarCubit;`) to avoid redundant $O(N)$ tree lookups
- **SubState Direct Status** — Always use `subState.isLoading`, `subState.isSucceed`, etc. NEVER chain `.state.isLoading` or compare `.state == UiState.*`
- **State Failure Copy** — In any state `copyWith`, always declare `Failure? Function()? failure` and assign `failure: failure.copy`. Pass `failure: () => failure` in cubit failures, and omit `failure` on success/neutral emissions so `failure.copy` resets errors cleanly
- **Image Picking & Multipart Uploads** — Always use `context.pickSingleImage()` / `context.pickSingleImageCompressed()` / `context.pickMultipleImages()` from `package:onyx_todo/core/utils/utils.dart` (Camera/Gallery bottom sheet on Mobile, direct file explorer on Web). Use `compressIfNeeded()` for smart threshold-based compression. Always use `await pickedImage.toMultipartFile()` for API uploads to guarantee multi-platform compatibility without `dart:io` crashes.
- **Paginated API Calls** — Always use `executePaginatedApiCall<Model>` from `BaseRepository` for paginated endpoints. Return `FutureBasePagRes<Model>` in remote data sources and `FailureOrPaginated<Model>` in repositories. Never discard `PaginationMeta`, never use deprecated `executePaginationApiCall`, and never use ad-hoc tuples `(List<T>, int)`.
- **Form Pattern** — Two modes: **(1) Integrated** (login, registration, create/edit screens with validation + submit): use `AppForm` + `useAppFormController()`, submit via `formController.submit()`, handle API errors via `formController.handleFailure(failure)`. **(2) Standalone** (search bars, filters, single inputs): use `AppTextField` directly with `controller` + `onChanged`, no `fieldId` needed. See `.agent/rules/form.md`
- **Rule Syncing** — When updating any AI rule or skill, ALWAYS sync all AI config files (`.agent/rules/*.md`, `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `.github/copilot-instructions.md`, `GEMINI.md`, `.instructions.md`, `docs/ai/ai_rules.md`) across `Onyx_Onyxboard`, `onyx_todo`, and `Onyx`
- No print debugging
- No hardcoded strings/colors/spacing
- No generic variable names (data, item, value)

## Before You Write

1. Check `.agent/rules/` for detailed guidance per topic
2. Scan surrounding files for conventions
3. Search for existing implementations to reuse
4. Ask: "Would a senior dev on this team write this?"

## Flutter Commands

Always use `fvm flutter` instead of `flutter` (e.g., `fvm flutter build apk`, `fvm flutter pub get`, `fvm flutter analyze`).

## Tool Limits

- Claude Code has no hard limit on CLAUDE.md size — be thorough but concise
- Keep individual responses focused and minimal
- NEVER use raw `print()`. Always use `Printer.print` or `Printer.log` from `onyx_todo`
- Never hardcode user-facing strings; always use `AppStrings.*.tr()`




# Forbidden Patterns

## NEVER

- Create fake/mock helper methods, utilities, or extensions that don't exist in the project
- Add unused code, dead code, or speculative code ("we might need this later")
- Introduce new architectural patterns (no UseCase layer, no Provider, no Riverpod)
- Rewrite working code for stylistic preferences
- Add tests or test infrastructure unless explicitly asked
- Add TODO, FIXME, HACK comments — either do it or leave it out
- Use raw `print()` for debugging — always use `Printer.print` or `Printer.log` from `onyx_todo` to clearly identify the source of printed logs and NEVER use raw `print()`
- Add comments stating the obvious (`// increments counter`)
- Generate mock implementations, stubs, or fake data sources unless requested
- Invent APIs, classes, functions, or files that don't exist
- Declare private widget classes (`class _MyWidget extends StatelessWidget / StatefulWidget`) or nest widgets within another widget's file — every widget must be a standalone public class in its own dedicated file
- Use boilerplate `StatefulWidget` / `State<T>` when `HookWidget` (`flutter_hooks`) can handle lifecycle, controllers, focus nodes, animations, local state, or timers with automatic resource disposal and zero memory leaks
- Access `.state.isLoading` or compare `.state == UiState.*` / `subState.state == SubState.Loading` on any `SubState` instance — always use direct getters (`subState.isLoading`, `subState.isSucceed`, `subState.isFailed`, `subState.isInitial`, `subState.isLoadMore`) or functional pattern matching (`subState.when`, `subState.maybeWhenWidgets`)

## Do NOT

- Change files unrelated to the task
- Rename stable public APIs or established class names
- Modify the architecture or folder structure
- Add packages to `pubspec.yaml` without checking if an existing one covers the need
- Create `utils.dart` or `helpers.dart` files — find the right existing home

## Testing

- **Never add tests unless the user explicitly asks for them**
- This includes unit tests, widget tests, integration tests, and test infrastructure
- When not asked for tests, focus solely on production code
- Exception: if you're fixing a bug and the fix is non-trivial, mention that tests would be valuable but don't add them unprompted

## Primary Constructors (Experimental — Do Not Use)

- **Never use experimental primary constructors** — the syntax `class Foo({params})` or `class Foo extends Bar({params})` is NOT supported by the current Dart SDK without an experiment flag. Always write a regular constructor with `this.` initializing formals instead.
- ❌ `class NavigationServiceImpl({required final GoRouter _router, ...})`
- ✅ `class NavigationServiceImpl { final GoRouter _router; NavigationServiceImpl({required this._router, ...}); }`

## Dart 3 Anti-Patterns

- Don't overuse Records — if a class has meaningful behavior, make it a class
- Don't use `!` (null assertion) when pattern matching or null-aware access works
- Don't use `dynamic` when `sealed class` + pattern matching is clearer
- Don't use `late` when constructor initialization or lazy getter works
- Don't add `part` files except for generated code (`.g.dart`)

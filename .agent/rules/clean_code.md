# Clean Code Rules

Write code like a senior engineer with 10+ years of experience on this team.

## Naming

- Use meaningful, domain-based names, never `data`, `item`, `value`, `obj`, `temp`
- Name things by what they are in the business domain, not their generic type

## Functions

- Small, focused, single responsibility
- Predictable inputs/outputs
- Prefer early returns
- Use arrow syntax for simple one-liners
- Keep under 20 lines where practical

## Dart 3 Features (use them)

- `Switch expressions` over if-else chains — exhaustive, no `break` needed
- `Records` for returning lightweight compound values from private helpers
- `Pattern matching` with `if-case` and `switch` for type/null checks
- `Sealed classes` for domain models (failures, states, results)
- `Enhanced enums` with members instead of helper functions
- `Dot shorthands` for enums and static members (e.g., use `.type` instead of `EnumName.type` when context allows)
- `Initializing formals for private fields` (e.g., use `MyClass({required this._field})` instead of `: _field = field`)
- `Destructuring` for `Future.wait` results — never use array index access like `results[0]`
- `SubState Direct Getters & Pattern Matching` (`subState.isLoading`, `subState.isSucceed`, `subState.isFailed`, `subState.when(...)`) instead of accessing `.state.isLoading` or `.state == UiState.*`

```dart
// Good — SubState direct getters
if (state.routeState.isLoading) return const LoadingIndicator();
if (state.currentLocationState.isSucceed) drawMarker(state.currentLocationState.data);

// Bad — chaining .state or enum comparison
if (state.routeState.state.isLoading) ... // ❌
if (state.routeState.state == UiState.loading) ... // ❌

// Good — destructuring Future.wait
final [token, isLoggedIn] = await Future.wait([
  getToken(),
  getBool(PrefKeys.isLoggedIn),
]);

// Bad — array index access
final results = await Future.wait([getToken(), getBool(PrefKeys.isLoggedIn)]);
final token = results[0] as String;

// Good — switch expression over if-else
final padding = switch (width) {
  < 600  => const EdgeInsets.all(16),
  < 1200 => const EdgeInsets.all(24),
  _      => const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
};

// Good — type pattern switch instead of runtimeType
switch (data) {
  case String s:  await _hiveBox.put(key, s);
  case int i:     await _hiveBox.put(key, i);
  default:        await _hiveBox.put(key, data);
}

// Good — if-case for safe type extraction
final lang = _hiveBox.get(PrefKeys.lang);
if (lang case String s when s.isNotEmpty) return s;

// Good — record destructuring for compound assignments
final (icon, color) = switch (action) {
  final a when a.contains('PUSH') => ('=>', ConsoleColor.green),
  _                               => ('*', ConsoleColor.cyan),
};
```

## Avoid

- Over-abstraction (don't create classes "just in case")
- Dead code, speculative code, commented-out code
- Utility classes that just move code around
- Generic "helper" or "utils" files
- Inline magic numbers or hardcoded strings
- Overly perfect AI-looking code — write realistic production code

## Comments

- NO comments that explain obvious code
- NO `// This function does X`
- NO trailing comments
- Only comment when the WHY is non-obvious

## Before Shipping

Ask yourself: **"Would a senior developer on this team actually write this?"**
If the answer is no, rewrite it.

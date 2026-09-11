# UI Rules

UI must follow the existing design system strictly.

## Design System

- **Theme**: Defined in `core/ui/theme_manager.dart` — use `Theme.of(context)`
- **Colors**: `color_manager.dart` — never hardcode hex values
- **Spacing**: `values_manager.dart` — use existing spacing constants
- **Text Styles**: `styles_manager.dart` + `font_manager.dart`
- **Strings**: `AppStrings` localization keys via `AppStrings.someKey.tr()` — never inline raw user-facing text literals
- **Icons**: via `AppSvg` or existing icon set

## Widget Reuse Priority

Always search existing widgets in `core/ui/widgets/` before building:

1. Buttons, inputs, dialogs, snackbars, bottom sheets
2. Pagination lists, cached network images, error widgets
3. Custom app bars, bottom nav bars, screen wrappers

If the component exists → use it. If it almost fits → extend it. Only build from scratch when nothing fits.

## Layout & Architecture Rules

- **No Private Widget Classes**: Every widget must be a standalone public class declared in its own dedicated file under an appropriate directory (`lib/core/ui/widgets/...` or `lib/feature/.../presentation/widgets/`). NEVER declare private widget classes (`class _MyWidget extends StatelessWidget / StatefulWidget`) or nest widgets within another file.
- **Flutter Hooks Over StatefulWidget**: For any widget lifecycle needs, text controllers, focus nodes, animations, local state, or debounce timers, ALWAYS use `flutter_hooks` (`HookWidget`, `useTextEditingController`, `useFocusNode`, `useState`, `useEffect`, `useRef`, `useAnimationController`, etc.) instead of regular Flutter `StatefulWidget` / `State<T>` to eliminate boilerplate lifecycle code, prevent memory leaks, and guarantee automatic resource disposal.
- Keep `build()` readable — extract sections into dedicated standalone public Widget files
- Avoid nesting > 5 widgets; break into smaller standalone widgets
- Use `const` everywhere possible
- Use `Spacer` / `Space` for flexible spacing rather than fixed padding
- Use `Expanded` and `Flexible` correctly in Row/Column
- Use `ListView.builder` for any list that could have more than ~10 items

## Responsiveness

- Support mobile-first, tablet, and web desktop layouts seamlessly
- Use responsive manager extensions where the project already uses them

## What to Never Do

- Hardcode user-facing strings — always use `AppStrings.someKey.tr()`
- Hardcode colors, padding, or radius — use managers
- Declare private widget classes (`class _MyWidget`) — always extract to dedicated public files
- Use raw `print()` — always use `Printer.print` or `Printer.log` from `onyx_todo`
- Create duplicate UI for similar screens
- Add deeply nested builders (BlocBuilder inside BlocBuilder inside BlocBuilder)
- Use `MediaQuery` directly without responsive extension if one exists
- Add testing code unless explicitly asked

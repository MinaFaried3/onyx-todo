# Flutter Rules

Write production Flutter code like an experienced Flutter developer.

## Code Style

- Prefer `const` constructors everywhere possible
- Keep widget trees shallow — extract when build() exceeds ~50 lines
- Avoid nesting depth > 5 widgets; extract into dedicated public widget files
- Use `composition` over inheritance
- Use `ListView.builder`, `GridView.builder` for all lists
- **No Private Widget Classes**: Every widget must be a standalone public class declared in its own dedicated file under an appropriate directory (`lib/core/ui/widgets/...` or `lib/feature/.../presentation/widgets/`). NEVER declare private widget classes (`class _MyWidget extends StatelessWidget / StatefulWidget`) or nest widgets within another file.
- **Flutter Hooks Over StatefulWidget**: For any widget lifecycle needs, text controllers, focus nodes, animations, local state, or debounce timers, ALWAYS use `flutter_hooks` (`HookWidget`, `useTextEditingController`, `useFocusNode`, `useState`, `useEffect`, `useRef`, `useAnimationController`, etc.) instead of regular Flutter `StatefulWidget` / `State<T>` to eliminate boilerplate lifecycle code, prevent memory leaks, and guarantee automatic resource disposal.

## Architecture Integration

This project uses:
- **Cubit** for state — connect with `BlocBuilder`/`BlocListener`/`AppBlocConsumer`
- **get_it** for DI — access via `di<T>()`
- **go_router** for navigation — use `context.pushNamed()` / `context.pop()`
- **easy_localization** — use `AppStrings.someKey.tr`
- **Existing theme** — use `Theme.of(context)`, never hardcode colors/spacing
- **SafeContext** — use `safePop()`, `safePush()`, `safeGo()`, `readIfMounted()`, `safeShowSnackBar()` in callbacks/async gaps to avoid calling context on unmounted widgets. Import from `core/extension/context_extensions.dart`.

## Platform Awareness

This project targets **web, Android, and iOS**. Never assume mobile-only APIs:

| Need | Tool |
|---|---|
| Check environment (dev/prod) + platform | `AppMode.devMobile`, `AppMode.prodWeb` etc. from `core/config/mode/app_mode.dart` |
| Get device/OS info | `getIt<AppDeviceInfo>()` (abstract interface from `core/utils/app_device_info/app_device_info.dart`) |
| Dispatch per platform | `CurrentPlatform.handle(onMobile: ..., onWeb: ...)` from `core/config/platform/platform.dart` |
| Guard conditional code | `if (CurrentPlatform.isMobile) ...` / `if (CurrentPlatform.current.isWeb) ...` |

**Never use `dart:io` Platform, `UniversalPlatform`, or GPS APIs without a `CurrentPlatform` guard.**  
For the test pattern, see `test/core/config/platform/platform_test.dart`.

## Reuse Before Build

Always search existing widgets before creating new ones:
- Buttons: `AppButton`, `OutlinedButton`, `LoadingButton`, `CircleButton`
- Input: `TextFormField`, `PinCodeFields`
- Feedback: `CustomSnackbar`, `CustomDialog`, `BottomSheet`
- Layout: `Space`, `AppSvg`, `ConditionalBuilder`
- Navigation: `AppBottomNavBar`, `CustomAppBar`, `ScreenWidget`
- Animations: existing transition widgets
- Lists: `PaginationList`, `HorizontalPaginationList`

If a similar widget exists → extend or reuse it. Do NOT duplicate.

## What to Never Do

- Add unnecessary packages — check `pubspec.yaml` first, existing packages cover most needs
- Add inline `padding: EdgeInsets.all(...)` without using existing spacing constants
- Hardcode user-facing strings — always go through `AppStrings`
- Add testing code unless explicitly asked
- Create custom `build()` methods that rebuild too frequently — be `const`-aware
- Declare private widget classes (`class _MyWidget`) — always extract into standalone dedicated files

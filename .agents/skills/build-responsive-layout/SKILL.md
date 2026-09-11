---
name: build-responsive-layout
description: Instructs the agent on building layouts that adapt perfectly to both mobile devices and web browsers using context extensions, adaptive builders, and responsive visibility widgets.
---

# Build Responsive Layouts

Use this skill when designing user interfaces to ensure that screens, panels, sheets, and dialogs display correctly on all screen resolutions, from narrow mobile screens to wide desktop web browsers.

## When to use this skill
- When building a new page or widget that will run on both mobile and web.
- When implementing multi-column layouts on wide displays.
- When fixing screen overflow or sizing issues on tablets or desktop views.

## Breakpoint References
- **Mobile**: width $\le 600$ dp
- **Tablet**: width $> 600$ dp and width $< 1440$ dp
- **Desktop**: width $\ge 1440$ dp

## Guidelines

### 1. Adaptive Widgets
Use layout-driven builders rather than checking screen width at the top-level build whenever possible:
- **`AdaptiveBuilder`**: Chooses between mobile, tablet, or desktop layout widgets.
- **`AdaptiveVisibility`**: Standard way to hide/show details (e.g., hiding a sidebar on mobile).
- **`AdaptivePadding`**: Varies padding spaces according to screen size.

### 2. Context Extensions
Access responsive metrics using `context`:
- `context.isMobile`, `context.isTablet`, `context.isDesktop`
- `context.sp(double size)`: Responsive font size that also respects the OS text-scaling settings (crucial for accessibility).
- `context.wp(double percent)` / `context.hp(double percent)`: Percentage of viewport width/height.
- `context.responsiveValue<T>(mobile: ..., tablet: ..., desktop: ...)`: Concise inline selection.

### 3. Avoid Hardcoded Sizes
Never use hardcoded pixel widths/heights for large containers or root elements. Wrap columns in `Expanded` or use `ResponsiveExtension` helpers like `context.getWidth()`.

---

## Code Examples

### Example 1: Adaptive Screen Layout (Split Panel)
```dart
import 'package:flutter/material.dart';
import 'package:Onyx_driver/core/ui/responsive/responsive_extension.dart';
import 'package:Onyx_driver/core/ui/responsive/widgets/adaptive_builder.dart';

class MyResponsivePage extends StatelessWidget {
  const MyResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdaptiveBuilder(
        mobile: (context) => const _MobileLayout(),
        tablet: (context) => const _TabletLayout(),
        desktop: (context) => const _DesktopLayout(),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        _HeaderSection(),
        _MainContent(),
      ],
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(flex: 3, child: _MainContent()),
        VerticalDivider(color: Colors.grey.shade300),
        const Expanded(flex: 2, child: _SidebarSection()),
      ],
    );
  }
}
```

### Example 2: Font & Value Responsiveness
```dart
@override
Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(
      context.responsiveValue(mobile: 12.0, tablet: 16.0, desktop: 24.0),
    ),
    child: Text(
      'Responsive Text',
      style: TextStyle(
        // Scale dynamically and adapt to user text scaling settings
        fontSize: context.sp(16),
      ),
    ),
  );
}
```

## References
- Responsive Extensions: [responsive_extension.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/ui/responsive/responsive_extension.dart)
- Adaptive Builder: [adaptive_builder.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/ui/responsive/widgets/adaptive_builder.dart)
- Adaptive Visibility: [adaptive_Visibility.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/ui/responsive/widgets/adaptive_Visibility.dart)

---
name: add-widget-preview
description: Guides the agent in creating standalone widget previews, mockup screens, and interactive showcases for new UI widgets using mock data, localizations (RTL/LTR), dark/light modes, and responsive breakpoints.
---

# Add Widget Preview

Use this skill when you have created or modified a UI widget and need to build a preview/showcase page or integrate it into a preview flow to visually verify it across different configurations (devices, orientations, themes, locales).

## When to use this skill
- After generating new presentation widgets to verify layout correctness.
- When creating high-fidelity interactive mockups or storybook-like components.
- When you need to isolate a widget from live data/navigation to debug layout or rendering issues.

## Guidelines
1. **Mock Data Isolation**: Avoid using live Cubits or services directly in previews. Pass either plain params, mock data models, or a mocked BLoC state.
2. **Locale & Layout Direction**: Always verify how the widget renders in Arabic (`TextDirection.rtl`) vs English (`TextDirection.ltr`).
3. **Theme Adaptability**: Test the widget in both `Brightness.light` and `Brightness.dark` modes.
4. **Responsive Previewing**: Use the project's `ResponsiveExtension` to show how the widget behaves on Mobile, Tablet, and Desktop screen widths.
5. **No Private Widget Classes**: Every widget must be a standalone public class in its own dedicated file under an appropriate directory. Never declare private widget classes (`class _MyWidget`).
6. **Flutter Hooks Over StatefulWidget**: Use `HookWidget` and `useState` for local preview toggles instead of boilerplate `StatefulWidget`.

## Instructions

### 1. Structure a Widget Preview Wrapper
Create a preview page under `presentation/previews/` or within the widget's package containing:
- Local state hooks for theme/locale toggles.
- Standard mock data generators.

```dart
import 'package:flutter/material.dart';
import 'package:onyx_todo/core/controller/controller_packages.dart';
import 'package:onyx_todo/core/localization/localization_packages.dart';
import 'package:Onyx_driver/core/ui/responsive/responsive_extension.dart';

class MyWidgetPreviewScreen extends HookWidget {
  const MyWidgetPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = useState(false);
    final currentLocale = useState(const Locale('ar', 'EG'));

    void toggleTheme() => isDark.value = !isDark.value;
    void toggleLocale() => currentLocale.value = currentLocale.value.languageCode == 'ar'
        ? const Locale('en', 'US')
        : const Locale('ar', 'EG');

    return Theme(
      data: isDark.value ? ThemeData.dark() : ThemeData.light(),
      child: Localizations.override(
        context: context,
        locale: currentLocale.value,
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Widget Showcase'),
                actions: [
                  IconButton(
                    icon: Icon(isDark.value ? Icons.light_mode : Icons.dark_mode),
                    onPressed: toggleTheme,
                  ),
                  IconButton(
                    icon: const Icon(Icons.language),
                    onPressed: toggleLocale,
                  ),
                ],
              ),
              body: const Center(
                child: MyCustomWidget(),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

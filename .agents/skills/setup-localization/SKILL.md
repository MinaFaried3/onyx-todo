---
name: setup-localization
description: Instructs the agent on adding new localized keys, updating the AppStrings class, modifying the translation JSON files (ar-EG, en-US), and building locale-aware (RTL/LTR) user interfaces.
---

# Setup Localization

Use this skill when adding labels, buttons, messages, errors, or any text that needs to be displayed to users in multiple languages (Arabic, English).

## When to use this skill
- When introducing a new UI component or screen that displays static/dynamic text.
- When adding new error response mappings from API to user-friendly messages.
- When changing existing wording or fixing translation gaps.

## Supported Locales
- **Arabic (`ar-EG`)**: Primary language (RTL layout)
- **English (`en-US`)**: LTR layout

---

## Step-by-Step Workflow for Adding Translations

### 1. Define Key in JSON Translation Files
All static texts reside in `assets/translation/`. You must add the key in **both files**:
- `assets/translation/ar-EG.json`
- `assets/translation/en-US.json`

Ensure the JSON structure is preserved and keys are kept in logical groupings (e.g. `auth`, `validation`, `common`).

*Example in `en-US.json`:*
```json
{
  "welcome_back": "Welcome Back",
  "phone_number": "Phone Number"
}
```

*Example in `ar-EG.json`:*
```json
{
  "welcome_back": "مرحباً بك مجدداً",
  "phone_number": "رقم الهاتف"
}
```

### 2. Update `AppStrings`
Add a static constant in `lib/core/localization/app_strings.dart` mapping exactly to the JSON key:
```dart
abstract class AppStrings {
  // auth
  static const String welcomeBack = 'welcome_back';
  static const String phoneNumber = 'phone_number';
}
```

### 3. Translate in UI Widgets
Import `easy_localization` and translate the string in the build method.
- **Direct String extension**: `AppStrings.welcomeBack.tr`
- **Context translation**: `context.tr(AppStrings.welcomeBack)`

```dart
import 'package:easy_localization/easy_localization.dart';
import 'package:Onyx_driver/core/localization/app_strings.dart';

@override
Widget build(BuildContext context) {
  return Text(
    AppStrings.welcomeBack.tr,
    style: TextStyle(fontSize: context.sp(18)),
  );
}
```

---

## RTL/LTR Considerations

Arabic is a Right-to-Left (RTL) language. 
- Avoid hardcoded left/right paddings or alignment directions. Use `Directional` alternatives:
  - Use `EdgeInsetsDirectional.only(start: 10, end: 15)` instead of `EdgeInsets.only(left: 10, right: 15)`.
  - Use `AlignmentDirectional.centerStart` instead of `Alignment.centerLeft`.
- Query current layout direction via the context extension:
  - `context.isRTL` or `context.isLTR`
- Ensure text alignments adapt correctly by passing `null` or using `TextAlign.start` (which automatically switches according to locale direction).

## References
- App Translation Keys: [app_strings.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/localization/app_strings.dart)
- Translation Asset Files: [assets/translation/](file:///Users/minafaried/StudioProjects/Onyx_driver/assets/translation/)
- Responsive/Directional Extensions: [responsive_extension.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/ui/responsive/responsive_extension.dart)

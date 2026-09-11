---
name: multi-platform-support
description: Enforces web and mobile compatibility guidelines. Instructs the agent on avoiding platform-specific crashes (like importing dart:io on web) by using CurrentPlatform dispatch, AppMode flags, and AppDeviceInfo.
---

# Multi-Platform Support (Mobile and Web)

Use this skill when introducing a new package or writing code that deals with platform-specific APIs (device hardware, file system, operating system queries, or third-party SDK initialization).

## When to use this skill
- When building features requiring device info or platform checks.
- When working with files, camera, GPS, or storage.
- When configuring app behavior that changes in production vs development or web vs mobile.

## Golden Rules
1. **Never import `dart:io` directly in shared files**: Directly importing `Platform` or `File` from `dart:io` causes compilations/runtime crashes on Web. 
2. **Use Universal Libraries**: Use universal packages (e.g. `file_picker` or `image_picker`) that abstract the platform under the hood, or write platform conditional files/imports.
3. **Dispatch via CurrentPlatform**: Use `CurrentPlatform` extensions rather than standard Flutter platform checks.
4. **Use AppMode Flags**: Handle dev/prod mobile and web conditional checks using the static getters in `AppMode`.

---

## Platform Dispatch Utilities

### 1. CurrentPlatform Extension
Use `CurrentPlatform` for static checking or exhaustive platform execution:
- `CurrentPlatform.isMobile` / `CurrentPlatform.isWeb` / `CurrentPlatform.isDesktop`
- `CurrentPlatform.isAndroid` / `CurrentPlatform.isIOS`

Use `CurrentPlatform.handle()` to execute platform-specific code block returns cleanly:
```dart
import 'package:Onyx_driver/core/config/platform/platform.dart';

final apiTimeout = CurrentPlatform.handle<int>(
  onWeb: () => 5000,
  onAndroid: () => 10000,
  onIOS: () => 12000,
  orElse: () => 8000,
);
```

### 2. Environment Flags (AppMode)
Check both environment (dev/prod) and target platform via `AppMode`:
- `AppMode.devMobile`
- `AppMode.prodWeb`
- `AppMode.devDebugMobile`
```dart
import 'package:Onyx_driver/core/config/mode/app_mode.dart';

if (AppMode.prodMobile) {
  // Production-only mobile configuration (e.g., Firebase Performance, Crashlytics)
}
```

### 3. Device Info (AppDeviceInfo)
Never query device parameters from platform native channels directly. Use the DI instance:
```dart
import 'package:Onyx_driver/core/injection/dependency_injection.dart';
import 'package:Onyx_driver/core/utils/app_device_info/app_device_info.dart';

final deviceInfo = getIt<AppDeviceInfo>();
final deviceName = deviceInfo.deviceName;
final osVersion = deviceInfo.deviceVersion;
```

---

## Handling Files Multi-Platform

If you must handle file operations (e.g. upload profile image):
- Avoid `java.io.File` / `dart:io.File` in shared logic.
- Use `PlatformFile` from `file_picker` or store files as raw bytes (`Uint8List`) for memory handling on both Web and Mobile.

```dart
import 'dart:typed_data';

class ImagePayload {
  final Uint8List bytes;
  final String name;

  ImagePayload({required this.bytes, required this.name});
}
```

## References
- CurrentPlatform utility: [platform.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/config/platform/platform.dart)
- AppMode configuration: [app_mode.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/config/mode/app_mode.dart)

### 4. Smart Image Picking & Optional Compression (BuildContext Extension)
Use the `BuildContext` image picking extension directly for effortless, platform-aware image picking and optional threshold compression:
- **Mobile**: Automatically opens a Camera/Gallery selection bottom sheet.
- **Web / Desktop**: Directly opens the native file explorer without modals.
- **Optional Smart Compression**: Use `context.pickSingleImageCompressed()` / `picked.compressIfNeeded()`. Images below threshold (e.g. < 2MB) are left untouched (0 CPU overhead); oversized images are downscaled and compressed uniformly across Web and Mobile.
- **Multipart Upload**: Always convert via `await pickedImage.toMultipartFile()`.

```dart
import 'package:onyx_todo/core/utils/utils.dart';

// 1. Pick a single image (standard or compressed)
final image = await context.pickSingleImage();
final compressed = await context.pickSingleImageCompressed(
  options: const ImageCompressionOptions(maxSizeInBytes: 2 * 1024 * 1024),
);

// 2. Pick multiple images (standard or compressed)
final images = await context.pickMultipleImages();
final compressedImages = await context.pickMultipleImagesCompressed();

// 3. Compress existing PickedImage if needed
final optimized = await image?.compressIfNeeded();

// 4. Upload to API via Dio FormData
if (optimized != null) {
  final formData = FormData.fromMap({
    'file': await optimized.toMultipartFile(),
  });
}
```

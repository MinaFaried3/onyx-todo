# Project Context

**Onyx Driver** — A production Flutter driver app for "Speed Service App".

## Identity

| Attribute | Value |
|---|---|
| Package Name | `glow.Onyx.Onyx_driver` (prod) / `glow.Onyx.Onyx_driver.dev` (dev) |
| Version | `1.0.0+1` |
| SDK | `>=3.11.0` (Dart 3.x) |
| Platforms | Android, iOS, Web |
| Total Dart Files | ~226 |

## Key Architecture Decisions

- **State**: flutter_bloc 9.x (Cubit pattern)
- **DI**: get_it 9.x (service locator)
- **Routing**: go_router 17.x + go_router_builder (typed routes)
- **Networking**: Dio 5.x + Retrofit 4.x + fpdart Either
- **Storage**: Hive + flutter_secure_storage
- **Localization**: easy_localization (ar, en)
- **Backend**: Firebase (Analytics, Crashlytics, Messaging, Remote Config, Performance)
- **Maps**: Google Maps + Places/Routes/Geocoding APIs

## Project Type

This is **NOT**:
- A demo or prototype
- Tutorial code
- An experimental playground
- A greenfield project

This IS:
- Enterprise-scale, long-term maintained
- Multi-developer team project
- Production-critical with real users
- Feature-rich with 226+ Dart files

## Platform Awareness

All features **must work on web, Android, and iOS**. Use platform-aware utilities:

- **`AppMode`** (`core/config/mode/app_mode.dart`) — flags like `devMode`, `prodReleaseMode`, `devMobile`, `devWeb`, `prodMobile`, `prodWeb`, `devDebugMobile`, `devDebugWeb` to conditionally enable/disable features per platform+environment
- **`AppDeviceInfoImpl`** (`core/utils/app_device_info/app_device_info_impl.dart`) — access device info (OS, version, device name, etc.) via the abstract `AppDeviceInfo` interface from DI (`getIt<AppDeviceInfo>()`)
- **`CurrentPlatform`** (`core/config/platform/platform.dart`) — enum-based platform detection: `isMobile`, `isDesktop`, `isWeb`, `handle<T>()` for platform-specific logic

Before writing platform-specific code, check `test/core/config/platform/platform_test.dart` for the testing pattern.

## Priorities

1. **Maintainability** — code must be understandable by the team years from now
2. **Consistency** — match existing patterns even if they're not perfect
3. **Cross-Platform** — all code must work on web, Android, and iOS
4. **Scalability** — new features should slot in without restructuring
5. **Readability** — clear intent over clever solutions
6. **Performance** — optimize when needed, not prematurely

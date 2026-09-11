/// onyx_todo — Main entry point for core primitives.
///
/// Exports core primitives: configuration, enums, extensions, helpers,
/// injection utilities, and localization.
///
/// For feature domains, use direct domain barrels:
/// ```dart
/// import 'package:onyx_todo/core/network/network.dart';                   // networking & API services
/// import 'package:onyx_todo/core/network/network_packages.dart';          // dio, retrofit, etc.
/// import 'package:onyx_todo/core/storage/storage.dart';                   // Hive, SharedPreferences & SecureStorage
/// import 'package:onyx_todo/core/storage/storage_packages.dart';           // hive, secure storage, etc.
/// import 'package:onyx_todo/core/navigation/navigation.dart';               // NavigationService & observers
/// import 'package:onyx_todo/core/navigation/navigation_packages.dart';      // go_router
/// import 'package:onyx_todo/core/ui/ui.dart';                               // widgets, theme & animations
/// import 'package:onyx_todo/core/ui/ui_packages.dart';                      // cached_network_image, svg, etc.
/// import 'package:onyx_todo/core/maps/maps.dart';                             // Google Maps
/// import 'package:onyx_todo/core/maps/maps_packages.dart';                    // google_maps_flutter
/// import 'package:onyx_todo/core/auth/auth.dart';                             // Google & Apple Sign-In
/// import 'package:onyx_todo/core/utils/utils.dart';                          // validators, launcher & device info
/// import 'package:onyx_todo/core/controller/controller.dart';               // BLoC & Cubit state management
/// import 'package:onyx_todo/core/controller/controller_packages.dart';      // bloc, flutter_bloc, equatable
/// import 'package:onyx_todo/core/location/location.dart';                   // location services & permissions
/// import 'package:onyx_todo/core/notification/notification.dart';           // local & FCM notifications
/// import 'package:onyx_todo/core/remote_config/remote_config.dart';          // Firebase Remote Config
/// import 'package:onyx_todo/core/platform_file_ops/platform_file_ops.dart';  // cross-platform file operations
/// ```
library onyx_todo;

// ─── Bootstrap ────────────────────────────────────────────────────────────────
export 'onyx_todo_init.dart';

// ─── Core Domain Barrels ───────────────────────────────────────────────────────
export 'config/config.dart';
export 'enum/enum.dart';
export 'extension/extension.dart';
export 'fp/fp.dart';
export 'helper/helper.dart';
export 'injection/injection.dart';
export 'localization/localization.dart';

// ─── Core Firebase Packages ───────────────────────────────────────────────────
export 'package:firebase_analytics/firebase_analytics.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_crashlytics/firebase_crashlytics.dart';
export 'package:firebase_performance/firebase_performance.dart';

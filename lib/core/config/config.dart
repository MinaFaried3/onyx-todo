/// Core Configurations barrel - App configuration options, security, environments.
///
/// Import this file to access configuration primitives:
/// ```dart
/// import 'package:onyx_todo/core/onyx_todo.dart';
/// ```
library;

// ─── Configurations ───────────────────────────────────────────────────────────
export 'environments/core_config.dart';
export 'environments/environment_config.dart';
export 'environments/firebase_config.dart';
export 'environments/maps_config.dart';
export 'environments/security_config.dart';

// ─── Modes & Platforms ───────────────────────────────────────────────────────
export 'mode/app_mode.dart';
export 'platform/platform.dart';

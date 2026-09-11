/// Dependency Injection barrel - GetIt container & registration modules.
///
/// Import this file to access injection utilities:
/// ```dart
/// import 'package:onyx_todo/core/injection/injection.dart';
/// ```
library;

// ─── Injection Container & Extensions ─────────────────────────────────────────
export 'extensions/get_it_extensions.dart';
export 'injection_container.dart';
export 'instance_name.dart';

// ─── Core DI Modules ──────────────────────────────────────────────────────────
export 'modules/core/app_module.dart';
export 'modules/core/firebase_module.dart';
export 'modules/core/navigation_module.dart';
export 'modules/core/network_module.dart';
export 'modules/core/storage_module.dart';

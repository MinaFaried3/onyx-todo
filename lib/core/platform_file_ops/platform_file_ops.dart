/// Platform File Ops domain barrel - Cross-platform & web file operations.
///
/// Import this file to access platform file operations:
/// ```dart
/// import 'package:onyx_todo/core/platform_file_ops.dart';
/// ```
library;

// ─── Contracts & Locator ──────────────────────────────────────────────────────
export 'core/contracts/device_services_contract.dart';
export 'core/contracts/platform_file_ops_contract.dart';
export 'core/platform_file_ops_stub.dart' hide getPlatformFileOps;
export 'platform_file_ops_locator.dart';

// ─── Web Adapters ─────────────────────────────────────────────────────────────
export 'web/device_services_web_adapter.dart';
export 'web/platform_file_ops_web.dart' hide getPlatformFileOps;
export 'web/web_dom_embedder.dart';
export 'web/web_helpers.dart';

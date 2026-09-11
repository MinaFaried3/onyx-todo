/// Navigation Platform - single export barrel for internal navigation.
///
/// Import this file to access the shared navigation system:
/// ```dart
/// import 'package:onyx_todo/core/navigation/navigation.dart';
/// ```
library;

// Observer
export 'observer/navigation_observer.dart';
export 'observer/request_route_observer.dart';
// Overlay
export 'overlay/overlay_manager.dart';
// Router building
export 'routes/app_router.dart';
export 'routes/builders/route_builder_helper.dart';
// Service
export 'service/navigation_service.dart';
// error
export 'ui/error/router_error_screen.dart';
// UI (Transitions & Widgets)
export 'ui/transitions/app_transitions.dart';
export 'ui/widgets/screen_widget.dart';
export 'ui/widgets/undefined_route_screen.dart';

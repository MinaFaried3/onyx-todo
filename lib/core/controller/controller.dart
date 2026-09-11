/// Controller & State Management barrel - BLoC, Cubit helpers, safe emitters & handlers.
///
/// Import this file to access state management helpers:
/// ```dart
/// import 'package:onyx_todo/core/controller/controller.dart';
/// ```
library;

// ─── BLoC Core & Events ───────────────────────────────────────────────────────
export 'bloc/base_bloc.dart';
export 'bloc/base_event.dart';
export 'bloc/event_transformers.dart';
// ─── Cubit & States ───────────────────────────────────────────────────────────
export 'cubit/base_cubit.dart';
export 'cubit/base_state.dart';
export 'cubit/state_props.dart';
export 'cubit/sub_state.dart';
// ─── BLoC Helpers & Safe Dispatchers ───────────────────────────────────────────
export 'helper/app_bloc_consumer.dart';
export 'helper/app_bloc_selector.dart';
export 'helper/app_error_handler.dart';
export 'helper/bloc_observer.dart';
export 'helper/error_state_actions.dart';
export 'helper/safe_emitter.dart';
export 'helper/safe_request_handler.dart';

/// Networking domain barrel - Dio, Retrofit, repositories, response models, errors & interceptors.
///
/// Import this file to access local networking code:
/// ```dart
/// import 'package:onyx_todo/core/network/network.dart';
/// ```
library;

// ─── API Services & Dio Factory ──────────────────────────────────────────────
export 'api_service/api_service_client.dart';
export 'api_service/base_api_service.dart';
// ─── Utilities & Headers ─────────────────────────────────────────────────────
export 'cache_on_subsequent_calls.dart';
export 'cloud_storage_path.dart';
// ─── Repositories & Data Sources ─────────────────────────────────────────────
export 'data_source/base_remote_data_source.dart';
export 'data_source/local_data_source.dart';
export 'dio_factory/api_type.dart';
export 'dio_factory/dio_constants.dart';
export 'dio_factory/dio_factory.dart';
export 'dio_factory/interceptors/alice_interceptor.dart';
export 'dio_factory/interceptors/auth_interceptor.dart';
export 'dio_factory/interceptors/cancel_token_interceptor.dart';
export 'dio_factory/interceptors/dedup_interceptor.dart';
export 'dio_factory/interceptors/duplicate_request_interceptor.dart';
export 'dio_factory/interceptors/firebase_performance_interceptor.dart';
export 'dio_factory/interceptors/ssl_pinning_interceptor.dart';
// ─── Errors & Failures ────────────────────────────────────────────────────────
export 'error/app_error.dart';
export 'error/app_failures.dart';
export 'error/data_source_status.dart';
export 'error/network_error_handler.dart';
export 'headers_manager.dart';
export 'http_overrides.dart';
export 'network_checker.dart';
export 'repositories/base_repository.dart';
// ─── Request Models ───────────────────────────────────────────────────────────
export 'request/base_query_parameters.dart';
export 'request/delete_item_identifier.dart';
export 'request/filter_condition.dart';
export 'request/update_list_object.dart';
// ─── Pagination Response Models ──────────────────────────────────────────────
export 'response/base_pagination_response/base_pagination_response.dart';
export 'response/base_pagination_response/paginated_list.dart';
export 'response/base_pagination_response/pagination_meta.dart';
// ─── Response Models ──────────────────────────────────────────────────────────
export 'response/base_response/base_response.dart';
export 'response/base_response/cache_response.dart';
export 'response/base_response/cache_state.dart';
export 'response/base_response/error_response.dart';
export 'response/base_response/response_meta.dart';
// ─── Services ────────────────────────────────────────────────────────────────
export 'services/cancel_request_service.dart';
export 'services/jwt_verification_service.dart';
export 'services/login_service.dart';
export 'services/pwned_password_checker.dart';
export 'services/ssl_pinning_service.dart';
export 'services/token_service.dart';
// ─── Real-Time (WebSocket & SSE) ─────────────────────────────────────────────
export 'realtime/realtime.dart';


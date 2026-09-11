---
name: networking-and-api-service
description: Guides the agent on implementing API integrations: adding routes to EndPointsManager, declaring methods in ApiServiceClient with Retrofit, implementing remote data sources, and using BaseRepository templates.
---

# Networking and API Service Layer

Use this skill when adding new API requests, integrating third-party endpoints, or updating the network data service layer of the application.

## When to use this skill
- When integrating a new backend feature that requires network requests.
- When adding headers, query parameters, path variables, or body payloads to Retrofit clients.
- When designing repositories that handle exceptions and return `Either<Failure, T>`.

## Directory Overview
- **Endpoints**: `lib/core/network/end_points_manager.dart`
- **Retrofit Client**: `lib/core/network/api_service/api_service_client.dart`
- **Base Repository Templates**: `lib/core/network/repositories/base_repository.dart`
- **Error Mappings**: `lib/core/network/error/network_error_handler.dart`

---

## Instructions

### Step 1: Centralize Endpoints in `EndPointsManager`
Always declare endpoints as static constants:
```dart
abstract class EndPointsManager {
  static const String myNewEndpoint = '/feature-name/get-details';
}
```

### Step 2: Declare Route in `ApiServiceClient`
Open `lib/core/network/api_service/api_service_client.dart` and add the Retrofit declaration. Always wrap API responses in generic response classes (`DataResponse`, `ItemResponse`, etc.) to match the backend structure:
- `DataResponse<T>`: Single data object
- `ItemsResponse<T>`: List of items
- `PaginationResponse<T>`: Paginated items

```dart
@POST(EndPointsManager.myNewEndpoint)
Future<DataResponse<MyFeatureResponse>> myNewEndpointMethod({
  @Body() required Map<String, dynamic> body,
});
```

*Note: After editing this file, always run `flutter pub run build_runner build --delete-conflicting-outputs` to regenerate the Retrofit client implementation.*

### Step 3: Implement Remote DataSource
The remote data source is responsible for invoking the client directly:
```dart
abstract class FeatureRemoteDataSource {
  Future<DataResponse<MyFeatureResponse>> getFeatureData(Map<String, dynamic> body);
}

class FeatureRemoteDataSourceImpl implements FeatureRemoteDataSource {
  final ApiServiceClient _apiClient;
  FeatureRemoteDataSourceImpl(this._apiClient);

  @override
  Future<DataResponse<MyFeatureResponse>> getFeatureData(Map<String, dynamic> body) {
    return _apiClient.myNewEndpointMethod(body: body);
  }
}
```

### Step 4: Implement Repository with `BaseRepository`
Repositories must extend `BaseRepository` and invoke execution templates. These templates verify network connection, catch all Dio exceptions, map them to standard `Failure` classes, and return `Either<Failure, T>`:

- Use `executeApiCall` for `FutureBaseRes` (returns `response.data`).
- Use `executeBaseResponseCall` when the raw `BaseResponse` object itself is returned.
- Use `executePaginatedApiCall` for paginated endpoints (returns `PaginatedList<T>` containing `items` and `PaginationMeta`).

```dart
import 'package:onyx_todo/core/onyx_todo.dart';
import 'package:Onyx_driver/core/network/error/app_failures.dart';
import 'package:Onyx_driver/core/network/repositories/base_repository.dart';
import 'package:fpdart/fpdart.dart';

class FeatureRepositoryImpl extends BaseRepository implements FeatureRepository {
  final FeatureRemoteDataSource _remoteDS;
  final NetworkChecker _networkChecker;
  final LocalDataSource _localDS;

  FeatureRepositoryImpl(this._remoteDS, this._networkChecker, this._localDS);

  @override
  BaseRemoteDataSource get remoteDataSource => _remoteDS;

  @override
  NetworkChecker get networkChecker => _networkChecker;

  @override
  LocalDataSource get localDataSource => _localDS;

  @override
  Future<Either<Failure, MyFeatureResponse>> getFeatureData(MyRequestParams params) {
    return executeApiCall<MyFeatureResponse>(
      apiCall: () => _remoteDS.getFeatureData(params.toJson()),
    );
  }
}
```

## References
- Base Repository: [base_repository.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/network/repositories/base_repository.dart)
- Retrofit Client: [api_service_client.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/network/api_service/api_service_client.dart)
- Endpoint Manager: [end_points_manager.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/network/end_points_manager.dart)
- Error Handler: [network_error_handler.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/network/error/network_error_handler.dart)

### Step 5: Multipart & Image Uploads (Context Extension & Compression)
When uploading images or files via multipart/form-data:
- Pick via `context.pickSingleImage()` or `context.pickSingleImageCompressed()`.
- Supports threshold-based compression (`picked.compressIfNeeded()`) avoiding oversized payload uploads.
- Converts seamlessly to `MultipartFile` using `await picked.toMultipartFile()`.
- **Never** use `MultipartFile.fromFile(path)` directly in shared code as it crashes on Flutter Web; `PickedImage.toMultipartFile()` uses in-memory bytes safely.

```dart
import 'package:onyx_todo/core/utils/utils.dart';
import 'package:dio/dio.dart';

Future<void> uploadAvatar(BuildContext context) async {
  final picked = await context.pickSingleImageCompressed();
  if (picked != null) {
    final formData = FormData.fromMap({
      'avatar': await picked.toMultipartFile(),
    });
    // Send formData via repository / api service
  }
}
```

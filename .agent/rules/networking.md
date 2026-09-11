# Networking Rules

Use the existing API layer — never work around it.

## Architecture

- All API calls go through `DioApiService` (or Retrofit client)
- Data sources extend `BaseRemoteDataSource`
- Repositories extend `BaseRepository` and use `executeApiCall<T>()`, `executePaginatedApiCall<T>()`, `executeBaseResponseCall<T>()`, etc.
- Responses are always wrapped in `Either<Failure, T>`
- Errors flow through `ErrorHandler` → `Failure` → Cubit state

## Rules

- Use existing `EndPointsManager` for all endpoint strings — never hardcode URLs
- Use existing response models (`BaseResponse`, `BasePaginationResponse`, `PaginatedList`, `PaginationMeta`, etc.)
- Use existing error types from the `Failure` sealed hierarchy
- **Paginated API Calls**: Always use `executePaginatedApiCall<Model>` from `BaseRepository` for paginated endpoints. Remote data sources must return `FutureBasePagRes<Model>` (`Future<BasePaginationResponse<Model>>`), and repositories must return `FailureOrPaginated<Model>` (`FailureOr<PaginatedList<Model>>`). Never discard `PaginationMeta` or use ad-hoc tuples `(List<T>, int)`.
- **Non-Paginated API Calls**: Return `FutureBaseRes<List<T>>` / `FailureOrList<T>` (or single models with `FutureBaseRes<T>` / `FailureOr<T>`).
- Add new models in the feature's `data/model/` directory with `json_serializable`
- Run `dart run build_runner build --delete-conflicting-outputs` after adding models

## Dart 3

Use `sealed class Failure` (already in the project) for exhaustive error handling.
Use `Switch expressions` when mapping errors to user messages.

- **Multipart & Image Uploads**: Always pick images via `AppImagePickerService.instance` and convert to `MultipartFile` via `await pickedImage.toMultipartFile()`. Never use `MultipartFile.fromFile(path)` directly to ensure full Web & Mobile compatibility.

## Strict Don'ts

- Never parse JSON in UI or Cubit — always use typed models
- Never hardcode endpoints — use `EndPointsManager`
- Never add duplicate model classes for the same API response
- Never bypass the repository layer (no calling data sources from Cubits)
- Never use `executePaginationApiCall` or ad-hoc tuples `(List<T>, int)` for pagination — always use `executePaginatedApiCall` and `PaginatedList<T>`
- Never add `print()` for network debugging — use the existing Dio logger interceptor
- Never add testing for API/repository code unless explicitly asked

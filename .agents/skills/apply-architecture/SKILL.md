---
name: apply-architecture
description: Enforces feature-first Clean Architecture pattern in the codebase. Guides the creation of new features across all layers: data sources, models, repositories, cubits, state management, DI registration, and presentation screens.
---

# Apply Architecture and Best Practices

Use this skill when implementing a new feature or refactoring existing logic in the codebase to ensure layer separation, dependency injection, and data flow patterns are correctly applied.

## When to use this skill
- When creating a new feature folder under `lib/feature/`.
- When adding new network calls, repository methods, or cubits.
- When registering dependencies inside `lib/core/injection/dependency_injection.dart`.

## Core Architectural Rules
1. **Layer Separation**: Code must be split into `data/` and `presention/` within the feature. No business logic in UI; no UI imports in Data layer.
2. **Inward Dependencies**: UI classes depend on Cubits. Cubits depend on Repositories. Repositories depend on DataSources. DataSources call APIs.
3. **Functional Error Handling**: Repositories must return `Future<Either<Failure, T>>` (from `fpdart`), catching exceptions and converting them to `Failure` subtypes.
4. **State Structure**: All states must extend `BaseState` and use the `UiState` enum.
5. **No Direct Repo Calls**: The presentation layer (screens/widgets) must never invoke repositories directly.

## Instructions

### Step-by-Step Feature Implementation Flow

```
1. Create Directories → 2. Create Models & DTOs → 3. Implement DataSource & API Client → 4. Implement Repository → 5. Register in DI → 6. Create Cubit & States → 7. Build Presentation Widgets/Screens
```

#### Step 1: Feature Folders
Create the standard folder structure:
```
lib/feature/my_feature/
├── data/
│   ├── data_source/
│   │   ├── my_feature_remote_ds.dart
│   │   └── my_feature_remote_ds_impl.dart
│   ├── model/
│   │   ├── my_feature_request.dart
│   │   └── my_feature_response.dart
│   └── repo/
│       └── my_feature_repo.dart
└── presention/
    ├── controller/
    │   └── my_feature_cubit/
    │       ├── my_feature_cubit.dart
    │       └── my_feature_state.dart
    └── view/
        ├── screens/
        └── widgets/
```

#### Step 2: DTOs & Serialization
Create JSON models with `@JsonSerializable(fieldRename: FieldRename.snake)`. See `implement-json-serialization` skill.

#### Step 3: Remote DataSource
Declare interfaces first, then concrete implementations:
```dart
abstract class MyFeatureRemoteDataSource {
  Future<DataResponse<MyFeatureResponse>> fetchData(MyFeatureRequest params);
}

class MyFeatureRemoteDataSourceImpl implements MyFeatureRemoteDataSource {
  final ApiServiceClient _apiClient;
  MyFeatureRemoteDataSourceImpl(this._apiClient);

  @override
  Future<DataResponse<MyFeatureResponse>> fetchData(MyFeatureRequest params) {
    return _apiClient.fetchData(params.toJson());
  }
}
```

#### Step 4: Repository
Extend `BaseRepository` to gain helper execution templates that handle connection-checking and `DioException` error mapping:
```dart
class MyFeatureRepository extends BaseRepository {
  final MyFeatureRemoteDataSource _dataSource;
  MyFeatureRepository(this._dataSource);

  Future<Either<Failure, MyFeatureResponse>> getFeatureData(MyFeatureRequest params) {
    return executeBaseResponseCall(() => _dataSource.fetchData(params));
  }
}
```

#### Step 5: DI Registration
Add entries to `lib/core/injection/dependency_injection.dart`:
```dart
// Data Sources
di.registerLazySingleton<MyFeatureRemoteDataSource>(
  () => MyFeatureRemoteDataSourceImpl(di()),
);

// Repositories
di.registerLazySingleton<MyFeatureRepository>(
  () => MyFeatureRepository(di()),
);

// Cubits
di.registerFactoryCubit<MyFeatureCubit, MyFeatureState>(
  () => MyFeatureCubit(di()),
);
```

#### Step 6: Cubit & States
Create state class extending `BaseState` and the Cubit handling asynchronous execution safely. See `cubit-state-management` skill.

## References
- Architectural Core Rules: [architecture.md](file:///Users/minafaried/StudioProjects/Onyx_driver/.agent/rules/architecture.md)
- Dependency Injection Manager: [dependency_injection.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/injection/dependency_injection.dart)
- Base Repository: [base_repository.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/network/repositories/base_repository.dart)
- State Management Docs: [state-management.md](file:///Users/minafaried/StudioProjects/Onyx_driver/docs/state-management.md)

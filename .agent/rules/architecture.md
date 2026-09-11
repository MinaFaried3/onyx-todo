# Architecture Rules

Project architecture is STRICT. This is a feature-first Clean Architecture Flutter app.

## Layer Structure

Each feature follows:
```
feature/
  data/          # Data sources, models (json_serializable), repositories
  presention/    # Cubits, screens, widgets
```

Shared infrastructure lives in `core/` (network, DI, navigation, UI, storage, maps, etc.)

## Data Flow

```
Screen → Cubit → Repository → RemoteDataSource → API (Dio/Retrofit)
                    ↓
              Either<Failure, T>
                    ↓
             Cubit emits BaseState
                    ↓
             Screen rebuilds
```

## Strict Rules

- UI never calls repositories directly — always through a Cubit
- Business logic never lives in widgets
- API calls never happen inside Cubits — always through repositories
- Repositories always extend `BaseRepository` and return `Either<Failure, T>`
- Models use `json_serializable` with `@JsonSerializable(fieldRename: FieldRename.snake)`
- Cubits extend `Cubit<State>` where State extends `BaseState`
- Dependencies point inward: UI → Cubit → Repository → DataSource

## Dart 3 Conventions

- Use `sealed class` for failure/state hierarchies (exhaustive matching)
- Use `Switch expressions` for exhaustive state handling
- Use `Records` for returning multiple values from private helpers when a class is overkill
- Use `Pattern matching` in switch statements for type dispatch
- Use `Enhanced enums` with members/methods where appropriate

## What to Never Do

- Mix layers (e.g., API calls in widgets)
- Create new architectural patterns
- Add UseCase layer unless the existing project already uses it (it doesn't)
- Introduce Clean Architecture beyond what's already established
- Add testing unless explicitly asked

---
name: implement-json-serialization
description: Instructs the agent on implementing JSON serialization using json_serializable and Equatable. Details naming conventions, custom JSON key mappings, enum serialization, and build_runner commands.
---

# Implement JSON Serialization

Use this skill when defining request parameters or response payload objects (DTOs) that need to be parsed from or serialized to JSON.

## When to use this skill
- When creating a new endpoint model or response wrapper in `lib/feature/[feature_name]/data/model/`.
- When modifying JSON payload shapes or updating database-like cache storage payloads.
- When creating custom query params or request bodies for Retrofit API calls.

## Guidelines
1. **Always inherit from `Equatable`**: Make all models value-equatable so that they can be easily compared in test cases or state rebuild cycles.
2. **Explicit Snake Case Mapping**: Annotate JSON fields explicitly using `@JsonKey(name: 'fieldName')` to map Dart's camelCase variables to API's snake_case.
3. **Write Part Directives**: Add `part '[filename].g.dart';` below your imports.
4. **Use Safe Constructors**: Define immutable fields (`final`) and include them in the const constructor.
5. **Code Generation**: Always run build_runner to generate the corresponding serializer logic.

---

## Model Template Structure

```dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_model.g.dart';

@JsonSerializable()
class MyModel extends Equatable {
  final String id;
  @JsonKey(name: 'display_name')
  final String displayName;
  @JsonKey(name: 'is_active')
  final bool isActive;

  const MyModel({
    required this.id,
    required this.displayName,
    required this.isActive,
  });

  // Factory constructor for JSON decoding
  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);

  // Method for JSON encoding
  Map<String, dynamic> toJson() => _$MyModelToJson(this);

  @override
  List<Object?> get props => [id, displayName, isActive];
}
```

---

## Handling Custom Types / Enums

If a field uses a custom class or enum (e.g. `Gender`), use `fromJson` and `toJson` attributes on the `@JsonKey` annotation to define static mapping functions:

```dart
enum UserRole { admin, driver, guest }

UserRole _roleFromJson(String val) => UserRole.values.byName(val);
String _roleToJson(UserRole role) => role.name;

@JsonSerializable()
class UserProfile extends Equatable {
  @JsonKey(
    name: 'role',
    fromJson: _roleFromJson,
    toJson: _roleToJson,
  )
  final UserRole role;

  const UserProfile({required this.role});
}
```

---

## Building/Generating Code

To generate the `.g.dart` serialization file, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
*(If a watcher is needed for rapid prototyping, use `watch` instead of `build`)*

## References
- Sample Auth Model: [user_model.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/feature/auth/data/model/user_model.dart)
- Model Tests: [user_model_test.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/test/feature/auth/data/model/user_model_test.dart)

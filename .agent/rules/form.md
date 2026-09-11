# Form Architecture Rules (`lib/ui/widgets/form/`)

All form fields and form structures in `onyx_todo` must use the `AppForm` + `AppFormController` + `FormBuilder` pattern.

## Core Principles

1. **Form Controller & Hook**:
   - For integrated forms, initialize controller via `final formController = useAppFormController();` inside a `HookWidget`.
   - Wrap fields in `AppForm(controller: formController, child: Column(...))`.

2. **Form Inputs Identification (`fieldId` / `name`)**:
   - Use `fieldId` for `AppTextField` and `name` for `AppFormDropdown` / `AppFormCheckbox` to bind inputs to the `FormBuilder` state.
   - Field names must match backend API DTO keys (e.g., `'email'`, `'password'`).

3. **Form Submission & Auto-Focus**:
   - Always submit via `formController.submit((values) { ... })`.
   - `submit` automatically runs `validateAndFocusFirstError()`, focusing the first invalid input if validation fails.

4. **Backend Failure Handling (`handleFailure`)**:
   - In Cubit failure listeners, invoke `formController.handleFailure(state.failure)`.
   - Automatically maps server validation error keys to matching form fields.

5. **Standalone Fields**:
   - For standalone inputs (e.g. search bars), omit `fieldId` and pass `controller` and `onChanged` directly to `AppTextField`.

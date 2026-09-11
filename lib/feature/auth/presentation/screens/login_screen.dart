import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/auth/domain/repositories/auth_repository.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final workspaceCubit = context.workspaceCubit;

    final isSignUp = useState<bool>(false);
    final isLoading = useState<bool>(false);
    final errorMessage = useState<String?>(null);
    final obscurePassword = useState<bool>(true);

    final nameController = useTextEditingController();
    final emailController = useTextEditingController(text: 'manager@onyx.com');
    final passwordController = useTextEditingController(text: '123456');
    final selectedRole = useState<UserRole>(UserRole.departmentManager);
    final selectedStack = useState<DeveloperStack>(DeveloperStack.backend);

    Future<void> handleSubmit() async {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final name = nameController.text.trim();

      if (email.isEmpty || password.isEmpty || (isSignUp.value && name.isEmpty)) {
        errorMessage.value = AppStrings.fillAllFields.tr();
        return;
      }

      isLoading.value = true;
      errorMessage.value = null;

      final authRepo = getIt<AuthRepository>();

      if (isSignUp.value) {
        final result = await authRepo.signUp(
          name: name,
          email: email,
          password: password,
          role: selectedRole.value,
          stack: selectedStack.value,
        );

        isLoading.value = false;

        result.fold(
          (failure) {
            errorMessage.value = failure.message.isNotEmpty
                ? failure.message
                : AppStrings.emailAlreadyExists.tr();
          },
          (user) {
            workspaceCubit.setAuthenticatedUser(user);
            if (context.mounted) {
              context.safeGo('/');
            }
          },
        );
      } else {
        final result = await authRepo.signInWithEmailPassword(email, password);

        isLoading.value = false;

        result.fold(
          (failure) {
            errorMessage.value = failure.code == 404
                ? AppStrings.userNotFound.tr()
                : AppStrings.invalidCredentials.tr();
          },
          (user) {
            workspaceCubit.setAuthenticatedUser(user);
            if (context.mounted) {
              context.safeGo('/');
            }
          },
        );
      }
    }

    return Scaffold(
      backgroundColor: isDark ? OnyxColors.darkBackground : OnyxColors.lightBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDark ? OnyxColors.darkCard : OnyxColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Branding Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [OnyxColors.primary, OnyxColors.primaryLight],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.cubes,
                          color: OnyxColors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ONYX',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                              color: OnyxColors.primary,
                            ),
                          ),
                          Text(
                            AppStrings.appTitle.tr(),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Tab Switcher (Login / Register)
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? OnyxColors.darkSurface : OnyxColors.neutral100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              isSignUp.value = false;
                              errorMessage.value = null;
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !isSignUp.value
                                    ? (isDark ? OnyxColors.darkCard : OnyxColors.white)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: !isSignUp.value
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.08),
                                          blurRadius: 4,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                AppStrings.login.tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: !isSignUp.value ? FontWeight.bold : FontWeight.w500,
                                  color: !isSignUp.value
                                      ? OnyxColors.primary
                                      : (isDark ? OnyxColors.neutral400 : OnyxColors.neutral600),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              isSignUp.value = true;
                              errorMessage.value = null;
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSignUp.value
                                    ? (isDark ? OnyxColors.darkCard : OnyxColors.white)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: isSignUp.value
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.08),
                                          blurRadius: 4,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                AppStrings.signUp.tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSignUp.value ? FontWeight.bold : FontWeight.w500,
                                  color: isSignUp.value
                                      ? OnyxColors.primary
                                      : (isDark ? OnyxColors.neutral400 : OnyxColors.neutral600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Subtitle Prompt
                  Text(
                    isSignUp.value
                        ? AppStrings.registerSubtitle.tr()
                        : AppStrings.loginSubtitle.tr(),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Error Banner
                  if (errorMessage.value != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: OnyxColors.danger.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: OnyxColors.danger.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.circleExclamation,
                            color: OnyxColors.danger,
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorMessage.value!,
                              style: const TextStyle(
                                color: OnyxColors.danger,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Sign Up: Full Name Field
                  if (isSignUp.value) ...[
                    Text(
                      AppStrings.fullName.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameController,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: AppStrings.fullName.tr(),
                        prefixIcon: const Icon(Icons.person_outline, size: 18),
                        filled: true,
                        fillColor: isDark ? OnyxColors.darkSurface : OnyxColors.neutral50,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Email Field
                  Text(
                    AppStrings.email.tr(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'name@company.com',
                      prefixIcon: const Icon(Icons.email_outlined, size: 18),
                      filled: true,
                      fillColor: isDark ? OnyxColors.darkSurface : OnyxColors.neutral50,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Password Field
                  Text(
                    AppStrings.password.tr(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword.value,
                    style: const TextStyle(fontSize: 13),
                    onSubmitted: (_) => handleSubmit(),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.lock_outline, size: 18),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 18,
                        ),
                        onPressed: () => obscurePassword.value = !obscurePassword.value,
                      ),
                      filled: true,
                      fillColor: isDark ? OnyxColors.darkSurface : OnyxColors.neutral50,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                        ),
                      ),
                    ),
                  ),

                  // Sign Up: Role & Stack Selection
                  if (isSignUp.value) ...[
                    const SizedBox(height: 14),
                    Text(
                      AppStrings.selectRole.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isDark ? OnyxColors.darkSurface : OnyxColors.neutral50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<UserRole>(
                          value: selectedRole.value,
                          isExpanded: true,
                          items: UserRole.values.map((role) {
                            return DropdownMenuItem(
                              value: role,
                              child: Text(
                                role.label,
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) selectedRole.value = val;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      AppStrings.selectStack.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isDark ? OnyxColors.darkSurface : OnyxColors.neutral50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<DeveloperStack>(
                          value: selectedStack.value,
                          isExpanded: true,
                          items: DeveloperStack.values.map((stack) {
                            return DropdownMenuItem(
                              value: stack,
                              child: Text(
                                stack.label,
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) selectedStack.value = val;
                          },
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Submit Action Button
                  ElevatedButton(
                    onPressed: isLoading.value ? null : handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OnyxColors.primary,
                      foregroundColor: OnyxColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: OnyxColors.white,
                            ),
                          )
                        : Text(
                            isSignUp.value ? AppStrings.signUp.tr() : AppStrings.login.tr(),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                  ),
                  const SizedBox(height: 16),

                  // Bottom Switch prompt
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isSignUp.value
                            ? AppStrings.haveAccountPrompt.tr()
                            : AppStrings.noAccountPrompt.tr(),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          isSignUp.value = !isSignUp.value;
                          errorMessage.value = null;
                        },
                        child: Text(
                          isSignUp.value ? AppStrings.login.tr() : AppStrings.signUp.tr(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: OnyxColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

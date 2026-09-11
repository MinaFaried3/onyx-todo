import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onyx_todo/core/config/environments/security_config.dart';
import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:onyx_todo/core/navigation/routes/app_router.dart';
import 'package:onyx_todo/core/navigation/routes/builders/route_builder_helper.dart';
import 'package:onyx_todo/core/onyx_todo_init.dart';
import 'package:onyx_todo/core/ui/theme_manager.dart';
import 'package:onyx_todo/feature/achievement/domain/repositories/achievement_repository.dart';
import 'package:onyx_todo/feature/achievement/presentation/cubit/achievement_cubit.dart';
import 'package:onyx_todo/feature/auth/domain/repositories/auth_repository.dart';
import 'package:onyx_todo/feature/excel_import/data/services/excel_parser_service.dart';
import 'package:onyx_todo/feature/excel_import/presentation/cubit/excel_import_cubit.dart';
import 'package:onyx_todo/feature/month_plan/domain/repositories/month_plan_repository.dart';
import 'package:onyx_todo/feature/month_plan/presentation/cubit/month_plan_cubit.dart';
import 'package:onyx_todo/feature/notification/domain/repositories/notification_repository.dart';
import 'package:onyx_todo/feature/task/domain/repositories/task_repository.dart';
import 'package:onyx_todo/feature/auth/presentation/screens/login_screen.dart';
import 'package:onyx_todo/feature/task/presentation/cubit/tasks_cubit.dart';
import 'package:onyx_todo/feature/team/domain/repositories/team_repository.dart';
import 'package:onyx_todo/feature/workspace/domain/repositories/workspace_repository.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_state.dart';
import 'package:onyx_todo/feature/workspace/presentation/screens/workspace_shell_screen.dart';
import 'package:onyx_todo/firebase_options.dart';

void main() async {
  final config = CoreConfig(
    appId: 'onyx_todo',
    apiBaseUrl: 'https://api.onyx.com',
    environment: Environment.dev,
    firebase: FirebaseConfig(
      options: DefaultFirebaseOptions.currentPlatform,
      analytics: false,
      crashlytics: false,
      performance: false,
    ),
    security: const SecurityConfig(
      sslPinning: false,
      safeDevice: false,
    ),
  );

  await runOnyxApp(
    config: config,
    onInit: () async {
      await getIt<AuthRepository>().init();
    },
    routerBuilder: ({
      required String initialLocation,
      required GlobalKey<NavigatorState> navigatorKey,
      required List<NavigatorObserver> observers,
    }) {
      return buildCoreRouter(
        initialLocation: initialLocation,
        navigatorKey: navigatorKey,
        observers: observers,
        redirect: (context, state) {
          final authRepo = getIt<AuthRepository>();
          final isLoggingIn = state.matchedLocation == '/login';
          final isAuthenticated = authRepo.isAuthenticated;

          if (!isAuthenticated && !isLoggingIn) {
            return '/login';
          }
          if (isAuthenticated && isLoggingIn) {
            return '/';
          }
          return null;
        },
        routes: [
          GoRoute(
            path: '/login',
            pageBuilder: (context, state) => RouteBuilderHelper.buildPage(
              state: state,
              child: const LoginScreen(),
            ),
          ),
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => RouteBuilderHelper.buildPage(
              state: state,
              child: const WorkspaceShellScreen(),
            ),
          ),
        ],
      );
    },
    child: const OnyxTodoApp(),
  );
}

class OnyxTodoApp extends StatelessWidget {
  const OnyxTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WorkspaceCubit>(
          create: (ctx) => WorkspaceCubit(
            workspaceRepository: getIt<WorkspaceRepository>(),
            authRepository: getIt<AuthRepository>(),
            teamRepository: getIt<TeamRepository>(),
            notificationRepository: getIt<NotificationRepository>(),
          ),
        ),
        BlocProvider<TasksCubit>(
          create: (ctx) => TasksCubit(
            taskRepository: getIt<TaskRepository>(),
          ),
        ),
        BlocProvider<MonthPlanCubit>(
          create: (ctx) => MonthPlanCubit(
            monthPlanRepository: getIt<MonthPlanRepository>(),
          ),
        ),
        BlocProvider<AchievementCubit>(
          create: (ctx) => AchievementCubit(
            achievementRepository: getIt<AchievementRepository>(),
          ),
        ),
        BlocProvider<ExcelImportCubit>(
          create: (ctx) => ExcelImportCubit(
            excelParserService: getIt<ExcelParserService>(),
            taskRepository: getIt<TaskRepository>(),
            authRepository: getIt<AuthRepository>(),
          ),
        ),
      ],
      child: BlocBuilder<WorkspaceCubit, WorkspaceState>(
        buildWhen: (prev, curr) => prev.isDarkMode != curr.isDarkMode,
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Onyx Task Manager',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: getOnyxTheme(isDark: false),
            darkTheme: getOnyxTheme(isDark: true),
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: getIt<GoRouter>(),
          );
        },
      ),
    );
  }
}

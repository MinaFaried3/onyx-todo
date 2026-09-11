import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:onyx_todo/feature/achievement/data/datasources/achievement_remote_data_source.dart';
import 'package:onyx_todo/feature/achievement/domain/repositories/achievement_repository.dart';
import 'package:onyx_todo/feature/auth/data/datasources/user_remote_data_source.dart';
import 'package:onyx_todo/feature/auth/domain/repositories/auth_repository.dart';
import 'package:onyx_todo/feature/excel_import/data/services/excel_parser_service.dart';
import 'package:onyx_todo/feature/month_plan/data/datasources/month_plan_remote_data_source.dart';
import 'package:onyx_todo/feature/month_plan/domain/repositories/month_plan_repository.dart';
import 'package:onyx_todo/feature/notification/data/datasources/notification_remote_data_source.dart';
import 'package:onyx_todo/feature/notification/domain/repositories/notification_repository.dart';
import 'package:onyx_todo/feature/task/data/datasources/task_remote_data_source.dart';
import 'package:onyx_todo/feature/task/domain/repositories/task_repository.dart';
import 'package:onyx_todo/feature/task/data/repositories/task_repository_impl.dart';
import 'package:onyx_todo/feature/team/data/datasources/team_remote_data_source.dart';
import 'package:onyx_todo/feature/team/domain/repositories/team_repository.dart';
import 'package:onyx_todo/feature/workspace/domain/repositories/workspace_repository.dart';

abstract final class FeatureModule {
  static void init() {
    FirebaseFirestore? firestore;
    try {
      if (getIt.isRegistered<FirebaseFirestore>()) {
        firestore = getIt<FirebaseFirestore>();
      }
    } catch (_) {}

    // User & Auth
    getIt.lazySingletonOnce<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(firestore: firestore),
    );
    getIt.lazySingletonOnce<AuthRepository>(
      () => AuthRepositoryImpl(userRemoteDataSource: getIt<UserRemoteDataSource>()),
    );

    // Teams
    getIt.lazySingletonOnce<TeamRemoteDataSource>(
      () => TeamRemoteDataSourceImpl(firestore: firestore),
    );
    getIt.lazySingletonOnce<TeamRepository>(
      () => TeamRepositoryImpl(remoteDataSource: getIt<TeamRemoteDataSource>()),
    );

    // Notifications
    getIt.lazySingletonOnce<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(firestore: firestore),
    );
    getIt.lazySingletonOnce<NotificationRepository>(
      () => NotificationRepositoryImpl(remoteDataSource: getIt<NotificationRemoteDataSource>()),
    );

    // Workspace
    getIt.lazySingletonOnce<WorkspaceRepository>(
      () => WorkspaceRepositoryImpl(firestore: firestore),
    );

    // Tasks
    getIt.lazySingletonOnce<TaskRemoteDataSource>(
      () => TaskRemoteDataSourceImpl(firestore: firestore),
    );
    getIt.lazySingletonOnce<TaskRepository>(
      () => TaskRepositoryImpl(remoteDataSource: getIt<TaskRemoteDataSource>()),
    );

    // Month Plan
    getIt.lazySingletonOnce<MonthPlanRemoteDataSource>(
      () => MonthPlanRemoteDataSourceImpl(firestore: firestore),
    );
    getIt.lazySingletonOnce<MonthPlanRepository>(
      () => MonthPlanRepositoryImpl(
        remoteDataSource: getIt<MonthPlanRemoteDataSource>(),
      ),
    );

    // Achievements
    getIt.lazySingletonOnce<AchievementRemoteDataSource>(
      () => AchievementRemoteDataSourceImpl(firestore: firestore),
    );
    getIt.lazySingletonOnce<AchievementRepository>(
      () => AchievementRepositoryImpl(
        remoteDataSource: getIt<AchievementRemoteDataSource>(),
      ),
    );

    // Excel Parser
    getIt.lazySingletonOnce<ExcelParserService>(() => ExcelParserService());
  }
}

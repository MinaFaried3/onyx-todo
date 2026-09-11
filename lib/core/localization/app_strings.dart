/// Application-wide localized string keys.
///
/// Use with `AppStrings.key.tr()` from `easy_localization`.
abstract final class AppStrings {
  // ─── App General ─────────────────────────────────────────────────────────────
  static String get appTitle => 'app_title';
  static String get appName => 'onyx_erp';
  static String get onyxErp => 'onyx_erp';
  static String get workspace => 'workspace';
  static String get spaces => 'spaces';
  static String get modules => 'modules';
  static String get allModules => 'all_modules';
  static String get versions => 'versions';
  static String get tasks => 'tasks';
  static String get myTasks => 'my_tasks';
  static String get teamTasks => 'team_tasks';
  static String get settings => 'settings';
  static String get logout => 'logout';
  static String get search => 'search';
  static String get filter => 'filter';
  static String get cancel => 'cancel';
  static String get save => 'save';
  static String get close => 'close';
  static String get confirm => 'confirm';
  static String get all => 'all';
  static String get loading => 'loading';
  static String get retry => 'retry';
  static String get error => 'error';
  static String get success => 'success';
  static String get add => 'add';
  static String get addTask => 'add_task';

  // ─── Views ───────────────────────────────────────────────────────────────────
  static String get listView => 'list_view';
  static String get boardView => 'board_view';
  static String get workloadView => 'workload_view';
  static String get achievementsView => 'achievements_view';
  static String get monthlyPlanView => 'monthly_plan_view';
  static String get excelImportView => 'excel_import_view';

  // ─── Task Fields ─────────────────────────────────────────────────────────────
  static String get taskId => 'task_id';
  static String get taskTitle => 'task_title';
  static String get description => 'description';
  static String get screenName => 'screen_name';
  static String get taskType => 'task_type';
  static String get priority => 'priority';
  static String get status => 'status';
  static String get assignees => 'assignees';
  static String get frontendDev => 'frontend_dev';
  static String get backendDev => 'backend_dev';
  static String get middleDev => 'middle_dev';
  static String get qaTester => 'qa_tester';
  static String get createdDate => 'created_date';
  static String get dueDate => 'due_date';
  static String get resolvedDate => 'resolved_date';
  static String get estimatedHours => 'estimated_hours';
  static String get actualHours => 'actual_hours';
  static String get devNotes => 'dev_notes';
  static String get qaNotes => 'qa_notes';
  static String get activityHistory => 'activity_history';
  static String get comments => 'comments';
  static String get addComment => 'add_comment';
  static String get createTask => 'create_task';
  static String get editTask => 'edit_task';
  static String get deleteTask => 'delete_task';
  static String get noTasksFound => 'no_tasks_found';
  static String get generalTask => 'general_task';
  static String get copyId => 'copy_id';
  static String get idCopied => 'id_copied';

  // ─── Statuses ────────────────────────────────────────────────────────────────
  static String get statusOpen => 'status_open';
  static String get statusInProgress => 'status_in_progress';
  static String get statusBackendSolved => 'status_backend_solved';
  static String get statusFrontendSolved => 'status_frontend_solved';
  static String get statusQaTesting => 'status_qa_testing';
  static String get statusClosed => 'status_closed';

  // ─── Priorities ──────────────────────────────────────────────────────────────
  static String get priorityUrgent => 'priority_urgent';
  static String get priorityHigh => 'priority_high';
  static String get priorityMedium => 'priority_medium';
  static String get priorityLow => 'priority_low';

  // ─── Task Types ──────────────────────────────────────────────────────────────
  static String get typeTask => 'type_task';
  static String get typeBug => 'type_bug';
  static String get typeFeature => 'type_feature';
  static String get typeUrgent => 'type_urgent';

  // ─── Month Planning & CRM ────────────────────────────────────────────────────
  static String get monthlyPlan => 'monthly_plan';
  static String get createMonthPlan => 'create_month_plan';
  static String get targetHours => 'target_hours';
  static String get totalEstimatedHours => 'total_estimated_hours';
  static String get totalActualHours => 'total_actual_hours';
  static String get planStatus => 'plan_status';
  static String get planDraft => 'plan_draft';
  static String get planSubmitted => 'plan_submitted';
  static String get planApproved => 'plan_approved';
  static String get planRejected => 'plan_rejected';
  static String get planClosed => 'plan_closed';
  static String get submitForApproval => 'submit_for_approval';
  static String get approvePlan => 'approve_plan';
  static String get rejectPlan => 'reject_plan';
  static String get managerNotes => 'manager_notes';
  static String get closePlan => 'close_plan';
  static String get actualVsEstimated => 'actual_vs_estimated';

  // ─── Daily & Weekly Achievements ─────────────────────────────────────────────
  static String get dailyAchievements => 'daily_achievements';
  static String get weeklyAchievements => 'weekly_achievements';
  static String get logDailyAchievement => 'log_daily_achievement';
  static String get hoursSpent => 'hours_spent';
  static String get tasksWorked => 'tasks_worked';
  static String get blockers => 'blockers';
  static String get nextDayPlan => 'next_day_plan';
  static String get filterToday => 'filter_today';
  static String get filterYesterday => 'filter_yesterday';
  static String get filterThisWeek => 'filter_this_week';
  static String get filterLastWeek => 'filter_last_week';
  static String get filterThisMonth => 'filter_this_month';
  static String get filterCustom => 'filter_custom';
  static String get copyWhatsappSummary => 'copy_whatsapp_summary';
  static String get whatsappSummaryCopied => 'whatsapp_summary_copied';
  static String get developerProgress => 'developer_progress';
  static String get moduleProgress => 'module_progress';
  static String get totalLoggedHours => 'total_logged_hours';

  // ─── Excel Import ────────────────────────────────────────────────────────────
  static String get excelImport => 'excel_import';
  static String get selectExcelFile => 'select_excel_file';
  static String get importingTasks => 'importing_tasks';
  static String get importSuccess => 'import_success';
  static String get sheetsFound => 'sheets_found';
  static String get tasksImported => 'tasks_imported';
  static String get uploadExcelPrompt => 'upload_excel_prompt';
  static String get confirmImport => 'confirm_import';
  static String get discardImport => 'discard_import';
  static String get uploadingToCloud => 'uploading_to_cloud';
  static String get loadMoreTasks => 'load_more_tasks';
  static String get allTasksLoaded => 'all_tasks_loaded';
  static String get stagedPreviewNotice => 'staged_preview_notice';
  static String get uploadProgressLabel => 'upload_progress_label';

  // ─── Roles & Stacks ──────────────────────────────────────────────────────────
  static String get roleManager => 'role_manager';
  static String get roleLead => 'role_lead';
  static String get roleDeveloper => 'role_developer';
  static String get roleQa => 'role_qa';
  static String get stackFrontend => 'stack_frontend';
  static String get stackBackend => 'stack_backend';
  static String get stackMiddle => 'stack_middle';

  // ─── Form Hints & Labels ─────────────────────────────────────────────────────
  static String get enterTaskTitle => 'enter_task_title';
  static String get unassigned => 'unassigned';
  static String get noHistoryYet => 'no_history_yet';
  static String get generalScreen => 'general_screen';
  static String get dailyEntriesScreen => 'daily_entries_screen';
  static String get screenHint => 'screen_hint';
  static String get titleHint => 'title_hint';
  static String get assigneeHint => 'assignee_hint';
  static String get descriptionHint => 'description_hint';
  static String get taskCreatedSuccess => 'task_created_success';
  static String get copyTaskId => 'copy_task_id';

  // ─── Month Plan Labels & Columns ─────────────────────────────────────────────
  static String get crmSystemTitle => 'crm_system_title';
  static String get noPlanForMonth => 'no_plan_for_month';
  static String get targetWorkHours => 'target_work_hours';
  static String get workingDaysCount => 'working_days_count';
  static String get coveragePercentage => 'coverage_percentage';
  static String get endOfMonthActual => 'end_of_month_actual';
  static String get planTasksCount => 'plan_tasks_count';
  static String get addTaskToPlan => 'add_task_to_plan';
  static String get planSubmittedSuccess => 'plan_submitted_success';
  static String get planApprovedSuccess => 'plan_approved_success';
  static String get planClosedSuccess => 'plan_closed_success';
  static String get planRejectedSuccess => 'plan_rejected_success';
  static String get planSubmittedToast => 'plan_submitted_success';
  static String get planApprovedToast => 'plan_approved_success';
  static String get planClosedToast => 'plan_closed_success';
  static String get codeCol => 'code_col';
  static String get taskIdCol => 'code_col';
  static String get moduleCol => 'module_col';
  static String get screenCol => 'screen_col';
  static String get titleCol => 'title_col';
  static String get estDaysCol => 'est_days_col';
  static String get estHoursCol => 'est_hours_col';
  static String get actHoursCol => 'act_hours_col';
  static String get noTasksInPlan => 'no_tasks_in_plan';
  static String get planStatusApprovedActive => 'plan_status_approved_active';
  static String get planStatusPendingManager => 'plan_status_pending_manager';
  static String get planStatusUnderRevision => 'plan_status_under_revision';
  static String get rejectPlanTitle => 'reject_plan_title';
  static String get rejectNotesLabel => 'reject_notes_label';
  static String get sendFeedback => 'send_feedback';
  static String get daysLabel => 'days_label';
  static String get dayUnit => 'day_unit';
  static String get developerLabel => 'developer_label';
  static String get monthLabel => 'month_label';
  static String get moduleCodeHint => 'module_code_hint';

  // ─── Workload View ───────────────────────────────────────────────────────────
  static String get noDevelopersAssigned => 'no_developers_assigned';
  static String get assignedTasksCount => 'assigned_tasks_count';
  static String get completedCount => 'completed_count';
  static String get estLabel => 'est_label';
  static String get actLabel => 'act_label';

  // ─── Shell & Notifications ───────────────────────────────────────────────────
  static String get collapseMenu => 'collapse_menu';
  static String get expandMenu => 'expand_menu';
  static String get switchAccount => 'switch_account';
  static String get viewTasksBoard => 'view_tasks_board';
  static String get tasksImportedSuccess => 'tasks_imported_success';
  static String get tasksUpdatedSuccess => 'tasks_updated_success';
  static String get achievementLoggedSuccess => 'achievement_logged_success';
  static String get workHoursUnit => 'work_hours_unit';
  static String get noAchievementsFound => 'no_achievements_found';

  // ─── Analytics & Syncfusion Charts ───────────────────────────────────────────
  static String get analyticsView => 'analytics_view';
  static String get chartsAndMetrics => 'charts_and_metrics';
  static String get moduleTaskDistribution => 'module_task_distribution';
  static String get developerVelocity => 'developer_velocity';
  static String get estimatedVsActualHours => 'estimated_vs_actual_hours';
  static String get statusPipelineBreakdown => 'status_pipeline_breakdown';
  static String get monthlyBurnupTrajectory => 'monthly_burnup_trajectory';
  static String get totalTasksMetric => 'total_tasks_metric';
  static String get completedTasksMetric => 'completed_tasks_metric';
  static String get estHoursMetric => 'est_hours_metric';
  static String get actHoursMetric => 'act_hours_metric';
  static String get completionRateMetric => 'completion_rate_metric';
  static String get taskCountLabel => 'task_count_label';
  static String get activeDevelopers => 'active_developers';
  static String get teamAchievementSubtitle => 'team_achievement_subtitle';
  static String get filterByDeveloper => 'filter_by_developer';
  static String get allDevelopers => 'all_developers';

  // ─── Teams & User Management ────────────────────────────────────────────────
  static String get teamsAndUsers => 'teams_and_users';
  static String get teams => 'teams';
  static String get users => 'users';
  static String get teamMembers => 'team_members';
  static String get teamReports => 'team_reports';
  static String get teamStatistics => 'team_statistics';
  static String get addTeam => 'add_team';
  static String get editTeam => 'edit_team';
  static String get deleteTeam => 'delete_team';
  static String get teamName => 'team_name';
  static String get teamLead => 'team_lead';
  static String get roleTeamLead => 'role_lead';
  static String get assignModules => 'assign_modules';
  static String get selectMembers => 'select_members';
  static String get resetPassword => 'reset_password';
  static String get passwordResetSent => 'password_reset_sent';
  static String get lastActive => 'last_active';
  static String get activeNow => 'active_now';
  static String get notifications => 'notifications';
  static String get noNotifications => 'no_notifications';
  static String get markAllRead => 'mark_all_read';
  static String get notifTaskAssigned => 'notif_task_assigned';
  static String get notifStatusChanged => 'notif_status_changed';
  static String get notifSystem => 'notif_system';
  static String get userRole => 'user_role';
  static String get assignToTeam => 'assign_to_team';
  static String get changeRole => 'change_role';
  static String get allUsers => 'all_users';
  static String get noTeamsFound => 'no_teams_found';
  static String get email => 'email';
  static String get myMonthlyPlan => 'my_monthly_plan';
  static String get teamTaskPool => 'team_task_pool';
  static String get addToMyPlan => 'add_to_my_plan';
  static String get monthlyHoursCounter => 'monthly_hours_counter';
  static String get calculatedWorkHours => 'calculated_work_hours';
  static String get registeredHours => 'registered_hours';
  static String get remainingHours => 'remaining_hours';
  static String get extraHours => 'extra_hours';
  static String get roleFlow => 'role_flow';
  static String get defaultRoleAssignees => 'default_role_assignees';
  static String get selectedTasksCount => 'selected_tasks_count';
  static String get addSelectedToPlan => 'add_selected_to_plan';
  static String get tasksAddedToPlan => 'tasks_added_to_plan';
  static String get searchTeamPoolHint => 'search_team_pool_hint';
  static String get filterByModule => 'filter_by_module';
  static String get moduleHierarchy => 'module_hierarchy';
  static String get screenTypes => 'screen_types';
  static String get screenTypeConfig => 'screen_type_config';
  static String get screenTypeInputs => 'screen_type_inputs';
  static String get screenTypeTransaction => 'screen_type_transaction';
  static String get screenTypeReports => 'screen_type_reports';
  static String get subModules => 'sub_modules';
  static String get addSubModule => 'add_sub_module';
  static String get addScreen => 'add_screen';
  static String get backendProgress => 'backend_progress';
  static String get frontendProgress => 'frontend_progress';
  static String get screenProgress => 'screen_progress';
  static String get systemProgress => 'system_progress';
  static String get assignedTeam => 'assigned_team';
  static String get subModuleNameAr => 'sub_module_name_ar';
  static String get subModuleNameEn => 'sub_module_name_en';
  static String get screenNameAr => 'screen_name_ar';
  static String get screenNameEn => 'screen_name_en';
}


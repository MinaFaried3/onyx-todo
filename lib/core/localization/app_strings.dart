/// Application-wide localized string keys.
///
/// Use with `AppStrings.key.tr()` from `easy_localization`.
abstract final class AppStrings {
  // ─── App General ─────────────────────────────────────────────────────────────
  static const String appTitle = 'app_title';
  static const String onyxErp = 'onyx_erp';
  static const String workspace = 'workspace';
  static const String spaces = 'spaces';
  static const String modules = 'modules';
  static const String versions = 'versions';
  static const String tasks = 'tasks';
  static const String myTasks = 'my_tasks';
  static const String teamTasks = 'team_tasks';
  static const String settings = 'settings';
  static const String logout = 'logout';
  static const String search = 'search';
  static const String filter = 'filter';
  static const String cancel = 'cancel';
  static const String save = 'save';
  static const String close = 'close';
  static const String confirm = 'confirm';
  static const String all = 'all';
  static const String loading = 'loading';
  static const String retry = 'retry';
  static const String error = 'error';
  static const String success = 'success';

  // ─── Views ───────────────────────────────────────────────────────────────────
  static const String listView = 'list_view';
  static const String boardView = 'board_view';
  static const String workloadView = 'workload_view';
  static const String achievementsView = 'achievements_view';
  static const String monthlyPlanView = 'monthly_plan_view';
  static const String excelImportView = 'excel_import_view';

  // ─── Task Fields ─────────────────────────────────────────────────────────────
  static const String taskId = 'task_id';
  static const String taskTitle = 'task_title';
  static const String description = 'description';
  static const String screenName = 'screen_name';
  static const String taskType = 'task_type';
  static const String priority = 'priority';
  static const String status = 'status';
  static const String assignees = 'assignees';
  static const String frontendDev = 'frontend_dev';
  static const String backendDev = 'backend_dev';
  static const String middleDev = 'middle_dev';
  static const String qaTester = 'qa_tester';
  static const String createdDate = 'created_date';
  static const String dueDate = 'due_date';
  static const String resolvedDate = 'resolved_date';
  static const String estimatedHours = 'estimated_hours';
  static const String actualHours = 'actual_hours';
  static const String devNotes = 'dev_notes';
  static const String qaNotes = 'qa_notes';
  static const String activityHistory = 'activity_history';
  static const String comments = 'comments';
  static const String addComment = 'add_comment';
  static const String createTask = 'create_task';
  static const String editTask = 'edit_task';
  static const String deleteTask = 'delete_task';
  static const String noTasksFound = 'no_tasks_found';
  static const String generalTask = 'general_task';
  static const String copyId = 'copy_id';
  static const String idCopied = 'id_copied';

  // ─── Statuses ────────────────────────────────────────────────────────────────
  static const String statusOpen = 'status_open';
  static const String statusInProgress = 'status_in_progress';
  static const String statusBackendSolved = 'status_backend_solved';
  static const String statusFrontendSolved = 'status_frontend_solved';
  static const String statusQaTesting = 'status_qa_testing';
  static const String statusClosed = 'status_closed';

  // ─── Priorities ──────────────────────────────────────────────────────────────
  static const String priorityUrgent = 'priority_urgent';
  static const String priorityHigh = 'priority_high';
  static const String priorityMedium = 'priority_medium';
  static const String priorityLow = 'priority_low';

  // ─── Task Types ──────────────────────────────────────────────────────────────
  static const String typeTask = 'type_task';
  static const String typeBug = 'type_bug';
  static const String typeFeature = 'type_feature';
  static const String typeUrgent = 'type_urgent';

  // ─── Month Planning & CRM ────────────────────────────────────────────────────
  static const String monthlyPlan = 'monthly_plan';
  static const String createMonthPlan = 'create_month_plan';
  static const String targetHours = 'target_hours';
  static const String totalEstimatedHours = 'total_estimated_hours';
  static const String totalActualHours = 'total_actual_hours';
  static const String planStatus = 'plan_status';
  static const String planDraft = 'plan_draft';
  static const String planSubmitted = 'plan_submitted';
  static const String planApproved = 'plan_approved';
  static const String planRejected = 'plan_rejected';
  static const String planClosed = 'plan_closed';
  static const String submitForApproval = 'submit_for_approval';
  static const String approvePlan = 'approve_plan';
  static const String rejectPlan = 'reject_plan';
  static const String managerNotes = 'manager_notes';
  static const String closePlan = 'close_plan';
  static const String actualVsEstimated = 'actual_vs_estimated';

  // ─── Daily & Weekly Achievements ─────────────────────────────────────────────
  static const String dailyAchievements = 'daily_achievements';
  static const String weeklyAchievements = 'weekly_achievements';
  static const String logDailyAchievement = 'log_daily_achievement';
  static const String hoursSpent = 'hours_spent';
  static const String tasksWorked = 'tasks_worked';
  static const String blockers = 'blockers';
  static const String nextDayPlan = 'next_day_plan';
  static const String filterToday = 'filter_today';
  static const String filterYesterday = 'filter_yesterday';
  static const String filterThisWeek = 'filter_this_week';
  static const String filterLastWeek = 'filter_last_week';
  static const String filterThisMonth = 'filter_this_month';
  static const String filterCustom = 'filter_custom';
  static const String copyWhatsappSummary = 'copy_whatsapp_summary';
  static const String whatsappSummaryCopied = 'whatsapp_summary_copied';
  static const String developerProgress = 'developer_progress';
  static const String moduleProgress = 'module_progress';
  static const String totalLoggedHours = 'total_logged_hours';

  // ─── Excel Import ────────────────────────────────────────────────────────────
  static const String excelImport = 'excel_import';
  static const String selectExcelFile = 'select_excel_file';
  static const String importingTasks = 'importing_tasks';
  static const String importSuccess = 'import_success';
  static const String sheetsFound = 'sheets_found';
  static const String tasksImported = 'tasks_imported';
  static const String uploadExcelPrompt = 'upload_excel_prompt';

  // ─── Roles & Stacks ──────────────────────────────────────────────────────────
  static const String roleManager = 'role_manager';
  static const String roleLead = 'role_lead';
  static const String roleDeveloper = 'role_developer';
  static const String roleQa = 'role_qa';
  static const String stackFrontend = 'stack_frontend';
  static const String stackBackend = 'stack_backend';
  static const String stackMiddle = 'stack_middle';

  // ─── Form Hints & Labels ─────────────────────────────────────────────────────
  static const String enterTaskTitle = 'enter_task_title';
  static const String unassigned = 'unassigned';
  static const String noHistoryYet = 'no_history_yet';
  static const String generalScreen = 'general_screen';
  static const String dailyEntriesScreen = 'daily_entries_screen';
  static const String screenHint = 'screen_hint';
  static const String titleHint = 'title_hint';
  static const String assigneeHint = 'assignee_hint';
  static const String descriptionHint = 'description_hint';
  static const String taskCreatedSuccess = 'task_created_success';
  static const String copyTaskId = 'copy_task_id';

  // ─── Month Plan Labels & Columns ─────────────────────────────────────────────
  static const String crmSystemTitle = 'crm_system_title';
  static const String noPlanForMonth = 'no_plan_for_month';
  static const String targetWorkHours = 'target_work_hours';
  static const String workingDaysCount = 'working_days_count';
  static const String coveragePercentage = 'coverage_percentage';
  static const String endOfMonthActual = 'end_of_month_actual';
  static const String planTasksCount = 'plan_tasks_count';
  static const String addTaskToPlan = 'add_task_to_plan';
  static const String planSubmittedSuccess = 'plan_submitted_success';
  static const String planApprovedSuccess = 'plan_approved_success';
  static const String planClosedSuccess = 'plan_closed_success';
  static const String planRejectedSuccess = 'plan_rejected_success';
  static const String codeCol = 'code_col';
  static const String moduleCol = 'module_col';
  static const String screenCol = 'screen_col';
  static const String titleCol = 'title_col';
  static const String estDaysCol = 'est_days_col';
  static const String estHoursCol = 'est_hours_col';
  static const String actHoursCol = 'act_hours_col';
  static const String noTasksInPlan = 'no_tasks_in_plan';
  static const String planStatusApprovedActive = 'plan_status_approved_active';
  static const String planStatusPendingManager = 'plan_status_pending_manager';
  static const String planStatusUnderRevision = 'plan_status_under_revision';
  static const String rejectPlanTitle = 'reject_plan_title';
  static const String rejectNotesLabel = 'reject_notes_label';
  static const String sendFeedback = 'send_feedback';
  static const String daysLabel = 'days_label';
  static const String dayUnit = 'day_unit';
  static const String developerLabel = 'developer_label';
  static const String monthLabel = 'month_label';
  static const String moduleCodeHint = 'module_code_hint';

  // ─── Workload View ───────────────────────────────────────────────────────────
  static const String noDevelopersAssigned = 'no_developers_assigned';
  static const String assignedTasksCount = 'assigned_tasks_count';
  static const String completedCount = 'completed_count';
  static const String estLabel = 'est_label';
  static const String actLabel = 'act_label';

  // ─── Shell & Notifications ───────────────────────────────────────────────────
  static const String collapseMenu = 'collapse_menu';
  static const String expandMenu = 'expand_menu';
  static const String switchAccount = 'switch_account';
  static const String viewTasksBoard = 'view_tasks_board';
  static const String tasksImportedSuccess = 'tasks_imported_success';
  static const String tasksUpdatedSuccess = 'tasks_updated_success';
  static const String achievementLoggedSuccess = 'achievement_logged_success';
  static const String workHoursUnit = 'work_hours_unit';
  static const String noAchievementsFound = 'no_achievements_found';

  // ─── Analytics & Syncfusion Charts ───────────────────────────────────────────
  static const String analyticsView = 'analytics_view';
  static const String chartsAndMetrics = 'charts_and_metrics';
  static const String moduleTaskDistribution = 'module_task_distribution';
  static const String developerVelocity = 'developer_velocity';
  static const String estimatedVsActualHours = 'estimated_vs_actual_hours';
  static const String statusPipelineBreakdown = 'status_pipeline_breakdown';
  static const String monthlyBurnupTrajectory = 'monthly_burnup_trajectory';
  static const String totalTasksMetric = 'total_tasks_metric';
  static const String completedTasksMetric = 'completed_tasks_metric';
  static const String estHoursMetric = 'est_hours_metric';
  static const String actHoursMetric = 'act_hours_metric';
  static const String completionRateMetric = 'completion_rate_metric';
  static const String taskCountLabel = 'task_count_label';
  static const String activeDevelopers = 'active_developers';
  static const String teamAchievementSubtitle = 'team_achievement_subtitle';
  static const String filterByDeveloper = 'filter_by_developer';
  static const String allDevelopers = 'all_developers';
}

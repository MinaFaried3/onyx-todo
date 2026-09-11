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
}

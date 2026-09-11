import 'package:equatable/equatable.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/feature/workspace/domain/entities/screen_leaf.dart';
import 'package:onyx_todo/feature/workspace/domain/entities/sub_module_entity.dart';

class OnyxModule extends Equatable {
  final String code;
  final String nameAr;
  final String nameEn;
  final String description;
  final List<String> screens;
  final List<String> assignedDevs;
  final String? assignedTeamId;
  final String? assignedTeamName;
  final List<SubModuleEntity> subModules;
  final int totalTasks;
  final int openTasks;

  const OnyxModule({
    required this.code,
    required this.nameAr,
    required this.nameEn,
    this.description = '',
    this.screens = const [],
    this.assignedDevs = const [],
    this.assignedTeamId,
    this.assignedTeamName,
    this.subModules = const [],
    this.totalTasks = 0,
    this.openTasks = 0,
  });

  /// Outer scope 3: Module Average Percentage across its sub-modules
  double get moduleProgress {
    if (subModules.isEmpty) return 0.0;
    final total = subModules.fold<double>(0.0, (sum, s) => sum + s.subModuleProgress);
    return total / subModules.length;
  }

  /// Outer scope 4: All System Done Percentage across all modules in system
  static double calculateSystemProgress(List<OnyxModule> modules) {
    if (modules.isEmpty) return 0.0;
    final total = modules.fold<double>(0.0, (sum, m) => sum + m.moduleProgress);
    return total / modules.length;
  }

  @override
  List<Object?> get props => [
        code,
        nameAr,
        nameEn,
        description,
        screens,
        assignedDevs,
        assignedTeamId,
        assignedTeamName,
        subModules,
        totalTasks,
        openTasks,
      ];

  OnyxModule copyWith({
    String? code,
    String? nameAr,
    String? nameEn,
    String? description,
    List<String>? screens,
    List<String>? assignedDevs,
    String? assignedTeamId,
    String? assignedTeamName,
    List<SubModuleEntity>? subModules,
    int? totalTasks,
    int? openTasks,
  }) {
    return OnyxModule(
      code: code ?? this.code,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      description: description ?? this.description,
      screens: screens ?? this.screens,
      assignedDevs: assignedDevs ?? this.assignedDevs,
      assignedTeamId: assignedTeamId ?? this.assignedTeamId,
      assignedTeamName: assignedTeamName ?? this.assignedTeamName,
      subModules: subModules ?? this.subModules,
      totalTasks: totalTasks ?? this.totalTasks,
      openTasks: openTasks ?? this.openTasks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'description': description,
      'screens': screens,
      'assignedDevs': assignedDevs,
      'assignedTeamId': assignedTeamId,
      'assignedTeamName': assignedTeamName,
      'subModules': subModules.map((s) => s.toMap()).toList(),
      'totalTasks': totalTasks,
      'openTasks': openTasks,
    };
  }

  factory OnyxModule.fromMap(Map<String, dynamic> map) {
    return OnyxModule(
      code: map['code'] as String? ?? '',
      nameAr: map['nameAr'] as String? ?? '',
      nameEn: map['nameEn'] as String? ?? '',
      description: map['description'] as String? ?? '',
      screens: List<String>.from(map['screens'] as List? ?? const []),
      assignedDevs: List<String>.from(map['assignedDevs'] as List? ?? const []),
      assignedTeamId: map['assignedTeamId'] as String?,
      assignedTeamName: map['assignedTeamName'] as String?,
      subModules: (map['subModules'] as List? ?? [])
          .map((s) => SubModuleEntity.fromMap(Map<String, dynamic>.from(s as Map)))
          .toList(),
      totalTasks: (map['totalTasks'] as num?)?.toInt() ?? 0,
      openTasks: (map['openTasks'] as num?)?.toInt() ?? 0,
    );
  }

  /// Built-in registry of the 20 Onyx ERP Modules
  static final List<OnyxModule> standardModules = [
    OnyxModule(
      code: 'INV',
      nameAr: 'المخازن والمستودعات',
      nameEn: 'Inventory Management',
      description: 'بطاقات الأصناف، الجرد، والتحويلات المخزنية',
      assignedTeamId: 'team_inventory',
      assignedTeamName: 'فريق المخازن والمشتريات (Inventory & Supply)',
      subModules: const [
        SubModuleEntity(
          id: 'inv_sub_items',
          nameAr: 'تهيئة وبيانات الأصناف',
          nameEn: 'Items & Warehouses Setup',
          screens: [
            ScreenLeaf(
              id: 'inv_scr_1',
              nameAr: 'ثوابت المخازن العامة',
              nameEn: 'Warehouse Parameters',
              screenType: ScreenType.config,
              backendProgress: 100.0,
              frontendProgress: 90.0,
            ),
            ScreenLeaf(
              id: 'inv_scr_2',
              nameAr: 'بطاقة دليل الأصناف',
              nameEn: 'Item Master Card',
              screenType: ScreenType.inputs,
              backendProgress: 90.0,
              frontendProgress: 80.0,
            ),
            ScreenLeaf(
              id: 'inv_scr_3',
              nameAr: 'سند توريد مخزني',
              nameEn: 'Stock Inward Voucher',
              screenType: ScreenType.transaction,
              backendProgress: 85.0,
              frontendProgress: 70.0,
            ),
            ScreenLeaf(
              id: 'inv_scr_4',
              nameAr: 'حركة صنف تفصيلي',
              nameEn: 'Item Movement Ledger',
              screenType: ScreenType.reports,
              backendProgress: 75.0,
              frontendProgress: 60.0,
            ),
          ],
        ),
        SubModuleEntity(
          id: 'inv_sub_stocktaking',
          nameAr: 'الجرد والتسويات المخزنية',
          nameEn: 'Stocktaking & Adjustments',
          screens: [
            ScreenLeaf(
              id: 'inv_scr_5',
              nameAr: 'إعداد فترات الجرد',
              nameEn: 'Stocktaking Periods',
              screenType: ScreenType.config,
              backendProgress: 80.0,
              frontendProgress: 75.0,
            ),
            ScreenLeaf(
              id: 'inv_scr_6',
              nameAr: 'محاضر الجرد الفعلي',
              nameEn: 'Physical Count Entry',
              screenType: ScreenType.inputs,
              backendProgress: 70.0,
              frontendProgress: 65.0,
            ),
            ScreenLeaf(
              id: 'inv_scr_7',
              nameAr: 'تسوية الفروق المخزنية',
              nameEn: 'Variance Reconciliation',
              screenType: ScreenType.transaction,
              backendProgress: 60.0,
              frontendProgress: 50.0,
            ),
            ScreenLeaf(
              id: 'inv_scr_8',
              nameAr: 'تقرير الفروقات الجردية',
              nameEn: 'Variance Variance Report',
              screenType: ScreenType.reports,
              backendProgress: 65.0,
              frontendProgress: 55.0,
            ),
          ],
        ),
      ],
    ),
    OnyxModule(
      code: 'GLS',
      nameAr: 'الأستاذ العام والحسابات',
      nameEn: 'General Ledger',
      description: 'دليل الحسابات، قيود اليومية، ومراكز التكلفة',
      assignedTeamId: 'team_core',
      assignedTeamName: 'فريق النظام الأساسي (Core ERP)',
      subModules: const [
        SubModuleEntity(
          id: 'gls_sub_accounts',
          nameAr: 'دليل الحسابات والتهيئة المالية',
          nameEn: 'Chart of Accounts & Setup',
          screens: [
            ScreenLeaf(
              id: 'gls_scr_1',
              nameAr: 'تهيئة العملات وأسعار الصرف',
              nameEn: 'Currencies & Rates',
              screenType: ScreenType.config,
              backendProgress: 100.0,
              frontendProgress: 100.0,
            ),
            ScreenLeaf(
              id: 'gls_scr_2',
              nameAr: 'شجرة الحسابات العامة',
              nameEn: 'Chart of Accounts Tree',
              screenType: ScreenType.inputs,
              backendProgress: 95.0,
              frontendProgress: 85.0,
            ),
            ScreenLeaf(
              id: 'gls_scr_3',
              nameAr: 'قيود اليومية التلقائية',
              nameEn: 'Daily Journal Entries',
              screenType: ScreenType.transaction,
              backendProgress: 90.0,
              frontendProgress: 80.0,
            ),
            ScreenLeaf(
              id: 'gls_scr_4',
              nameAr: 'ميزان المراجعة والقوائم المالية',
              nameEn: 'Trial Balance & Financials',
              screenType: ScreenType.reports,
              backendProgress: 80.0,
              frontendProgress: 70.0,
            ),
          ],
        ),
      ],
    ),
    OnyxModule(
      code: 'POS',
      nameAr: 'نقاط البيع السريعة',
      nameEn: 'Point of Sale',
      description: 'كاشير التجزئة ومنافذ البيع المباشرة',
      assignedTeamId: 'team_sales',
      assignedTeamName: 'فريق المبيعات ونقاط البيع (Sales & POS)',
      subModules: const [
        SubModuleEntity(
          id: 'pos_sub_cashier',
          nameAr: 'عمليات الكاشير والورديات',
          nameEn: 'Cashier & Shift Operations',
          screens: [
            ScreenLeaf(
              id: 'pos_scr_1',
              nameAr: 'إعداد أجهزة نقاط البيع وطابعات الفواتير',
              nameEn: 'POS Terminal Setup',
              screenType: ScreenType.config,
              backendProgress: 90.0,
              frontendProgress: 85.0,
            ),
            ScreenLeaf(
              id: 'pos_scr_2',
              nameAr: 'شاشة كاشير المبيعات اللمسية',
              nameEn: 'Touch POS Cashier',
              screenType: ScreenType.transaction,
              backendProgress: 95.0,
              frontendProgress: 90.0,
            ),
            ScreenLeaf(
              id: 'pos_scr_3',
              nameAr: 'إغلاق الوردية وتوريد الصندوق',
              nameEn: 'Shift Close & Cash Drop',
              screenType: ScreenType.transaction,
              backendProgress: 85.0,
              frontendProgress: 80.0,
            ),
            ScreenLeaf(
              id: 'pos_scr_4',
              nameAr: 'تقرير مبيعات الكاشير اليومية',
              nameEn: 'Daily POS Sales Report',
              screenType: ScreenType.reports,
              backendProgress: 75.0,
              frontendProgress: 70.0,
            ),
          ],
        ),
      ],
    ),
    const OnyxModule(
      code: 'GNR',
      nameAr: 'عام / النظام المشترك',
      nameEn: 'General / Core',
      description: 'الوظائف والخدمات العامة المشتركة لكافة الأنظمة',
    ),
    const OnyxModule(
      code: 'ADM',
      nameAr: 'الإدارة العامة والتهيئة',
      nameEn: 'Administration',
      description: 'إدارة المستخدمين والصلاحيات والتهيئة العامة',
    ),
    const OnyxModule(
      code: 'APS',
      nameAr: 'الموردين والمشتريات',
      nameEn: 'Accounts Payable',
      description: 'فواتير المشتريات، الموردين، وأوامر الشراء',
    ),
    const OnyxModule(
      code: 'FMS',
      nameAr: 'الإدارة المالية والمقبوضات',
      nameEn: 'Financial Management',
      description: 'حركات الصناديق، البنوك، وسندات الصرف والقبض',
    ),
    const OnyxModule(
      code: 'FMT',
      nameAr: 'متابعة وصيانة الأصول',
      nameEn: 'Fixed Assets Maintenance',
      description: 'صيانة وتتبع حركة الأصول والمعدات',
    ),
    const OnyxModule(
      code: 'FAS',
      nameAr: 'الأصول الثابتة',
      nameEn: 'Fixed Assets System',
      description: 'إهلاك وجرد وإدارة الأصول الرأسمالية',
    ),
    const OnyxModule(
      code: 'PRL',
      nameAr: 'الرواتب والأجور',
      nameEn: 'Payroll System',
      description: 'مسيرات الرواتب، البدلات، والاستقطاعات',
    ),
    const OnyxModule(
      code: 'FNG',
      nameAr: 'البصمة والحضور والانصراف',
      nameEn: 'Fingerprint & Attendance',
      description: 'سجلات البصمة، الدوام، والإجازات',
    ),
    const OnyxModule(
      code: 'ARS',
      nameAr: 'العملاء والمبيعات',
      nameEn: 'Accounts Receivable',
      description: 'فواتير المبيعات، عروض الأسعار، وسجلات العملاء',
    ),
    const OnyxModule(
      code: 'HRS',
      nameAr: 'الموارد البشرية',
      nameEn: 'Human Resources',
      description: 'ملفات الموظفين، العقود، والتأمين',
    ),
    const OnyxModule(
      code: 'MIS',
      nameAr: 'المعلومات الإدارية والتقارير',
      nameEn: 'Management Info Systems',
      description: 'التقارير التحليلية ولوحات المؤشرات القيادية',
    ),
    const OnyxModule(
      code: 'CRM',
      nameAr: 'إدارة علاقات العملاء',
      nameEn: 'Customer Relationship',
      description: 'الفرص البيعية، متابعة العملاء، والخطط الشهرية',
    ),
    const OnyxModule(
      code: 'STP',
      nameAr: 'الإعدادات والثوابت',
      nameEn: 'Setup & Parameters',
      description: 'الثوابت الإدارية والمالية للأنظمة',
    ),
    const OnyxModule(
      code: 'MRP',
      nameAr: 'التخطيط والتصنيع',
      nameEn: 'Manufacturing & MRP',
      description: 'أوامر الإنتاج، خطوط التصنيع، ومعادلات المواد',
    ),
    const OnyxModule(
      code: 'HLP',
      nameAr: 'الدعم الفني والمساعدة',
      nameEn: 'Help Desk & Support',
      description: 'تذاكر الدعم الفني وخدمة العملاء',
    ),
    const OnyxModule(
      code: 'RSP',
      nameAr: 'إدارة المطاعم والضيافة',
      nameEn: 'Restaurant POS System',
      description: 'صالات الطعام، الطاولات، وطلبات التوصيل',
    ),
    const OnyxModule(
      code: 'RCU',
      nameAr: 'التوظيف والاستقطاب',
      nameEn: 'Recruitment System',
      description: 'بوابة التوظيف وفرز السير الذاتية',
    ),
  ];
}

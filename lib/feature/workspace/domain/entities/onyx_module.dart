import 'package:equatable/equatable.dart';

class OnyxModule extends Equatable {
  final String code;
  final String nameAr;
  final String nameEn;
  final String description;
  final List<String> screens;
  final List<String> assignedDevs;
  final int totalTasks;
  final int openTasks;

  const OnyxModule({
    required this.code,
    required this.nameAr,
    required this.nameEn,
    this.description = '',
    this.screens = const [],
    this.assignedDevs = const [],
    this.totalTasks = 0,
    this.openTasks = 0,
  });

  @override
  List<Object?> get props => [
        code,
        nameAr,
        nameEn,
        description,
        screens,
        assignedDevs,
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
      totalTasks: (map['totalTasks'] as num?)?.toInt() ?? 0,
      openTasks: (map['openTasks'] as num?)?.toInt() ?? 0,
    );
  }

  /// Built-in registry of the 20 Onyx ERP Modules
  static const List<OnyxModule> standardModules = [
    OnyxModule(
      code: 'GNR',
      nameAr: 'عام / النظام المشترك',
      nameEn: 'General / Core',
      description: 'الوظائف والخدمات العامة المشتركة لكافة الأنظمة',
    ),
    OnyxModule(
      code: 'ADM',
      nameAr: 'الإدارة العامة والتهيئة',
      nameEn: 'Administration',
      description: 'إدارة المستخدمين والصلاحيات والتهيئة العامة',
    ),
    OnyxModule(
      code: 'GLS',
      nameAr: 'الأستاذ العام والحسابات',
      nameEn: 'General Ledger',
      description: 'دليل الحسابات، قيود اليومية، ومراكز التكلفة',
    ),
    OnyxModule(
      code: 'APS',
      nameAr: 'الموردين والمشتريات',
      nameEn: 'Accounts Payable',
      description: 'فواتير المشتريات، الموردين، وأوامر الشراء',
    ),
    OnyxModule(
      code: 'FMS',
      nameAr: 'الإدارة المالية والمقبوضات',
      nameEn: 'Financial Management',
      description: 'حركات الصناديق، البنوك، وسندات الصرف والقبض',
    ),
    OnyxModule(
      code: 'INV',
      nameAr: 'المخازن والمستودعات',
      nameEn: 'Inventory Management',
      description: 'بطاقات الأصناف، الجرد، والتحويلات المخزنية',
    ),
    OnyxModule(
      code: 'FMT',
      nameAr: 'متابعة وصيانة الأصول',
      nameEn: 'Fixed Assets Maintenance',
      description: 'صيانة وتتبع حركة الأصول والمعدات',
    ),
    OnyxModule(
      code: 'FAS',
      nameAr: 'الأصول الثابتة',
      nameEn: 'Fixed Assets System',
      description: 'إهلاك وجرد وإدارة الأصول الرأسمالية',
    ),
    OnyxModule(
      code: 'PRL',
      nameAr: 'الرواتب والأجور',
      nameEn: 'Payroll System',
      description: 'مسيرات الرواتب، البدلات، والاستقطاعات',
    ),
    OnyxModule(
      code: 'FNG',
      nameAr: 'البصمة والحضور والانصراف',
      nameEn: 'Fingerprint & Attendance',
      description: 'سجلات البصمة، الدوام، والإجازات',
    ),
    OnyxModule(
      code: 'ARS',
      nameAr: 'العملاء والمبيعات',
      nameEn: 'Accounts Receivable',
      description: 'فواتير المبيعات، عروض الأسعار، وسجلات العملاء',
    ),
    OnyxModule(
      code: 'HRS',
      nameAr: 'الموارد البشرية',
      nameEn: 'Human Resources',
      description: 'ملفات الموظفين، العقود، والتأمين',
    ),
    OnyxModule(
      code: 'MIS',
      nameAr: 'المعلومات الإدارية والتقارير',
      nameEn: 'Management Info Systems',
      description: 'التقارير التحليلية ولوحات المؤشرات القيادية',
    ),
    OnyxModule(
      code: 'CRM',
      nameAr: 'إدارة علاقات العملاء',
      nameEn: 'Customer Relationship',
      description: 'الفرص البيعية، متابعة العملاء، والخطط الشهرية',
    ),
    OnyxModule(
      code: 'STP',
      nameAr: 'الإعدادات والثوابت',
      nameEn: 'Setup & Parameters',
      description: 'الثوابت الإدارية والمالية للأنظمة',
    ),
    OnyxModule(
      code: 'MRP',
      nameAr: 'التخطيط والتصنيع',
      nameEn: 'Manufacturing & MRP',
      description: 'أوامر الإنتاج، خطوط التصنيع، ومعادلات المواد',
    ),
    OnyxModule(
      code: 'HLP',
      nameAr: 'الدعم الفني والمساعدة',
      nameEn: 'Help Desk & Support',
      description: 'تذاكر الدعم الفني وخدمة العملاء',
    ),
    OnyxModule(
      code: 'RSP',
      nameAr: 'إدارة المطاعم والضيافة',
      nameEn: 'Restaurant POS System',
      description: 'صالات الطعام، الطاولات، وطلبات التوصيل',
    ),
    OnyxModule(
      code: 'RCU',
      nameAr: 'التوظيف والاستقطاب',
      nameEn: 'Recruitment System',
      description: 'بوابة التوظيف وفرز السير الذاتية',
    ),
    OnyxModule(
      code: 'POS',
      nameAr: 'نقاط البيع السريعة',
      nameEn: 'Point of Sale',
      description: 'كاشير التجزئة ومنافذ البيع المباشرة',
    ),
  ];
}

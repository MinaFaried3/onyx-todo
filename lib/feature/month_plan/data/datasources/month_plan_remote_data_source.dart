import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_entity.dart';

abstract interface class MonthPlanRemoteDataSource {
  Future<List<MonthlyPlanEntity>> getPlans({int? month, int? year, String? developerName});
  Future<MonthlyPlanEntity?> getPlanById(String planId);
  Future<void> savePlan(MonthlyPlanEntity plan);
  Future<void> updatePlanStatus({
    required String planId,
    required String status,
    String? managerNotes,
  });
}

class MonthPlanRemoteDataSourceImpl implements MonthPlanRemoteDataSource {
  final FirebaseFirestore? _firestore;
  static final List<MonthlyPlanEntity> _memoryPlans = [];

  MonthPlanRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore;

  CollectionReference<Map<String, dynamic>>? get _collection {
    try {
      return _firestore?.collection('monthly_plans');
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<MonthlyPlanEntity>> getPlans({int? month, int? year, String? developerName}) async {
    try {
      if (_collection != null) {
        Query<Map<String, dynamic>> query = _collection!;
        if (month != null) query = query.where('month', isEqualTo: month);
        if (year != null) query = query.where('year', isEqualTo: year);
        if (developerName != null && developerName.isNotEmpty) {
          query = query.where('developerName', isEqualTo: developerName);
        }

        final snapshot = await query.get(const GetOptions(source: Source.serverAndCache));
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs
              .map((doc) => MonthlyPlanEntity.fromMap(doc.data(), doc.id))
              .toList();
        }
      }
    } catch (e) {
      Printer.logger('Firestore getPlans notice (memory fallback): $e');
    }

    var list = List<MonthlyPlanEntity>.from(_memoryPlans);
    if (month != null) list = list.where((p) => p.month == month).toList();
    if (year != null) list = list.where((p) => p.year == year).toList();
    if (developerName != null && developerName.isNotEmpty) {
      list = list.where((p) => p.developerName == developerName).toList();
    }
    return list;
  }

  @override
  Future<MonthlyPlanEntity?> getPlanById(String planId) async {
    try {
      if (_collection != null) {
        final doc = await _collection!.doc(planId).get();
        if (doc.exists) {
          return MonthlyPlanEntity.fromMap(doc.data()!, doc.id);
        }
      }
    } catch (e) {
      Printer.logger('Firestore getPlanById notice: $e');
    }

    final index = _memoryPlans.indexWhere((p) => p.id == planId);
    return index != -1 ? _memoryPlans[index] : null;
  }

  @override
  Future<void> savePlan(MonthlyPlanEntity plan) async {
    try {
      if (_collection != null) {
        await _collection!.doc(plan.id).set(plan.toMap(), SetOptions(merge: true));
      }
    } catch (e) {
      Printer.logger('Firestore savePlan error: $e');
    }

    final index = _memoryPlans.indexWhere((p) => p.id == plan.id);
    if (index != -1) {
      _memoryPlans[index] = plan;
    } else {
      _memoryPlans.add(plan);
    }
  }

  @override
  Future<void> updatePlanStatus({
    required String planId,
    required String status,
    String? managerNotes,
  }) async {
    try {
      if (_collection != null) {
        final updateData = <String, dynamic>{'status': status};
        if (managerNotes != null) updateData['managerNotes'] = managerNotes;
        await _collection!.doc(planId).update(updateData);
      }
    } catch (e) {
      Printer.logger('Firestore updatePlanStatus notice: $e');
    }

    final index = _memoryPlans.indexWhere((p) => p.id == planId);
    if (index != -1) {
      final current = _memoryPlans[index];
      _memoryPlans[index] = current.copyWith(
        status: MonthlyPlanEntity.fromMap({'status': status}).status,
        managerNotes: managerNotes ?? current.managerNotes,
      );
    }
  }
}

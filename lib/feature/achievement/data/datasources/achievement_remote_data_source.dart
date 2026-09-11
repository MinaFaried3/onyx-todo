import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/feature/achievement/domain/entities/daily_achievement_entity.dart';

abstract interface class AchievementRemoteDataSource {
  Future<List<DailyAchievementEntity>> getAchievements({
    DateTime? startDate,
    DateTime? endDate,
    String? developerName,
  });

  Future<void> submitAchievement(DailyAchievementEntity achievement);
}

class AchievementRemoteDataSourceImpl implements AchievementRemoteDataSource {
  final FirebaseFirestore? _firestore;
  static final List<DailyAchievementEntity> _memoryAchievements = [];

  AchievementRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore;

  CollectionReference<Map<String, dynamic>>? get _collection {
    try {
      return _firestore?.collection('daily_achievements');
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<DailyAchievementEntity>> getAchievements({
    DateTime? startDate,
    DateTime? endDate,
    String? developerName,
  }) async {
    try {
      if (_collection != null) {
        Query<Map<String, dynamic>> query = _collection!;

        if (startDate != null) {
          query = query.where('date', isGreaterThanOrEqualTo: startDate.toIso8601String());
        }
        if (endDate != null) {
          query = query.where('date', isLessThanOrEqualTo: endDate.toIso8601String());
        }
        if (developerName != null && developerName.isNotEmpty) {
          query = query.where('developerName', isEqualTo: developerName);
        }

        final snapshot = await query.get(const GetOptions(source: Source.serverAndCache));
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs
              .map((doc) => DailyAchievementEntity.fromMap(doc.data(), doc.id))
              .toList();
        }
      }
    } catch (e) {
      Printer.logger('Firestore getAchievements notice (memory fallback): $e');
    }

    var list = List<DailyAchievementEntity>.from(_memoryAchievements);
    if (startDate != null) {
      list = list.where((a) => a.date.isAfter(startDate.subtract(const Duration(days: 1)))).toList();
    }
    if (endDate != null) {
      list = list.where((a) => a.date.isBefore(endDate.add(const Duration(days: 1)))).toList();
    }
    if (developerName != null && developerName.isNotEmpty) {
      list = list.where((a) => a.developerName == developerName).toList();
    }
    return list;
  }

  @override
  Future<void> submitAchievement(DailyAchievementEntity achievement) async {
    try {
      if (_collection != null) {
        await _collection!.doc(achievement.id).set(achievement.toMap(), SetOptions(merge: true));
      }
    } catch (e) {
      Printer.logger('Firestore submitAchievement error: $e');
    }

    final index = _memoryAchievements.indexWhere((a) => a.id == achievement.id);
    if (index != -1) {
      _memoryAchievements[index] = achievement;
    } else {
      _memoryAchievements.add(achievement);
    }
  }
}

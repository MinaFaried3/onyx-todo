import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/feature/notification/domain/entities/system_notification_entity.dart';

abstract interface class NotificationRemoteDataSource {
  Future<List<SystemNotificationEntity>> getNotifications(String userId);
  Future<void> sendNotification(SystemNotificationEntity notification);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore? firestore;

  // In-memory persistent cache seeded with welcome notification
  static final List<SystemNotificationEntity> _notificationsCache = [
    SystemNotificationEntity(
      id: 'notif_welcome',
      recipientUserId: 'ALL',
      title: 'مرحباً بك في نظام أونكس لإدارة المهام',
      message: 'تم تفعيل نظام إدارة الفرق، تتبع نشاط المستخدمين، والإشعارات المباشرة عبر أنظمة ERP.',
      type: NotificationType.systemAnnouncement,
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  NotificationRemoteDataSourceImpl({this.firestore});

  CollectionReference<Map<String, dynamic>>? get _notificationsCollection {
    try {
      return firestore?.collection('notifications');
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<SystemNotificationEntity>> getNotifications(String userId) async {
    try {
      if (_notificationsCollection != null) {
        final snapshot = await _notificationsCollection!
            .orderBy('createdAt', descending: true)
            .limit(30)
            .get()
            .timeout(const Duration(seconds: 4));
        if (snapshot.docs.isNotEmpty) {
          final dbNotifs = snapshot.docs
              .map((doc) => SystemNotificationEntity.fromMap(doc.data(), doc.id))
              .where((n) => n.recipientUserId == 'ALL' || n.recipientUserId == userId)
              .toList();

          final map = {for (final n in _notificationsCache) n.id: n};
          for (final n in dbNotifs) {
            map[n.id] = n;
          }
          _notificationsCache
            ..clear()
            ..addAll(map.values);
        }
      }
    } catch (e) {
      Printer.logger('NotificationRemoteDataSourceImpl.getNotifications fallback: $e');
    }

    final filtered = _notificationsCache
        .where((n) => n.recipientUserId == 'ALL' || n.recipientUserId == userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(filtered);
  }

  @override
  Future<void> sendNotification(SystemNotificationEntity notification) async {
    _notificationsCache.insert(0, notification);

    try {
      if (_notificationsCollection != null) {
        await _notificationsCollection!.doc(notification.id).set(
              notification.toMap(),
              SetOptions(merge: true),
            );
      }
    } catch (e) {
      Printer.logger('NotificationRemoteDataSource.sendNotification error: $e');
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final idx = _notificationsCache.indexWhere((n) => n.id == notificationId);
    if (idx != -1) {
      _notificationsCache[idx] = _notificationsCache[idx].copyWith(isRead: true);
      try {
        if (_notificationsCollection != null) {
          await _notificationsCollection!.doc(notificationId).update({'isRead': true});
        }
      } catch (_) {}
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    for (var i = 0; i < _notificationsCache.length; i++) {
      if (_notificationsCache[i].recipientUserId == 'ALL' || _notificationsCache[i].recipientUserId == userId) {
        _notificationsCache[i] = _notificationsCache[i].copyWith(isRead: true);
      }
    }

    try {
      if (_notificationsCollection != null) {
        final snapshot = await _notificationsCollection!.where('isRead', isEqualTo: false).get();
        final batch = firestore!.batch();
        for (final doc in snapshot.docs) {
          batch.update(doc.reference, {'isRead': true});
        }
        await batch.commit();
      }
    } catch (_) {}
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_history_item.dart';

abstract interface class TaskRemoteDataSource {
  Future<List<TaskEntity>> getTasks({
    String? moduleCode,
    String? version,
    String? status,
    String? assigneeName,
    int limit = 200,
  });

  Future<TaskEntity> createTask(TaskEntity task);

  Future<void> updateTask(TaskEntity task);

  Future<void> updateTaskStatus({
    required String taskId,
    required String newStatus,
    required String authorName,
    String? note,
  });

  Future<int> getNextSequenceNumber({
    required String version,
    required String moduleCode,
  });

  Future<int> batchImportTasks(List<TaskEntity> tasks);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore? firestore;

  // In-memory fallback / cache for fast local access and testing
  static final List<TaskEntity> _localMemoryTasks = [];

  TaskRemoteDataSourceImpl({this.firestore});

  CollectionReference<Map<String, dynamic>>? get _tasksCollection {
    try {
      return firestore?.collection('tasks');
    } catch (_) {
      return null;
    }
  }

  CollectionReference<Map<String, dynamic>>? get _countersCollection {
    try {
      return firestore?.collection('counters');
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<TaskEntity>> getTasks({
    String? moduleCode,
    String? version,
    String? status,
    String? assigneeName,
    int limit = 1000,
  }) async {
    try {
      if (_tasksCollection != null) {
        Query<Map<String, dynamic>> query = _tasksCollection!;

        if (moduleCode != null && moduleCode != 'ALL' && moduleCode.isNotEmpty) {
          query = query.where('moduleCode', isEqualTo: moduleCode);
        }
        if (version != null && version != 'ALL' && version.isNotEmpty) {
          query = query.where('version', isEqualTo: version);
        }
        if (status != null && status != 'ALL' && status.isNotEmpty) {
          query = query.where('status', isEqualTo: status);
        }

        query = query.limit(limit);

        final snapshot = await query
            .get(const GetOptions(source: Source.serverAndCache))
            .timeout(const Duration(seconds: 2));
        if (snapshot.docs.isNotEmpty) {
          final tasks = snapshot.docs
              .map((doc) => TaskEntity.fromMap(doc.data(), doc.id))
              .toList();

          // Sync to memory cache in O(N)
          final map = {for (final t in _localMemoryTasks) t.formattedId: t};
          for (final t in tasks) {
            map[t.formattedId] = t;
          }
          _localMemoryTasks
            ..clear()
            ..addAll(map.values);
        }
      }
    } catch (e) {
      Printer.logger('Firestore getTasks notice (using cache/memory): $e');
    }

    // Fallback filter over in-memory / imported tasks
    var filtered = List<TaskEntity>.from(_localMemoryTasks);
    if (moduleCode != null && moduleCode != 'ALL' && moduleCode.isNotEmpty) {
      filtered = filtered.where((t) => t.moduleCode == moduleCode).toList();
    }
    if (version != null && version != 'ALL' && version.isNotEmpty) {
      filtered = filtered.where((t) => t.version == version).toList();
    }
    if (status != null && status != 'ALL' && status.isNotEmpty) {
      filtered = filtered.where((t) => t.status.value == status).toList();
    }
    if (assigneeName != null && assigneeName.isNotEmpty) {
      filtered = filtered.where((t) =>
          t.backendDevName == assigneeName ||
          t.frontendDevName == assigneeName ||
          t.middleDevName == assigneeName).toList();
    }
    return filtered;
  }

  @override
  Future<int> getNextSequenceNumber({
    required String version,
    required String moduleCode,
  }) async {
    final cleanVer = version.replaceAll('.', '_');
    final counterId = '${cleanVer}_${moduleCode.toUpperCase()}';

    try {
      if (_countersCollection != null) {
        final docRef = _countersCollection!.doc(counterId);
        final doc = await docRef.get();
        int nextNum = 1;
        if (doc.exists) {
          nextNum = ((doc.data()?['current'] as num?)?.toInt() ?? 0) + 1;
        }
        await docRef.set({'current': nextNum}, SetOptions(merge: true));
        return nextNum;
      }
    } catch (e) {
      Printer.logger('Firestore counter error, using local sequence: $e');
    }

    // Local sequence generator fallback
    final matching = _localMemoryTasks.where(
        (t) => t.version == version && t.moduleCode.toUpperCase() == moduleCode.toUpperCase());
    if (matching.isEmpty) return 1;
    final maxSeq = matching.map((t) => t.sequenceNumber).reduce((a, b) => a > b ? a : b);
    return maxSeq + 1;
  }

  @override
  Future<TaskEntity> createTask(TaskEntity task) async {
    try {
      if (_tasksCollection != null) {
        final docRef = _tasksCollection!.doc(task.id.isEmpty ? null : task.id);
        final savedTask = task.copyWith(id: docRef.id);
        await docRef.set(savedTask.toMap());
        _localMemoryTasks.removeWhere((t) => t.id == savedTask.id);
        _localMemoryTasks.add(savedTask);
        return savedTask;
      }
    } catch (e) {
      Printer.logger('Firestore createTask error, saving locally: $e');
    }

    final id = task.id.isEmpty ? 'task_${DateTime.now().millisecondsSinceEpoch}' : task.id;
    final savedTask = task.copyWith(id: id);
    _localMemoryTasks.removeWhere((t) => t.id == savedTask.id);
    _localMemoryTasks.add(savedTask);
    return savedTask;
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    try {
      if (_tasksCollection != null && task.id.isNotEmpty) {
        await _tasksCollection!.doc(task.id).set(task.toMap(), SetOptions(merge: true));
      }
    } catch (e) {
      Printer.logger('Firestore updateTask error: $e');
    }

    final index = _localMemoryTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _localMemoryTasks[index] = task;
    } else {
      _localMemoryTasks.add(task);
    }
  }

  @override
  Future<void> updateTaskStatus({
    required String taskId,
    required String newStatus,
    required String authorName,
    String? note,
  }) async {
    final historyItem = TaskHistoryItem(
      id: 'h_${DateTime.now().millisecondsSinceEpoch}',
      action: 'status_change',
      authorName: authorName,
      timestamp: DateTime.now(),
      details: 'Status changed to $newStatus${note != null ? ' ($note)' : ''}',
    );

    try {
      if (_tasksCollection != null && taskId.isNotEmpty) {
        await _tasksCollection!.doc(taskId).update({
          'status': newStatus,
          'history': FieldValue.arrayUnion([historyItem.toMap()]),
          if (newStatus.contains('solved') || newStatus == 'closed')
            'resolvedDate': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      Printer.logger('Firestore updateTaskStatus notice: $e');
    }

    final index = _localMemoryTasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final current = _localMemoryTasks[index];
      _localMemoryTasks[index] = current.copyWith(
        status: TaskEntity.fromMap({'status': newStatus}).status,
        history: [...current.history, historyItem],
        resolvedDate: newStatus.contains('solved') || newStatus == 'closed'
            ? DateTime.now()
            : current.resolvedDate,
      );
    }
  }

  @override
  Future<int> batchImportTasks(List<TaskEntity> tasks) async {
    // 1. Immediately store into local memory cache using O(N) Map indexing
    final map = {for (final t in _localMemoryTasks) t.formattedId: t};
    for (final t in tasks) {
      map[t.formattedId] = t;
    }
    _localMemoryTasks
      ..clear()
      ..addAll(map.values);

    // 2. Try Firestore batch write if configured, guarded with a 4s timeout
    try {
      if (_tasksCollection != null) {
        const batchSize = 400; // Under Firestore 500 limit
        for (var i = 0; i < tasks.length; i += batchSize) {
          final chunk = tasks.sublist(
            i,
            (i + batchSize > tasks.length) ? tasks.length : i + batchSize,
          );
          final batch = firestore!.batch();
          for (final task in chunk) {
            final docRef = _tasksCollection!.doc(task.formattedId);
            batch.set(docRef, task.toMap(), SetOptions(merge: true));
          }
          try {
            await batch.commit().timeout(const Duration(seconds: 3));
          } catch (e) {
            Printer.logger('Firestore batch write notice on chunk $i ($e). Falling back to memory storage.');
            break;
          }
        }
      }
    } catch (e) {
      Printer.logger('Firestore batchImportTasks notice (storing in memory): $e');
    }

    return tasks.length;
  }
}

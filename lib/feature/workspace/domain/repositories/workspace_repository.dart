import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/feature/workspace/domain/entities/onyx_module.dart';
import 'package:onyx_todo/feature/workspace/domain/entities/onyx_version.dart';

abstract interface class WorkspaceRepository {
  Future<Either<Failure, List<OnyxModule>>> getModules();
  Future<Either<Failure, List<OnyxVersion>>> getVersions();
  Future<Either<Failure, Unit>> saveModule(OnyxModule module);
}

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final FirebaseFirestore? firestore;
  static final List<OnyxModule> _memoryModules = List.from(OnyxModule.standardModules);
  static final List<OnyxVersion> _memoryVersions = List.from(OnyxVersion.defaultVersions);

  WorkspaceRepositoryImpl({this.firestore});

  CollectionReference<Map<String, dynamic>>? get _modulesCol =>
      firestore?.collection('modules');
  CollectionReference<Map<String, dynamic>>? get _versionsCol =>
      firestore?.collection('versions');

  @override
  Future<Either<Failure, List<OnyxModule>>> getModules() async {
    try {
      if (_modulesCol != null) {
        final snap = await _modulesCol!.get(const GetOptions(source: Source.serverAndCache));
        if (snap.docs.isNotEmpty) {
          final list = snap.docs.map((d) => OnyxModule.fromMap(d.data())).toList();
          return Right(list);
        }
      }
    } catch (e) {
      Printer.logger('Firestore getModules notice: $e');
    }
    return Right(_memoryModules);
  }

  @override
  Future<Either<Failure, List<OnyxVersion>>> getVersions() async {
    try {
      if (_versionsCol != null) {
        final snap = await _versionsCol!.get(const GetOptions(source: Source.serverAndCache));
        if (snap.docs.isNotEmpty) {
          final list = snap.docs.map((d) => OnyxVersion.fromMap(d.data())).toList();
          return Right(list);
        }
      }
    } catch (e) {
      Printer.logger('Firestore getVersions notice: $e');
    }
    return Right(_memoryVersions);
  }

  @override
  Future<Either<Failure, Unit>> saveModule(OnyxModule module) async {
    try {
      if (_modulesCol != null) {
        await _modulesCol!.doc(module.code).set(module.toMap(), SetOptions(merge: true));
      }
    } catch (e) {
      Printer.logger('Firestore saveModule notice: $e');
    }
    final index = _memoryModules.indexWhere((m) => m.code == module.code);
    if (index != -1) {
      _memoryModules[index] = module;
    } else {
      _memoryModules.add(module);
    }
    return const Right(unit);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/feature/team/domain/entities/team_entity.dart';

abstract interface class TeamRemoteDataSource {
  Future<List<TeamEntity>> getTeams();
  Future<TeamEntity?> getTeamById(String id);
  Future<void> createTeam(TeamEntity team);
  Future<void> updateTeam(TeamEntity team);
  Future<void> deleteTeam(String id);
  Future<void> assignMember(String teamId, String userId);
}

class TeamRemoteDataSourceImpl implements TeamRemoteDataSource {
  final FirebaseFirestore? firestore;

  // In-memory persistent cache seeded with default teams
  static final List<TeamEntity> _teamsCache = List.of(TeamEntity.defaultTeams);

  TeamRemoteDataSourceImpl({this.firestore});

  CollectionReference<Map<String, dynamic>>? get _teamsCollection {
    try {
      return firestore?.collection('teams');
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<TeamEntity>> getTeams() async {
    try {
      if (_teamsCollection != null) {
        final snapshot = await _teamsCollection!.get().timeout(const Duration(seconds: 4));
        if (snapshot.docs.isNotEmpty) {
          final dbTeams = snapshot.docs.map((doc) => TeamEntity.fromMap(doc.data(), doc.id)).toList();
          final map = {for (final t in _teamsCache) t.id: t};
          for (final t in dbTeams) {
            map[t.id] = t;
          }
          _teamsCache
            ..clear()
            ..addAll(map.values);
          return List.unmodifiable(_teamsCache);
        }
      }
    } catch (e) {
      Printer.logger('TeamRemoteDataSourceImpl.getTeams fallback: $e');
    }
    return List.unmodifiable(_teamsCache);
  }

  @override
  Future<TeamEntity?> getTeamById(String id) async {
    final cached = _teamsCache.where((t) => t.id == id).firstOrNull;
    if (cached != null) return cached;

    try {
      if (_teamsCollection != null) {
        final doc = await _teamsCollection!.doc(id).get().timeout(const Duration(seconds: 3));
        if (doc.exists && doc.data() != null) {
          final team = TeamEntity.fromMap(doc.data()!, doc.id);
          _teamsCache.add(team);
          return team;
        }
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<void> createTeam(TeamEntity team) async {
    _teamsCache.removeWhere((t) => t.id == team.id);
    _teamsCache.add(team);

    try {
      if (_teamsCollection != null) {
        await _teamsCollection!.doc(team.id).set(team.toMap(), SetOptions(merge: true));
      }
    } catch (e) {
      Printer.logger('TeamRemoteDataSource.createTeam error: $e');
    }
  }

  @override
  Future<void> updateTeam(TeamEntity team) => createTeam(team);

  @override
  Future<void> deleteTeam(String id) async {
    _teamsCache.removeWhere((t) => t.id == id);

    try {
      if (_teamsCollection != null) {
        await _teamsCollection!.doc(id).delete();
      }
    } catch (e) {
      Printer.logger('TeamRemoteDataSource.deleteTeam error: $e');
    }
  }

  @override
  Future<void> assignMember(String teamId, String userId) async {
    final idx = _teamsCache.indexWhere((t) => t.id == teamId);
    if (idx != -1) {
      final team = _teamsCache[idx];
      if (!team.memberIds.contains(userId)) {
        final updated = team.copyWith(memberIds: [...team.memberIds, userId]);
        _teamsCache[idx] = updated;
        try {
          if (_teamsCollection != null) {
            await _teamsCollection!.doc(teamId).update({
              'memberIds': FieldValue.arrayUnion([userId]),
            });
          }
        } catch (_) {}
      }
    }
  }
}

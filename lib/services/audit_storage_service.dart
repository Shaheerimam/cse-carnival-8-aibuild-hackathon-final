import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/audit_session.dart';

/// Persists audit sessions locally using SharedPreferences.
/// Sessions are stored as a JSON list under the key [_key].
///
/// NOTE: SharedPreferences is used here for simplicity.
/// Replace with Hive for better performance with large datasets.
class AuditStorageService {
  AuditStorageService._();
  static final AuditStorageService instance = AuditStorageService._();

  static const String _key = 'audit_sessions_v1';

  /// Load all stored audit sessions, newest first.
  Future<List<AuditSession>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      final sessions = list
          .map((e) => AuditSession.fromJson(e as Map<String, dynamic>))
          .toList();
      sessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return sessions;
    } catch (_) {
      return [];
    }
  }

  /// Save or replace a single session (matched by [id]).
  Future<void> save(AuditSession session) async {
    final sessions = await loadAll();
    final idx = sessions.indexWhere((s) => s.id == session.id);
    if (idx >= 0) {
      sessions[idx] = session;
    } else {
      sessions.insert(0, session);
    }
    await _persist(sessions);
  }

  /// Delete a session by [id].
  Future<void> delete(String id) async {
    final sessions = await loadAll();
    sessions.removeWhere((s) => s.id == id);
    await _persist(sessions);
  }

  Future<void> _persist(List<AuditSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}

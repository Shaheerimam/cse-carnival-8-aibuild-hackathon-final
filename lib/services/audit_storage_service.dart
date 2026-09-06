import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/audit_session.dart';
import 'firestore_service.dart';

/// Persists audit sessions using Firestore (primary) + SharedPreferences (offline fallback).
/// Sessions are stored in Firestore at users/{uid}/audits/{id} and locally under [_key].
class AuditStorageService {
  AuditStorageService._();
  static final AuditStorageService instance = AuditStorageService._();

  final FirestoreService _firestore = FirestoreService.instance;
  static const String _key = 'audit_sessions_v1';

  /// Load all stored audit sessions, newest first.
  /// Tries Firestore first, falls back to SharedPreferences.
  Future<List<AuditSession>> loadAll() async {
    try {
      final firestoreSessions = await _firestore.loadAllAudits();
      if (firestoreSessions.isNotEmpty) {
        // Sync Firestore data to local cache
        await _persistLocal(firestoreSessions);
        return firestoreSessions;
      }
    } catch (_) {
      // Firestore unavailable — fall through to SharedPreferences
    }

    // Fallback to SharedPreferences
    return _loadLocal();
  }

  /// Save or replace a single session (matched by [id]).
  /// Writes to both Firestore and SharedPreferences.
  Future<void> save(AuditSession session) async {
    // Write to Firestore (fire-and-forget for speed)
    _firestore.saveAudit(session);

    // Write to local cache
    final sessions = await _loadLocal();
    final idx = sessions.indexWhere((s) => s.id == session.id);
    if (idx >= 0) {
      sessions[idx] = session;
    } else {
      sessions.insert(0, session);
    }
    await _persistLocal(sessions);
  }

  /// Delete a session by [id] from both Firestore and local storage.
  Future<void> delete(String id) async {
    _firestore.deleteAudit(id);

    final sessions = await _loadLocal();
    sessions.removeWhere((s) => s.id == id);
    await _persistLocal(sessions);
  }

  /// Load from SharedPreferences only.
  Future<List<AuditSession>> _loadLocal() async {
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

  /// Persist to SharedPreferences.
  Future<void> _persistLocal(List<AuditSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}

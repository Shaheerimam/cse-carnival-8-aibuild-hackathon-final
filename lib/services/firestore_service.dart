import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/audit_session.dart';
import 'firebase_auth_service.dart';

/// Firestore CRUD operations for audit sessions.
/// Data path: users/{uid}/audits/{id}
class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuthService _auth = FirebaseAuthService.instance;

  /// Reference to the current user's audits collection.
  CollectionReference<Map<String, dynamic>> get _auditsRef =>
      _db.collection('users').doc(_auth.uid).collection('audits');

  /// Save or update an audit session in Firestore.
  Future<void> saveAudit(AuditSession session) async {
    try {
      await _auditsRef.doc(session.id).set(session.toJson());
    } catch (e) {
      // Silently fail — SharedPreferences is the offline fallback
      // ignore: avoid_print
      print('Firestore saveAudit failed: $e');
    }
  }

  /// Load all audit sessions for the current user, newest first.
  Future<List<AuditSession>> loadAllAudits() async {
    try {
      final snapshot = await _auditsRef
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => AuditSession.fromJson(doc.data()))
          .toList();
    } catch (e) {
      // Return empty on failure — caller should fall back to SharedPreferences
      return [];
    }
  }

  /// Delete a specific audit session.
  Future<void> deleteAudit(String id) async {
    try {
      await _auditsRef.doc(id).delete();
    } catch (e) {
      print('Firestore deleteAudit failed: $e');
    }
  }

  /// Real-time stream of audit sessions for dashboard.
  Stream<List<AuditSession>> streamAudits() {
    return _auditsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AuditSession.fromJson(doc.data()))
            .toList());
  }
}

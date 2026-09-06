import 'package:flutter/foundation.dart';
import '../models/audit_session.dart';
import '../services/gemini_service.dart';
import '../services/audit_storage_service.dart';

enum AuditProviderStatus { idle, processing, success, error }

class AuditProvider extends ChangeNotifier {
  final GeminiService _gemini = GeminiService.instance;
  final AuditStorageService _storage = AuditStorageService.instance;

  // ── State ─────────────────────────────────────────────────────────────────
  AuditProviderStatus _status = AuditProviderStatus.idle;
  AuditProviderStatus get status => _status;

  List<AuditSession> _history = [];
  List<AuditSession> get history => List.unmodifiable(_history);

  AuditSession? _currentSession;
  AuditSession? get currentSession => _currentSession;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  int _processingStep = 0;
  int get processingStep => _processingStep;

  // ── Reskinner State ────────────────────────────────────────────────────────
  bool _reskinnerLoading = false;
  bool get reskinnerLoading => _reskinnerLoading;

  List<String> _reskinnerVariants = [];
  List<String> get reskinnerVariants => List.unmodifiable(_reskinnerVariants);

  String _reskinnerError = '';
  String get reskinnerError => _reskinnerError;

  // ── Initialisation ─────────────────────────────────────────────────────────
  Future<void> loadHistory() async {
    _history = await _storage.loadAll();
    notifyListeners();
  }

  // ── Start Audit ────────────────────────────────────────────────────────────
  Future<void> startAudit({
    required String courseTitle,
    required String syllabusText,
    required String examText,
  }) async {
    _status = AuditProviderStatus.processing;
    _processingStep = 0;
    _errorMessage = '';
    notifyListeners();

    final session = AuditSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      courseTitle: courseTitle.isEmpty ? 'Untitled Exam' : courseTitle,
      syllabusText: syllabusText,
      examText: examText,
      createdAt: DateTime.now(),
      status: AuditStatus.processing,
    );

    _currentSession = session;
    await _storage.save(session);
    await _loadHistory();

    // Simulate step progression
    for (int i = 0; i < 7; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      _processingStep = i + 1;
      notifyListeners();
    }

    try {
      final report = await _gemini.auditExam(
        syllabusText: syllabusText,
        examText: examText,
      );

      final completed = session.copyWith(
        status: AuditStatus.complete,
        report: report,
      );
      _currentSession = completed;
      await _storage.save(completed);
      await _loadHistory();
      _status = AuditProviderStatus.success;
    } catch (e) {
      _errorMessage = e.toString();
      final failed = session.copyWith(
        status: AuditStatus.error,
        errorMessage: _errorMessage,
      );
      _currentSession = failed;
      await _storage.save(failed);
      await _loadHistory();
      _status = AuditProviderStatus.error;
    }

    notifyListeners();
  }

  // ── Reskinner ──────────────────────────────────────────────────────────────
  Future<void> generateVariants(
      covariant dynamic question) async {
    _reskinnerLoading = true;
    _reskinnerVariants = [];
    _reskinnerError = '';
    notifyListeners();

    try {
      _reskinnerVariants = await _gemini.reskinQuestion(question);
    } catch (e) {
      _reskinnerError = e.toString();
    }

    _reskinnerLoading = false;
    notifyListeners();
  }

  // ── Delete Session ─────────────────────────────────────────────────────────
  Future<void> deleteSession(String id) async {
    await _storage.delete(id);
    await _loadHistory();
    if (_currentSession?.id == id) {
      _currentSession = null;
    }
    notifyListeners();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Future<void> _loadHistory() async {
    _history = await _storage.loadAll();
  }

  void setCurrentSession(AuditSession session) {
    _currentSession = session;
    notifyListeners();
  }

  void reset() {
    _status = AuditProviderStatus.idle;
    _processingStep = 0;
    _errorMessage = '';
    _reskinnerVariants = [];
    _reskinnerError = '';
    notifyListeners();
  }
}

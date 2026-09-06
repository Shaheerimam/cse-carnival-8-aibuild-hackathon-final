import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../services/firebase_auth_service.dart';

/// Auth state provider — manages anonymous Firebase authentication.
class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService.instance;

  // ── State ──────────────────────────────────────────────────────────────────
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  User? _user;
  User? get user => _user;

  String get uid => _user?.uid ?? 'anonymous';

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ── Initialisation ─────────────────────────────────────────────────────────

  /// Called once at app startup. Signs in anonymously.
  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.signInAnonymously();
      _isAuthenticated = _user != null;
    } catch (e) {
      _errorMessage = e.toString();
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  /// Re-authenticate (sign in anonymously again after sign out).
  Future<void> signInAgain() async {
    await initialize();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../services/firebase_auth_service.dart';

/// Auth state provider — manages the signed-in faculty member.
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

  /// Called once at app startup and restores an existing Firebase session.
  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = _authService.currentUser;
      _isAuthenticated = _user != null;
    } catch (e) {
      _errorMessage = e.toString();
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    return _runAuth(
      () => _authService.signIn(email: email, password: password),
    );
  }

  Future<bool> signUp(String email, String password) async {
    return _runAuth(
      () => _authService.signUp(email: email, password: password),
    );
  }

  Future<void> resetPassword(String email) async {
    _errorMessage = null;
    try {
      await _authService.sendPasswordResetEmail(email);
    } on FirebaseAuthException catch (e) {
      _errorMessage = _friendlyMessage(e);
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> _runAuth(Future<User?> Function() operation) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await operation();
      _isAuthenticated = _user != null;
      return _isAuthenticated;
    } on FirebaseAuthException catch (e) {
      _isAuthenticated = false;
      _errorMessage = _friendlyMessage(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _friendlyMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'That email or password is not correct.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'Use a password with at least 6 characters.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}

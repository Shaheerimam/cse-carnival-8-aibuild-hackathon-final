import 'package:firebase_auth/firebase_auth.dart';

/// Wrapper around Firebase Authentication.
/// Uses anonymous auth for a frictionless hackathon demo experience.
class FirebaseAuthService {
  FirebaseAuthService._();
  static final FirebaseAuthService instance = FirebaseAuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Current authenticated user, or null.
  User? get currentUser => _auth.currentUser;

  /// Whether a user is currently signed in.
  bool get isAuthenticated => _auth.currentUser != null;

  /// UID of the current user, or 'anonymous'.
  String get uid => _auth.currentUser?.uid ?? 'anonymous';

  /// Stream of authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in anonymously — creates a temporary account for hackathon use.
  /// If already signed in, returns the existing user.
  Future<User?> signInAnonymously() async {
    if (_auth.currentUser != null) return _auth.currentUser;
    final credential = await _auth.signInAnonymously();
    return credential.user;
  }

  /// Sign up with email and password
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  /// Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

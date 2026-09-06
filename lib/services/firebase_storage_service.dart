import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_auth_service.dart';

/// Wrapper around Firebase Cloud Storage for file uploads.
/// Stores files at: users/{uid}/uploads/{fileName}
class FirebaseStorageService {
  FirebaseStorageService._();
  static final FirebaseStorageService instance = FirebaseStorageService._();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuthService _auth = FirebaseAuthService.instance;

  /// Upload a file and return the download URL.
  Future<String?> uploadFile(Uint8List bytes, String fileName) async {
    try {
      final ref = _storage
          .ref()
          .child('users')
          .child(_auth.uid)
          .child('uploads')
          .child(fileName);

      final uploadTask = await ref.putData(
        bytes,
        SettableMetadata(contentType: 'application/pdf'),
      );

      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Firebase Storage upload failed: $e');
      return null;
    }
  }

  /// Get the download URL for an existing file.
  Future<String?> getDownloadUrl(String path) async {
    try {
      return await _storage.ref(path).getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/models/app_user.dart';
import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository(this._service);

  final AuthService _service;

  Future<bool> isUsernameAvailable(String username) async {
    final usernameLower = username.trim().toLowerCase();

    final snapshot = await _service.usernamesRef.child(usernameLower).get();

    return !snapshot.exists;
  }

  Future<void> register({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    final usernameLower = username.trim().toLowerCase();

    if (!await isUsernameAvailable(usernameLower)) {
      throw Exception('Username already exists.');
    }

    final credential = await _service.register(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user!;

    try {
      final appUser = AppUser(
        uid: firebaseUser.uid,
        email: email.trim(),
        username: username.trim(),
        usernameLower: usernameLower,
        displayName: displayName.trim(),
        photoUrl: null,
        createdAt: 0,
      );

      await _service.usersRef.child(firebaseUser.uid).set({
        ...appUser.toMap(),
        'createdAt': ServerValue.timestamp,
      });

      await _service.usernamesRef.child(usernameLower).set(firebaseUser.uid);
    } catch (e) {
      await firebaseUser.delete();
      rethrow;
    }
  }

  Future<void> login({required String email, required String password}) async {
    await _service.signIn(email: email, password: password);    
  }

  Future<void> logout() async {
  await _service.signOut();
}

  Future<void> forgotPassword(String email) {
    return _service.sendPasswordResetEmail(email);
  }

  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = _service.currentUser;

    if (firebaseUser == null) return null;

    final snapshot = await _service.usersRef.child(firebaseUser.uid).get();

    if (!snapshot.exists) return null;

    return AppUser.fromMap(snapshot.value as Map<dynamic, dynamic>);
  }

  Stream<User?> authStateChanges() {
    return _service.authStateChanges();
  }
}

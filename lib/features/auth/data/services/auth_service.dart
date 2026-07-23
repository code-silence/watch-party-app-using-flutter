import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  AuthService._();

  static final instance = AuthService._();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase database = FirebaseDatabase.instance;

  DatabaseReference get usersRef => database.ref('users');

  DatabaseReference get usernamesRef => database.ref('usernames');

  User? get currentUser => auth.currentUser;

  Stream<User?> authStateChanges() => auth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> register({
    required String email,
    required String password,
  }) {
    return auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail(String email) {
    return auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}

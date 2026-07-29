import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/auth_repository.dart';
import 'auth_provider.dart';
import 'auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthState> {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.read(authRepositoryProvider);
    return AuthState.initial();
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.login(email: email, password: password);

      final user = await _repository.getCurrentUser();

      state = AuthState(user: user);
    } on FirebaseAuthException catch (e) {
      final message = _getErrorMessage(e);

      state = AuthState(isLoading: false, error: message);

      throw Exception(message);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.register(
        email: email,
        password: password,
        username: username,
        displayName: displayName,
      );

      final user = await _repository.getCurrentUser();

      state = AuthState(user: user);
    } on FirebaseAuthException catch (e) {
      final message = _getErrorMessage(e);

      state = AuthState(isLoading: false, error: message);

      throw Exception(message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());

      rethrow;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState.initial();
  }

  Future<void> forgotPassword(String email) {
    return _repository.forgotPassword(email);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/auth_repository.dart';
import 'auth_provider.dart';
import 'auth_state.dart';

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthState> {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.read(authRepositoryProvider);
    return AuthState.initial();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      await _repository.login(
        email: email,
        password: password,
      );

      final user = await _repository.getCurrentUser();

      state = AuthState(
        user: user,
      );
    } catch (e) {
      state = AuthState(
        error: e.toString(),
      );

      rethrow;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      await _repository.register(
        email: email,
        password: password,
        username: username,
        displayName: displayName,
      );

      final user = await _repository.getCurrentUser();

      state = AuthState(
        user: user,
      );
    } catch (e) {
      state = AuthState(
        error: e.toString(),
      );

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
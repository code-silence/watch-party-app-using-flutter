import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/app_user.dart';
import '../data/repositories/auth_repository.dart';
import '../data/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(authServiceProvider),
  );
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authRepositoryProvider).authStateChanges();
});

final currentUserProvider = FutureProvider<AppUser?>((ref) {
  return ref.read(authRepositoryProvider).getCurrentUser();
});
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import '../data/repositories/profile_repository.dart';
import '../models/profile_model.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
    ref.read(authServiceProvider),
  );
});

final profileProvider = FutureProvider<ProfileModel>((ref) {
  return ref.read(profileRepositoryProvider).getProfile();
});
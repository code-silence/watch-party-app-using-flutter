import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import '../data/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
    ref.read(authServiceProvider),
  );
});


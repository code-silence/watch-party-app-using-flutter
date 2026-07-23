import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import '../data/repositories/youtube_repository.dart';

final youTubeRepositoryProvider =
    Provider<YouTubeRepository>((ref) {
  return YouTubeRepository(
    ref.read(authServiceProvider),
  );
});
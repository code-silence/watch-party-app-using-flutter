import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/providers/profile_provider.dart';

final activeRoomProvider = Provider<String?>((ref) {
  final profile = ref.watch(profileProvider);

  return profile.when(
    data: (user) => user.activeRoomCode,
    loading: () => null,
    error: (_, __) => null,
  );
});

final isHostingProvider = Provider<bool>((ref) {
  final roomCode = ref.watch(activeRoomProvider);
  return roomCode != null && roomCode.isNotEmpty;
});
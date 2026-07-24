import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../..../../auth/providers/auth_provider.dart';
import '../models/chat_message.dart';
import '../repositories/chat_repository.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(
    ref.read(authServiceProvider),
  );
});

final chatProvider =
    StreamProvider.family<List<ChatMessage>, String>((ref, roomCode) {
  return ref.read(chatRepositoryProvider).messages(roomCode);
});
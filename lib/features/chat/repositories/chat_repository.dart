import 'package:firebase_database/firebase_database.dart';

import '../../auth/data/services/auth_service.dart';
import '../models/chat_message.dart';

class ChatRepository {
  ChatRepository(this._authService);

  final AuthService _authService;

  DatabaseReference _chatRef(String roomCode) {
    return _authService.database
        .ref('rooms')
        .child(roomCode)
        .child('chat');
  }

  Future<void> sendMessage({
    required String roomCode,
    required String message,
  }) async {
    final firebaseUser = _authService.currentUser!;

    final snapshot = await _authService.usersRef
        .child(firebaseUser.uid)
        .get();

    final user = snapshot.value as Map<dynamic, dynamic>;

    await _chatRef(roomCode).push().set({
      'senderUid': firebaseUser.uid,
      'displayName': user['displayName'],
      'avatar': user['avatar'],
      'message': message.trim(),
      'createdAt': ServerValue.timestamp,
    });
  }

  Stream<List<ChatMessage>> messages(String roomCode) {
    return _chatRef(roomCode)
        .orderByChild('createdAt')
        .onValue
        .map((event) {
      final List<ChatMessage> list = [];

      if (!event.snapshot.exists) return list;

      final map = event.snapshot.value as Map<dynamic, dynamic>;

      map.forEach((key, value) {
        list.add(
          ChatMessage.fromMap(
            key.toString(),
            value,
          ),
        );
      });

      list.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      return list;
    });
  }
}
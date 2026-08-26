import 'package:firebase_database/firebase_database.dart';

import '../../auth/data/services/auth_service.dart';
import '../models/chat_message.dart';

class ChatRepository {
  ChatRepository(this._authService);

  final AuthService _authService;

  DatabaseReference _chatRef(String roomCode) {
    return _authService.database.ref('rooms').child(roomCode).child('chat');
  }

  DatabaseReference _lastReadRef(String roomCode) {
    return _authService.database
        .ref('rooms')
        .child(roomCode)
        .child('lastRead')
        .child(_authService.currentUser!.uid);
  }

  Future<void> markAsRead(String roomCode) async {
    await _lastReadRef(roomCode).set(ServerValue.timestamp);
  }

  Stream<bool> hasUnreadMessages(String roomCode) {
    final uid = _authService.currentUser!.uid;

    return _authService.database.ref('rooms').child(roomCode).onValue.asyncMap((
      event,
    ) async {
      if (!event.snapshot.exists) return false;

      final room = event.snapshot.value as Map<dynamic, dynamic>;

      int lastRead = 0;

      if (room['lastRead'] != null && room['lastRead'][uid] != null) {
        lastRead = room['lastRead'][uid] as int;
      }

      int latestMessage = 0;

      if (room['chat'] != null) {
        final chat = room['chat'] as Map<dynamic, dynamic>;

        for (final value in chat.values) {
          final createdAt = value['createdAt'] as int? ?? 0;

          if (createdAt > latestMessage) {
            latestMessage = createdAt;
          }
        }
      }

      return latestMessage > lastRead;
    });
  }

  Future<void> sendMessage({
    required String roomCode,
    required String message,
  }) async {
    final firebaseUser = _authService.currentUser!;

    final snapshot = await _authService.usersRef.child(firebaseUser.uid).get();

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
    return _chatRef(roomCode).orderByChild('createdAt').onValue.map((event) {
      final List<ChatMessage> list = [];

      if (!event.snapshot.exists) return list;

      final map = event.snapshot.value as Map<dynamic, dynamic>;

      map.forEach((key, value) {
        list.add(ChatMessage.fromMap(key.toString(), value));
      });

      list.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      return list;
    });
  }
}

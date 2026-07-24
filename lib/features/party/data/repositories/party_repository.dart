import 'dart:math';

import 'package:firebase_database/firebase_database.dart';

import '../../../auth/data/services/auth_service.dart';
import '../models/party_room.dart';

class PartyRepository {
  PartyRepository(this._authService);

  final AuthService _authService;

  DatabaseReference get _roomsRef => _authService.database.ref('rooms');

  static const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  String _generateRoomCode() {
    final random = Random();

    return List.generate(
      6,
      (_) => _chars[random.nextInt(_chars.length)],
    ).join();
  }

  Future<String> createRoom() async {
    final firebaseUser = _authService.currentUser!;

    final userSnapshot = await _authService.usersRef
        .child(firebaseUser.uid)
        .get();

    final user = userSnapshot.value as Map<dynamic, dynamic>;

    String roomCode;

    while (true) {
      roomCode = _generateRoomCode();

      final exists = await _roomsRef.child(roomCode).get();

      if (!exists.exists) break;
    }

    final roomRef = _roomsRef.child(roomCode);

    await roomRef.set({
      'hostUid': firebaseUser.uid,
      'video': {
        'videoId': '',
        'isPlaying': false,
        'position': 0,
        'updatedAt': ServerValue.timestamp,
      },
      'createdAt': ServerValue.timestamp,
      'lastHeartbeat': ServerValue.timestamp,
      'participants': {
        firebaseUser.uid: {
          'displayName': user['displayName'],
          'avatar': user['avatar'],
        },
      },
    });

    roomRef.onDisconnect().remove();

    return roomCode;
  }

  Future<void> joinRoom(String roomCode) async {
    final firebaseUser = _authService.currentUser!;

    final roomRef = _roomsRef.child(roomCode.toUpperCase());

    final roomSnapshot = await roomRef.get();

    if (!roomSnapshot.exists) {
      throw Exception('Room not found.');
    }

    final userSnapshot = await _authService.usersRef
        .child(firebaseUser.uid)
        .get();

    final user = userSnapshot.value as Map<dynamic, dynamic>;

    await roomRef.child('participants').child(firebaseUser.uid).set({
      'displayName': user['displayName'],
      'avatar': user['avatar'],
    });
  }

  Future<void> leaveRoom(String roomCode) async {
    final user = _authService.currentUser!;

    final roomRef = _roomsRef.child(roomCode);

    final snapshot = await roomRef.get();

    if (!snapshot.exists) return;

    final room = PartyRoom.fromMap(
      roomCode,
      snapshot.value as Map<dynamic, dynamic>,
    );

    if (room.hostUid == user.uid) {
      await roomRef.remove();
      return;
    }

    await roomRef.child('participants').child(user.uid).remove();
  }

  Future<void> updateHeartbeat(String roomCode) async {
    await _roomsRef.child(roomCode).update({
      'lastHeartbeat': ServerValue.timestamp,
    });
  }

  Future<void> deleteRoom(String roomCode) async {
    await _roomsRef.child(roomCode).remove();
  }

  Future<PartyRoom?> getRoom(String roomCode) async {
    final snapshot = await _roomsRef.child(roomCode).get();

    if (!snapshot.exists) {
      return null;
    }

    return PartyRoom.fromMap(roomCode, snapshot.value as Map<dynamic, dynamic>);
  }

  Stream<PartyRoom?> roomStream(String roomCode) {
    return _roomsRef.child(roomCode).onValue.map((event) {
      if (!event.snapshot.exists) {
        return null;
      }

      return PartyRoom.fromMap(
        roomCode,
        event.snapshot.value as Map<dynamic, dynamic>,
      );
    });
  }
}

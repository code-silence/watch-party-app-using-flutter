import 'package:firebase_database/firebase_database.dart';

import '../../../auth/data/services/auth_service.dart';

class YouTubeService {
  YouTubeService(this._authService);

  final AuthService _authService;

  DatabaseReference roomVideoRef(String roomCode) {
    return _authService.database
        .ref('rooms')
        .child(roomCode)
        .child('video');
  }

  Future<void> loadVideo({
    required String roomCode,
    required String videoId,
  }) async {
    await roomVideoRef(roomCode).update({
      'videoId': videoId,
      'position': 0,
      'isPlaying': false,
      'updatedAt': ServerValue.timestamp,
    });
  }

  Future<void> play({
    required String roomCode,
    required double position,
  }) async {
    await roomVideoRef(roomCode).update({
      'isPlaying': true,
      'position': position,
      'updatedAt': ServerValue.timestamp,
    });
  }

  Future<void> pause({
    required String roomCode,
    required double position,
  }) async {
    await roomVideoRef(roomCode).update({
      'isPlaying': false,
      'position': position,
      'updatedAt': ServerValue.timestamp,
    });
  }

  Future<void> seek({
    required String roomCode,
    required double position,
    required bool isPlaying,
  }) async {
    await roomVideoRef(roomCode).update({
      'position': position,
      'isPlaying': isPlaying,
      'updatedAt': ServerValue.timestamp,
    });
  }

  Stream<DatabaseEvent> videoStream(String roomCode) {
    return roomVideoRef(roomCode).onValue;
  }
}
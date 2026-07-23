import 'package:firebase_database/firebase_database.dart';

import '../../../auth/data/services/auth_service.dart';

class YouTubeRepository {
  YouTubeRepository(this._authService);

  final AuthService _authService;

  DatabaseReference _videoRef(String roomCode) {
    return _authService.database
        .ref('rooms')
        .child(roomCode)
        .child('video');
  }

  Future<void> loadVideo({
    required String roomCode,
    required String videoId,
    required String controllerUid,
  }) async {
    await _videoRef(roomCode).update({
      'videoId': videoId,
      'position': 0,
      'isPlaying': false,
      'updatedAt': ServerValue.timestamp,
      'controllerUid': controllerUid,
    });
  }

  Future<void> play({
    required String roomCode,
    required double position,
    required String controllerUid,
  }) async {
    await _videoRef(roomCode).update({
      'isPlaying': true,
      'position': position,
      'updatedAt': ServerValue.timestamp,
      'controllerUid': controllerUid,
    });
  }

  Future<void> pause({
    required String roomCode,
    required double position,
    required String controllerUid,
  }) async {
    await _videoRef(roomCode).update({
      'isPlaying': false,
      'position': position,
      'updatedAt': ServerValue.timestamp,
      'controllerUid': controllerUid,
    });
  }

  Future<void> seek({
    required String roomCode,
    required double position,
    required bool isPlaying,
    required String controllerUid,
  }) async {
    await _videoRef(roomCode).update({
      'position': position,
      'isPlaying': isPlaying,
      'updatedAt': ServerValue.timestamp,
      'controllerUid': controllerUid,
    });
  }

  Stream<DatabaseEvent> videoStream(String roomCode) {
    return _videoRef(roomCode).onValue;
  }
}
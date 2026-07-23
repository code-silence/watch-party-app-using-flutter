import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'youtube_provider.dart';

final youtubeSyncControllerProvider =
    Provider<YoutubeSyncController>((ref) {
  return YoutubeSyncController(ref);
});

class YoutubeSyncController {
  YoutubeSyncController(this.ref);

  final Ref ref;

  bool _ignoreNextRemoteUpdate = false;

  StreamSubscription? _subscription;

  bool get ignoreNextRemoteUpdate => _ignoreNextRemoteUpdate;

  void dispose() {
    _subscription?.cancel();
  }

  void listen({
    required String roomCode,
    required void Function(
      String videoId,
      bool isPlaying,
      double position,
    ) onRemoteChanged,
  }) {
    _subscription?.cancel();

    _subscription = ref
        .read(youTubeRepositoryProvider)
        .videoStream(roomCode)
        .listen((event) {
      final snapshot = event.snapshot;

      if (!snapshot.exists) return;

      final map =
          Map<String, dynamic>.from(snapshot.value as Map);

      final videoId = map['videoId'] ?? '';

      final isPlaying = map['isPlaying'] ?? false;

      final position =
          (map['position'] ?? 0).toDouble();

      if (_ignoreNextRemoteUpdate) {
        _ignoreNextRemoteUpdate = false;
        return;
      }

      onRemoteChanged(
        videoId,
        isPlaying,
        position,
      );
    });
  }

  Future<void> loadVideo({
    required String roomCode,
    required String videoId,
  }) async {
    _ignoreNextRemoteUpdate = true;

    await ref.read(youTubeRepositoryProvider).loadVideo(
          roomCode: roomCode,
          videoId: videoId,
          controllerUid:
              FirebaseAuth.instance.currentUser!.uid,
        );
  }

  Future<void> play({
    required String roomCode,
    required double position,
  }) async {
    _ignoreNextRemoteUpdate = true;

    await ref.read(youTubeRepositoryProvider).play(
          roomCode: roomCode,
          position: position,
          controllerUid:
              FirebaseAuth.instance.currentUser!.uid,
        );
  }

  Future<void> pause({
    required String roomCode,
    required double position,
  }) async {
    _ignoreNextRemoteUpdate = true;

    await ref.read(youTubeRepositoryProvider).pause(
          roomCode: roomCode,
          position: position,
          controllerUid:
              FirebaseAuth.instance.currentUser!.uid,
        );
  }

  Future<void> seek({
    required String roomCode,
    required double position,
    required bool isPlaying,
  }) async {
    _ignoreNextRemoteUpdate = true;

    await ref.read(youTubeRepositoryProvider).seek(
          roomCode: roomCode,
          position: position,
          isPlaying: isPlaying,
          controllerUid:
              FirebaseAuth.instance.currentUser!.uid,
        );
  }
}
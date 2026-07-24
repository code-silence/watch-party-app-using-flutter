import 'dart:async';

import '../data/repositories/party_repository.dart';

class HeartbeatService {
  HeartbeatService(this._repository);

  final PartyRepository _repository;

  Timer? _timer;

  void start(String roomCode) {
    stop();

    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) async {
        try {
          await _repository.updateHeartbeat(roomCode);
        } catch (e) {
          // Ignore temporary network errors
        }
      },
    );
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
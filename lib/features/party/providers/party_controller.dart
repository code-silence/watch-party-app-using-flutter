import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/providers/profile_provider.dart';
import 'party_provider.dart';

final partyControllerProvider = NotifierProvider<PartyController, bool>(
  PartyController.new,
);

class PartyController extends Notifier<bool> {
  @override
  bool build() => false;

  Future<String> createRoom() async {
    state = true;

    try {
      final roomCode = await ref.read(partyRepositoryProvider).createRoom();

      await ref.read(partyRepositoryProvider).setActiveRoomCode(roomCode);
      ref.invalidate(profileProvider);

      return roomCode;
    } finally {
      state = false;
    }
  }

  Future<void> joinRoom(String roomCode) async {
    state = true;

    try {
      await ref.read(partyRepositoryProvider).joinRoom(roomCode);
    } finally {
      state = false;
    }
  }

  Future<void> leaveRoom(String roomCode) async {
    await ref.read(partyRepositoryProvider).leaveRoom(roomCode);
    await ref.read(partyRepositoryProvider).clearActiveRoomCode();
    ref.invalidate(profileProvider);

  }

  Future<void> deleteRoom(String roomCode) async {
  await ref.read(partyRepositoryProvider).deleteRoom(roomCode);
  await ref.read(partyRepositoryProvider).clearActiveRoomCode();
  ref.invalidate(profileProvider);
}
}

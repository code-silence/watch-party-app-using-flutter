import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import '../data/repositories/party_repository.dart';
import '../data/models/party_room.dart';

final partyRepositoryProvider = Provider<PartyRepository>((ref) {
  return PartyRepository(
    ref.read(authServiceProvider),
  );
});

final partyRoomProvider =
    StreamProvider.family<PartyRoom?, String>((ref, roomCode) {
  return ref
      .read(partyRepositoryProvider)
      .roomStream(roomCode);
});
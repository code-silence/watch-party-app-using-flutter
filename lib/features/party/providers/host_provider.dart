import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'party_provider.dart';

final isHostProvider =
    Provider.family<bool, String>((ref, roomCode) {
  final room = ref.watch(partyRoomProvider(roomCode));

  return room.maybeWhen(
    data: (party) {
      if (party == null) return false;

      return FirebaseAuth.instance.currentUser?.uid ==
          party.hostUid;
    },
    orElse: () => false,
  );
});
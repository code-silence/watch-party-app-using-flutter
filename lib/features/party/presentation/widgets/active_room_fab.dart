import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/data/services/auth_service.dart';

class ActiveRoomFab extends ConsumerWidget {
  const ActiveRoomFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = AuthService.instance;
    final currentUser = auth.currentUser;

    if (currentUser == null) return const SizedBox.shrink();

    return StreamBuilder(
      stream: auth.usersRef
          .child(currentUser.uid)
          .child('activeRoomCode')
          .onValue,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final roomCode = snapshot.data!.snapshot.value?.toString();
        if (roomCode == null || roomCode.isEmpty) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton.extended(
          onPressed: () {
            context.go('/party/$roomCode');
          },
          icon: const Icon(Icons.meeting_room),
          label: const Text('Back to room'),
        );
      },
    );
  }
}

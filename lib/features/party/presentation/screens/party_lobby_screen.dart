import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../providers/party_controller.dart';
import '../../providers/party_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../youtube/presentation/widgets/synced_youtube_player.dart';

class PartyLobbyScreen extends ConsumerWidget {
  const PartyLobbyScreen({super.key, required this.roomCode});

  final String roomCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(partyRoomProvider(roomCode));

    return Scaffold(
      appBar: AppBar(title: const Text('Party Lobby')),
      body: room.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (party) {
          if (party == null) {
            return const Center(child: Text('Room not found'));
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Room: ${party.roomCode}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: party.roomCode),
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Room code copied')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SyncedYoutubePlayer(roomCode: roomCode),

              const SizedBox(height: 24),

              const Text(
                'Participants',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              ...party.participants.entries.map((entry) {
                final uid = entry.key;
                final user = entry.value;

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      user['displayName']
                          .toString()
                          .substring(0, 1)
                          .toUpperCase(),
                    ),
                  ),
                  title: Text(user['displayName'] ?? ''),
                  subtitle: uid == party.hostUid
                      ? const Text('Host')
                      : const Text('Participant'),
                );
              }),

              const SizedBox(height: 30),

              FilledButton.icon(
                onPressed: () async {
                  await ref
                      .read(partyControllerProvider.notifier)
                      .leaveRoom(roomCode);

                  if (!context.mounted) return;

                  context.go('/home');
                },
                icon: const Icon(Icons.exit_to_app),
                label: Text(
                  party.hostUid == FirebaseAuth.instance.currentUser!.uid
                      ? 'End Party'
                      : 'Leave Party',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/heartbeat_provider.dart';
import '../../providers/party_controller.dart';
import '../../providers/party_provider.dart';
import '../../../youtube/presentation/widgets/synced_youtube_player.dart';
import '../../../chat/widgets/party_chat.dart';
import '../../../chat/widgets/chat_input.dart';

class PartyLobbyScreen extends ConsumerStatefulWidget {
  const PartyLobbyScreen({super.key, required this.roomCode});

  final String roomCode;

  @override
  ConsumerState<PartyLobbyScreen> createState() => _PartyLobbyScreenState();
}

class _PartyLobbyScreenState extends ConsumerState<PartyLobbyScreen> {
  Timer? _monitorTimer;

  @override
  void initState() {
    super.initState();

    _monitorTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _checkHostHeartbeat();
    });
  }

  Future<void> _checkHostHeartbeat() async {
    final room = await ref
        .read(partyRepositoryProvider)
        .getRoom(widget.roomCode);

    if (room == null) return;

    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    final isHost = room.hostUid == currentUid;

    if (isHost) return;

    final lastHeartbeat = room.lastHeartbeat;

    if (lastHeartbeat == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final difference = now - lastHeartbeat;

    if (difference > 100000) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Host went offline. Party ended.'),
        ),
      );

      await ref
          .read(partyControllerProvider.notifier)
          .deleteRoom(widget.roomCode);

      if (mounted) {
        context.go('/home');
      }
    }
  }

  void _showChatSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      
      builder: (context) {
  return DraggableScrollableSheet(
    expand: false,
    initialChildSize: 0.9,
    maxChildSize: 0.95,
    minChildSize: 0.6,
    builder: (_, scrollController) {
      return Column(
        children: [
          const SizedBox(height: 8),

          const Text(
            'Party Chat',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Divider(),

          Expanded(
            child: PartyChat(
              roomCode: widget.roomCode,
            ),
          ),

          ChatInput(
            roomCode: widget.roomCode,
          ),
        ],
      );
    },
  );
},
    );
  }

  @override
  void dispose() {
    _monitorTimer?.cancel();

    ref.read(heartbeatServiceProvider).stop();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final room = await ref
          .read(partyRepositoryProvider)
          .getRoom(widget.roomCode);

      if (room != null &&
          room.hostUid == FirebaseAuth.instance.currentUser?.uid) {
        await ref.read(partyRepositoryProvider).deleteRoom(widget.roomCode);
      }
    });

    super.dispose();
  }

  void _showParticipantsSheet(BuildContext context, dynamic party) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) {
        return SizedBox(
          height: 350,
          child: ListView.builder(
            itemCount: party.participants.length,
            itemBuilder: (_, index) {
              final entry = party.participants.entries.elementAt(index);
              final uid = entry.key;
              final user = entry.value;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/avatars/${user['avatar']}',
                  ),
                ),
                title: Text(user['displayName'] ?? ''),
                trailing: uid == party.hostUid
                    ? const Chip(label: Text('Host'))
                    : null,
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final room = ref.watch(partyRoomProvider(widget.roomCode));

    return room.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
      data: (party) {
        if (party == null) {
          return const Scaffold(body: Center(child: Text('Room not found')));
        }

        final isHost = party.hostUid == FirebaseAuth.instance.currentUser!.uid;

        final lastHeartbeat = party.lastHeartbeat;

        if (!isHost && lastHeartbeat != null) {
          final now = DateTime.now().millisecondsSinceEpoch;
          final difference = now - lastHeartbeat;

          if (difference > 100000) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Host went offline. Party ended.'),
                ),
              );

              await ref
                  .read(partyControllerProvider.notifier)
                  .leaveRoom(widget.roomCode);

              if (context.mounted) {
                context.go('/home');
              }
            });
          }
        }

        if (isHost) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(heartbeatServiceProvider).start(widget.roomCode);
          });
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Party Lobby'),
            actions: [
              IconButton(
                tooltip: 'Chat',
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () {
                  _showChatSheet(context);
                },
              ),
              Stack(
                children: [
                  IconButton(
                    tooltip: 'Participants',
                    icon: const Icon(Icons.people),
                    onPressed: () {
                      _showParticipantsSheet(context, party);
                    },
                  ),

                  if (party.participants.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${party.participants.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                tooltip: isHost ? 'End Party' : 'Leave Party',
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await ref
                      .read(partyControllerProvider.notifier)
                      .leaveRoom(widget.roomCode);

                  if (context.mounted) {
                    context.go('/home');
                  }
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
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
                  SyncedYoutubePlayer(roomCode: widget.roomCode),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../providers/party_controller.dart';
import '../../providers/party_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../youtube/presentation/widgets/synced_youtube_player.dart';
import '../../providers/heartbeat_provider.dart';
import '../../../chat/widgets/party_chat.dart';

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

  @override
  Widget build(BuildContext context) {
    final room = ref.watch(partyRoomProvider(widget.roomCode));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Party Lobby')),
      body: room.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (party) {
          if (party == null) {
            return const Center(child: Text('Room not found'));
          }
          final isHost =
              party.hostUid == FirebaseAuth.instance.currentUser!.uid;

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

          return SafeArea(
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

                  const SizedBox(height: 12),

                  ExpansionTile(
                    initiallyExpanded: false,
                    title: Text('Participants (${party.participants.length})'),
                    leading: const Icon(Icons.people),
                    children: [
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          itemCount: party.participants.length,
                          itemBuilder: (_, index) {
                            final entry = party.participants.entries.elementAt(
                              index,
                            );

                            final uid = entry.key;
                            final user = entry.value;

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/avatars/${user['avatar']}',
                                ),
                              ),
                              title: Text(user['displayName']),
                              trailing: uid == party.hostUid
                                  ? const Chip(label: Text('Host'))
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Party Chat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Flexible(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: PartyChat(roomCode: widget.roomCode),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () async {
                        await ref
                            .read(partyControllerProvider.notifier)
                            .leaveRoom(widget.roomCode);

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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

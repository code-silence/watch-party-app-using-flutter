import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/party_controller.dart';
import '../../providers/party_provider.dart';
import '../../../youtube/presentation/widgets/synced_youtube_player.dart';
import '../../../chat/widgets/party_chat.dart';
import '../../../chat/widgets/chat_input.dart';
import '../../../chat/providers/chat_provider.dart';

class PartyLobbyScreen extends ConsumerStatefulWidget {
  const PartyLobbyScreen({super.key, required this.roomCode});

  final String roomCode;

  @override
  ConsumerState<PartyLobbyScreen> createState() => _PartyLobbyScreenState();
}

class _PartyLobbyScreenState extends ConsumerState<PartyLobbyScreen> {
  Future<void> _showChatSheet(BuildContext context) async {
    await ref.read(chatRepositoryProvider).markAsRead(widget.roomCode);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      useSafeArea: true,
      backgroundColor: const Color(0xFF16181E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          maxChildSize: 0.85,
          minChildSize: 0.4,
          builder: (_, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                // Drag handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.forum_rounded,
                        color: Colors.indigoAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Party Chat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white54,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white10, height: 1),
                Expanded(child: PartyChat(roomCode: widget.roomCode)),
                ChatInput(roomCode: widget.roomCode),
              ],
            );
          },
        );
      },
    );
  }

  void _showParticipantsSheet(BuildContext context, dynamic party) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: const Color(0xFF16181E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.group_rounded,
                    color: Colors.indigoAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Members (${party.participants.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 300,
                child: ListView.separated(
                  itemCount: party.participants.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: Colors.white10, height: 1),
                  itemBuilder: (_, index) {
                    final entry = party.participants.entries.elementAt(index);
                    final uid = entry.key;
                    final user = entry.value;
                    final isHost = uid == party.hostUid;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white10,
                        backgroundImage: AssetImage(
                          'assets/avatars/${user['avatar']}',
                        ),
                      ),
                      title: Text(
                        user['displayName'] ?? 'User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: isHost
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.amber.withOpacity(0.4),
                                ),
                              ),
                              child: const Text(
                                '👑 Host',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final room = ref.watch(partyRoomProvider(widget.roomCode));
    final hasUnread = ref.watch(unreadChatProvider(widget.roomCode));

    return room.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF0F1015),
        body: Center(
          child: CircularProgressIndicator(color: Colors.indigoAccent),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: const Color(0xFF0F1015),
        body: Center(
          child: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ),
      data: (party) {
        if (party == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.go('/home');
            }
          });

          return const Scaffold(
            backgroundColor: Color(0xFF0F1015),
            body: Center(
              child: CircularProgressIndicator(color: Colors.indigoAccent),
            ),
          );
        }

        final isHost = party.hostUid == FirebaseAuth.instance.currentUser!.uid;

        return Scaffold(
          backgroundColor: const Color(0xFF0F1015),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: const Color(0xFF16181E),
            elevation: 0,
            title: const Row(
              children: [
                Icon(
                  Icons.live_tv_rounded,
                  color: Colors.indigoAccent,
                  size: 22,
                ),
                SizedBox(width: 8),
                Text(
                  'Party Room',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    tooltip: 'Chat',
                    icon: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: Colors.white70,
                    ),
                    onPressed: () => _showChatSheet(context),
                  ),

                  if (hasUnread.value == true)
                    const Positioned(
                      right: 10,
                      top: 10,
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.red,
                      ),
                    ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    tooltip: 'Participants',
                    icon: const Icon(
                      Icons.people_outline_rounded,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      _showParticipantsSheet(context, party);
                    },
                  ),
                  if (party.participants.isNotEmpty)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigoAccent.withOpacity(0.5),
                              blurRadius: 6,
                            ),
                          ],
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
                icon: Icon(
                  Icons.logout_rounded,
                  color: isHost ? Colors.redAccent : Colors.white70,
                ),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: const Color(0xFF16181E),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.white.withOpacity(0.08)),
                      ),
                      title: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: isHost
                                ? Colors.redAccent
                                : Colors.amberAccent,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            isHost ? 'End Party?' : 'Leave Party?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      content: Text(
                        isHost
                            ? 'This will end the party for everyone.'
                            : 'Are you sure you want to leave this party?',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      actionsPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: FilledButton.styleFrom(
                            backgroundColor: isHost
                                ? Colors.redAccent
                                : Colors.indigoAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(isHost ? 'End Party' : 'Leave'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed != true) return;

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
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: SyncedYoutubePlayer(roomCode: widget.roomCode),
                    ),

                    // Sleek Room Info Card
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16181E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ROOM CODE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigoAccent,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                party.roomCode,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () async {
                              HapticFeedback.lightImpact();
                              await Clipboard.setData(
                                ClipboardData(text: party.roomCode),
                              );

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFF222530),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  content: const Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.greenAccent,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Room code copied to clipboard'),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.indigoAccent.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.copy_rounded,
                                color: Colors.indigoAccent,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Player Container with Border Glow
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

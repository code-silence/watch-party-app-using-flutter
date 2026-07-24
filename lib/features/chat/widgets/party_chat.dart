import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/chat_provider.dart';
import '../widgets/chat_bubble.dart';

class PartyChat extends ConsumerStatefulWidget {
  const PartyChat({
    super.key,
    required this.roomCode,
  });

  final String roomCode;

  @override
  ConsumerState<PartyChat> createState() => _PartyChatState();
}

class _PartyChatState extends ConsumerState<PartyChat> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(chatProvider(widget.roomCode));

    return chat.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Center(
        child: Text(e.toString()),
      ),
      data: (messages) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent,
            );
          }
        });

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(10),
          itemCount: messages.length,
          itemBuilder: (_, index) {
            return ChatBubble(
              message: messages[index],
            );
          },
        );
      },
    );
  }
}
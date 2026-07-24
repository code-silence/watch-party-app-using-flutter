import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  Future<void> _send() async {
    final text = _controller.text.trim();

    if (text.isEmpty) return;

    await ref.read(chatRepositoryProvider).sendMessage(
          roomCode: widget.roomCode,
          message: text,
        );

    _controller.clear();

    await Future.delayed(const Duration(milliseconds: 100));

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(chatProvider(widget.roomCode));

    return Column(
      children: [
        Expanded(
          child: chat.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(e.toString())),
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
                itemCount: messages.length,
                itemBuilder: (_, index) {
                  return ChatBubble(
                    message: messages[index],
                  );
                },
              );
            },
          ),
        ),

        const Divider(height: 1),

        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                  ),
                ),
              ),

              IconButton(
                onPressed: _send,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../providers/party_controller.dart';

class JoinPartyScreen extends ConsumerStatefulWidget {
  const JoinPartyScreen({super.key});

  @override
  ConsumerState<JoinPartyScreen> createState() => _JoinPartyScreenState();
}

class _JoinPartyScreenState extends ConsumerState<JoinPartyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roomController = TextEditingController();

  @override
  void dispose() {
    _roomController.dispose();
    super.dispose();
  }

  String? _validateRoom(String? value) {
    final room = value?.trim().toUpperCase() ?? '';

    if (room.isEmpty) {
      return 'Room code is required';
    }

    if (room.length != 6) {
      return 'Room code must be 6 characters';
    }

    return null;
  }

  Future<void> _joinRoom() async {
    if (!_formKey.currentState!.validate()) return;

    final roomCode = _roomController.text.trim().toUpperCase();

    try {
      await ref.read(partyControllerProvider.notifier).joinRoom(roomCode);

      if (!mounted) return;

      context.push('/party/$roomCode');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(partyControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Join Party')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  controller: _roomController,
                  label: 'Room Code',
                  textCapitalization: TextCapitalization.characters,

                  hint: 'ABC123',
                  validator: _validateRoom,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _joinRoom(),
                ),

                const SizedBox(height: 24),

                AppButton(
                  text: 'Join Party',
                  isLoading: isLoading,
                  onPressed: _joinRoom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../providers/party_controller.dart';

class CreatePartyScreen extends ConsumerWidget {
  const CreatePartyScreen({super.key});

  Future<void> _createParty(BuildContext context, WidgetRef ref) async {
    try {
      final roomCode = await ref
          .read(partyControllerProvider.notifier)
          .createRoom();

      if (!context.mounted) return;

      context.go('/party/$roomCode');
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(partyControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Party')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: AppButton(
              text: 'Create Party',
              isLoading: isLoading,
              onPressed: () => _createParty(context, ref),
            ),
          ),
        ),
      ),
    );
  }
}

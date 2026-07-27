import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../providers/party_controller.dart';
import 'package:watch_nest/features/party/presentation/widgets/active_room_fab.dart';
import '../../../profile/providers/profile_provider.dart';

class CreatePartyScreen extends ConsumerWidget {
  const CreatePartyScreen({super.key});

  Future<void> _createParty(BuildContext context, WidgetRef ref) async {
    try {
      final roomCode = await ref
          .read(partyControllerProvider.notifier)
          .createRoom();

      if (!context.mounted) return;

      context.push('/party/$roomCode');
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
    final profile = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Create Party')),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (user) {
          final isHosting =
              user.activeRoomCode != null && user.activeRoomCode!.isNotEmpty;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: AppButton(
                  text: isHosting ? 'Already Hosting' : 'Create Party',
                  isLoading: isLoading,
                  onPressed: isHosting
                      ? null
                      : () => _createParty(context, ref),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: const ActiveRoomFab(),
    );
  }
}

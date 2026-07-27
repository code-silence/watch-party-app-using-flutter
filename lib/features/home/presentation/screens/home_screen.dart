import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../profile/providers/profile_provider.dart';
import '../../../profile/providers/profile_controller.dart';
import '../../../../../core/constants/avatar_constants.dart';
import '../../../auth/providers/auth_controller.dart';
import 'package:watch_nest/features/party/presentation/widgets/active_room_fab.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('WatchNest'), centerTitle: true),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (user) {
          final isHosting =
              user.activeRoomCode != null && user.activeRoomCode!.isNotEmpty;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                showDragHandle: true,
                                builder: (_) {
                                  return SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Choose Avatar',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          const SizedBox(height: 20),

                                          Expanded(
                                            child: GridView.builder(
                                              itemCount: AvatarConstants
                                                  .avatars
                                                  .length,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 4,
                                                    crossAxisSpacing: 12,
                                                    mainAxisSpacing: 12,
                                                  ),
                                              itemBuilder: (context, index) {
                                                final avatar = AvatarConstants
                                                    .avatars[index];

                                                return InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                  onTap: () async {
                                                    final updatedUser = user
                                                        .copyWith(
                                                          avatar: avatar,
                                                        );

                                                    await ref
                                                        .read(
                                                          profileControllerProvider
                                                              .notifier,
                                                        )
                                                        .updateProfile(
                                                          updatedUser,
                                                        );

                                                    ref.invalidate(
                                                      profileProvider,
                                                    );

                                                    if (context.mounted) {
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 32,
                                                        backgroundImage: AssetImage(
                                                          'assets/avatars/$avatar',
                                                        ),
                                                      ),

                                                      if (user.avatar == avatar)
                                                        Container(
                                                          width: 64,
                                                          height: 64,
                                                          decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .primary,
                                                              width: 3,
                                                            ),
                                                          ),
                                                        ),

                                                      if (user.avatar == avatar)
                                                        const Positioned(
                                                          right: 0,
                                                          bottom: 0,
                                                          child: CircleAvatar(
                                                            radius: 10,
                                                            child: Icon(
                                                              Icons.check,
                                                              size: 12,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 45,
                                  backgroundImage: AssetImage(
                                    'assets/avatars/${user.avatar}',
                                  ),
                                ),

                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: CircleAvatar(
                                    radius: 14,
                                    child: Icon(Icons.edit, size: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  user.displayName,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              IconButton(
                                onPressed: () async {
                                  final controller = TextEditingController(
                                    text: user.displayName,
                                  );

                                  final newName = await showDialog<String>(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: const Text('Edit Display Name'),
                                        content: TextField(
                                          controller: controller,
                                          // autofocus: true,
                                          maxLength: 25,
                                          decoration: const InputDecoration(
                                            hintText: 'Display Name',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          FilledButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                context,
                                                controller.text.trim(),
                                              );
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (newName == null) {
                                    return;
                                  }

                                  final name = newName.trim();

                                  if (name.length < 3) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Display name must be at least 3 characters.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  if (name.length > 25) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Display name cannot exceed 25 characters.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  if (name == user.displayName) {
                                    return;
                                  }

                                  final updatedUser = user.copyWith(
                                    displayName: name,
                                  );

                                  await ref
                                      .read(profileControllerProvider.notifier)
                                      .updateProfile(updatedUser);

                                  ref.invalidate(profileProvider);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                            ],
                          ),

                          Text(
                            user.email,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: isHosting
                          ? null
                          : () {
                        context.go('/join-party');
                            },
                      icon: const Icon(Icons.add),
                      label: const Text('Create Party'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        context.push('/join-party');
                      },
                      icon: const Icon(Icons.group_add),
                      label: const Text('Join Party'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Settings later
                      },
                      icon: const Icon(Icons.settings),
                      label: const Text('Settings'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final shouldLogout = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Logout'),
                            content: const Text(
                              'Are you sure you want to logout?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );

                        if (shouldLogout != true) {
                          return;
                        }

                        await ref
                            .read(authControllerProvider.notifier)
                            .logout();

                        if (context.mounted) {
                          context.go('/login');
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: const ActiveRoomFab(),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/party_controller.dart';
import 'package:watch_nest/features/party/presentation/widgets/active_room_fab.dart';
import '../../../profile/providers/profile_provider.dart';

class CreatePartyScreen extends ConsumerStatefulWidget {
  const CreatePartyScreen({super.key});

  @override
  ConsumerState<CreatePartyScreen> createState() => _CreatePartyScreenState();
}

class _CreatePartyScreenState extends ConsumerState<CreatePartyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 3.0, end: 12.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _createParty(BuildContext context, WidgetRef ref) async {
    try {
      final roomCode =
          await ref.read(partyControllerProvider.notifier).createRoom();

      if (!context.mounted) return;

      context.push('/party/$roomCode');
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(partyControllerProvider);
    final profile = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF00F2FE)),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
          ).createShader(bounds),
          child: const Text(
            'HOST ROOM',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.5,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: profile.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF00F2FE)),
        ),
        error: (e, _) => Center(
          child: Text(
            e.toString(),
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
        data: (user) {
          final isHosting =
              user.activeRoomCode != null && user.activeRoomCode!.isNotEmpty;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // --- TOP HERO ICON HUD ---
                  _buildHeroHeader(),

                  const SizedBox(height: 28),

                  // --- STEP-BY-STEP INSTRUCTION CARD ---
                  _buildInstructionsCard(),

                  const SizedBox(height: 32),

                  // --- CREATE PARTY LAUNCH BUTTON ---
                  _buildLaunchButton(
                    context: context,
                    ref: ref,
                    isLoading: isLoading,
                    isHosting: isHosting,
                  ),

                  if (isHosting) ...[
                    const SizedBox(height: 12),
                    Text(
                      'You already have an active watch party in room: ${user.activeRoomCode}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: const ActiveRoomFab(),
    );
  }

  // --- HERO HEADER WITH NEON BADGE ---
  Widget _buildHeroHeader() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF161B22), Color(0xFF0D1117)],
                ),
                border: Border.all(
                  color: const Color(0xFF00F2FE).withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00F2FE).withOpacity(0.2),
                    blurRadius: _glowAnimation.value * 1.5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.video_call_rounded,
                size: 48,
                color: Color(0xFF00F2FE),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'START A WATCH PARTY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Stream YouTube videos in real-time sync with your squad',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 13,
              ),
            ),
          ],
        );
      },
    );
  }

  // --- 4-STEP SETUP INSTRUCTION CARD ---
  Widget _buildInstructionsCard() {
    final steps = [
      'Create party room to get your unique code.',
      'Copy and share the roomcode with friends.',
      'Wait for them to join in party room.',
      'Paste YouTube link in input box and start the party!',
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF161B22),
        border: Border.all(
          color: const Color(0xFF00F2FE).withOpacity(0.25),
          width: 1.2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.tips_and_updates_rounded,
                      color: Color(0xFF00F2FE),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'HOW IT WORKS',
                      style: TextStyle(
                        color: Color(0xFF00F2FE),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: steps.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Step Index Chip
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF00F2FE).withOpacity(0.15),
                            border: Border.all(
                              color: const Color(0xFF00F2FE),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Color(0xFF00F2FE),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Step Text
                        Expanded(
                          child: Text(
                            steps[index],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- LAUNCH ACTION BUTTON ---
  Widget _buildLaunchButton({
    required BuildContext context,
    required WidgetRef ref,
    required bool isLoading,
    required bool isHosting,
  }) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isHosting
                ? null
                : const LinearGradient(
                    colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
                  ),
            color: isHosting ? const Color(0xFF161B22) : null,
            boxShadow: isHosting
                ? []
                : [
                    BoxShadow(
                      color: const Color(0xFF00F2FE).withOpacity(0.4),
                      blurRadius: _glowAnimation.value,
                      spreadRadius: 1,
                    ),
                  ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: isHosting
                    ? BorderSide(color: Colors.grey.shade800)
                    : BorderSide.none,
              ),
            ),
            onPressed: (isLoading || isHosting)
                ? null
                : () => _createParty(context, ref),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isHosting
                            ? Icons.lock_clock_rounded
                            : Icons.rocket_launch_rounded,
                        color: isHosting ? Colors.grey : Colors.black,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isHosting ? 'ALREADY HOSTING' : 'CREATE PARTY NOW',
                        style: TextStyle(
                          color: isHosting ? Colors.grey : Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
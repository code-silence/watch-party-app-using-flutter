import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/party_controller.dart';
import 'package:watch_nest/features/party/presentation/widgets/active_room_fab.dart';

class JoinPartyScreen extends ConsumerStatefulWidget {
  const JoinPartyScreen({super.key});

  @override
  ConsumerState<JoinPartyScreen> createState() => _JoinPartyScreenState();
}

class _JoinPartyScreenState extends ConsumerState<JoinPartyScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _roomController = TextEditingController();

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

      context.go('/party/$roomCode');
    } catch (e) {
      if (!mounted) return;

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

    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF00FF87)),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF00FF87), Color(0xFF60EFFF)],
          ).createShader(bounds),
          child: const Text(
            'JOIN ROOM',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.5,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),

                // --- TOP HERO ICON HUD ---
                _buildHeroHeader(),

                const SizedBox(height: 28),

                // --- STYLIZED INPUT FIELD & ACTION BUTTON ---
                _buildCodeInputField(),

                const SizedBox(height: 20),

                _buildJoinButton(isLoading: isLoading),

                const SizedBox(height: 32),

                // --- STEP-BY-STEP TIPS CARD ---
                _buildInstructionsCard(),
              ],
            ),
          ),
        ),
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
                  color: const Color(0xFF00FF87).withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FF87).withOpacity(0.2),
                    blurRadius: _glowAnimation.value * 1.5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_circle_filled_rounded,
                size: 48,
                color: Color(0xFF00FF87),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ENTER WATCH PARTY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Ask your party host for the 6-character room code',
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

  // --- CYBER CODE INPUT FIELD ---
  Widget _buildCodeInputField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00FF87).withOpacity(0.3),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: TextFormField(
        controller: _roomController,
        textCapitalization: TextCapitalization.characters,
        maxLength: 6,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _joinRoom(),
        validator: _validateRoom,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF00FF87),
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 6.0,
        ),
        decoration: InputDecoration(
          counterText: '',
          hintText: 'ABC123',
          hintStyle: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 20,
            letterSpacing: 6.0,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          prefixIcon: const Icon(Icons.vpn_key_rounded, color: Color(0xFF00FF87)),
        ),
      ),
    );
  }

  // --- LAUNCH JOIN BUTTON ---
  Widget _buildJoinButton({required bool isLoading}) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF00FF87), Color(0xFF60EFFF)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00FF87).withOpacity(0.35),
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
              ),
            ),
            onPressed: isLoading ? null : _joinRoom,
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
                    children: const [
                      Icon(Icons.login_rounded, color: Colors.black),
                      SizedBox(width: 10),
                      Text(
                        'JOIN PARTY NOW',
                        style: TextStyle(
                          color: Colors.black,
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

  // --- 4-STEP SETUP INSTRUCTION CARD ---
  Widget _buildInstructionsCard() {
    final steps = [
      'Get the 6-character room code from your party host.',
      'Paste or type the code in the input box above.',
      'Tap "JOIN PARTY NOW" to enter the sync lobby.',
      'Enjoy synchronized video playback with your squad!',
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF161B22),
        border: Border.all(
          color: const Color(0xFF00FF87).withOpacity(0.25),
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
                      Icons.lightbulb_outline_rounded,
                      color: Color(0xFF00FF87),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'QUICK TIPS',
                      style: TextStyle(
                        color: Color(0xFF00FF87),
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
                        // Step Index Badge
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF00FF87).withOpacity(0.15),
                            border: Border.all(
                              color: const Color(0xFF00FF87),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Color(0xFF00FF87),
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
}
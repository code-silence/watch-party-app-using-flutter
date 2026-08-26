import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../profile/providers/profile_provider.dart';
import '../../../profile/providers/profile_controller.dart';
import '../../../../../core/constants/avatar_constants.dart';
import '../../../auth/providers/auth_controller.dart';
import 'package:watch_nest/features/party/presentation/widgets/active_room_fab.dart';
import '../../../../shared/services/sound_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    // Continuous breathing/pulsing glow effect for gaming HUD vibe
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 2.0, end: 10.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14), // Dark Sci-Fi background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
          ).createShader(bounds),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'WATCHNEST',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'BETA',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
              ),
            ],
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
                  // --- PROFILE HUD CONTAINER ---
                  _buildGlowProfileCard(context, ref, user),

                  const SizedBox(height: 28),

                  // --- ACTION BUTTONS (GAMING CARDS) ---
                  _buildGamingActionButton(
                    context: context,
                    title: 'CREATE PARTY',
                    subtitle: 'Host a watch party right away!',
                    icon: Icons.video_call_rounded,
                    gradientColors: [
                      const Color(0xFF00F2FE),
                      const Color(0xFF4FACFE),
                    ],
                    disabled: isHosting,
                    onTap: isHosting
                        ? null
                        : () {
                            SoundService.tap();
                            context.push('/create-party');
                          },
                  ),

                  const SizedBox(height: 14),

                  _buildGamingActionButton(
                    context: context,
                    title: 'JOIN PARTY',
                    subtitle: 'Enter active room code',
                    icon: Icons.meeting_room_rounded,
                    gradientColors: [
                      const Color(0xFF00FF87),
                      const Color(0xFF60EFFF),
                    ],
                    onTap: () {
                      SoundService.tap();
                      context.push('/join-party');
                    },
                  ),

                  const SizedBox(height: 14),

                  _buildGamingActionButton(
                    context: context,
                    title: 'SETTINGS',
                    subtitle: 'coming soon',
                    icon: Icons.tune_rounded,
                    gradientColors: [
                      const Color(0xFF7F00FF),
                      const Color(0xFFE100FF),
                    ],
                    onTap: () {},
                  ),

                  const SizedBox(height: 14),

                  // --- ABOUT WATCHNEST ---
                  _buildGamingActionButton(
                    context: context,
                    title: 'ABOUT WATCHNEST',
                    subtitle: 'App info & version details',
                    icon: Icons.info_outline_rounded,
                    gradientColors: [
                      const Color(0xFFFF007F),
                      const Color(0xFFFF5E3A),
                    ],
                    onTap: () {
                      SoundService.tap();
                      context.push('/about');
                    },
                  ),

                  const SizedBox(height: 14),

                  _buildGamingActionButton(
                    context: context,
                    title: 'LOGOUT',
                    subtitle: 'Logout from your account',
                    icon: Icons.power_settings_new_rounded,
                    gradientColors: [
                      const Color(0xFFFF416C),
                      const Color(0xFFFF4B2B),
                    ],
                    isDanger: true,
                    onTap: () {
                      SoundService.tap();
                      _handleLogout(context, ref);
                    },
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

  // --- SCI-FI PROFILE CARD ---
  Widget _buildGlowProfileCard(
    BuildContext context,
    WidgetRef ref,
    dynamic user,
  ) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF161B22), Color(0xFF0D1117)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: const Color(0xFF00F2FE).withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00F2FE).withOpacity(0.15),
                blurRadius: _glowAnimation.value,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    // Avatar with glowing neon ring
                    GestureDetector(
                      onTap: () => _showAvatarPicker(context, ref, user),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 102,
                            height: 102,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00F2FE), Color(0xFF7F00FF)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF00F2FE,
                                  ).withOpacity(0.6),
                                  blurRadius: _glowAnimation.value * 1.5,
                                ),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: const Color(0xFF0B0E14),
                            child: CircleAvatar(
                              radius: 45,
                              backgroundImage: AssetImage(
                                'assets/avatars/${user.avatar}',
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF00F2FE),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Display Name + Edit Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            user.displayName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit_note_rounded,
                            color: Color(0xFF00F2FE),
                          ),
                          onPressed: () {
                            SoundService.tap();
                            _showEditNameDialog(context, ref, user);
                          },
                        ),
                      ],
                    ),

                    // User Email Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Text(
                        user.email,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- CYBER STYLISH ACTION CARD BUTTON ---
  Widget _buildGamingActionButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback? onTap,
    bool disabled = false,
    bool isDanger = false,
  }) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: disabled ? 0.4 : 1.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: gradientColors.first.withOpacity(0.3),
          highlightColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF161B22),
              border: Border.all(
                color: isDanger
                    ? Colors.redAccent.withOpacity(0.4)
                    : gradientColors.first.withOpacity(0.3),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                // Glowing Icon Frame
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors.first.withOpacity(0.4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.black, size: 24),
                ),
                const SizedBox(width: 16),

                // Text labels
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Cyber Arrow Accent
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDanger ? Colors.redAccent : gradientColors.first,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- AVATAR SELECTION SHEET ---
  void _showAvatarPicker(BuildContext context, WidgetRef ref, dynamic user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B0E14),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'SELECT AVATAR FRAME',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: AvatarConstants.avatars.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                    itemBuilder: (context, index) {
                      final avatar = AvatarConstants.avatars[index];
                      final isSelected = user.avatar == avatar;

                      return GestureDetector(
                        onTap: () async {
                          SoundService.tap();

                          final updatedUser = user.copyWith(avatar: avatar);
                          await ref
                              .read(profileControllerProvider.notifier)
                              .updateProfile(updatedUser);
                          SoundService.confirm();

                          ref.invalidate(profileProvider);
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF00F2FE)
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isSelected
                                ? [
                                    const BoxShadow(
                                      color: Color(0xFF00F2FE),
                                      blurRadius: 10,
                                    ),
                                  ]
                                : [],
                          ),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/avatars/$avatar',
                            ),
                          ),
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
  }

  // --- EDIT DISPLAY NAME DIALOG ---
  void _showEditNameDialog(
    BuildContext context,
    WidgetRef ref,
    dynamic user,
  ) async {
    final controller = TextEditingController(text: user.displayName);
    final newName = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF00F2FE), width: 1),
        ),
        title: const Text(
          'UPDATE DISPLAY NAME',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            letterSpacing: 1.5,
          ),
        ),
        content: TextField(
          controller: controller,
          maxLength: 25,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter new handle',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00F2FE)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00F2FE),
            ),
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('SAVE', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

    if (newName == null || newName.isEmpty || newName == user.displayName)
      return;

    if (newName.length < 3 || newName.length > 25) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name length must be 3-25 characters.')),
        );
      }
      return;
    }

    final updatedUser = user.copyWith(displayName: newName);
    await ref
        .read(profileControllerProvider.notifier)
        .updateProfile(updatedUser);
    SoundService.confirm();

    ref.invalidate(profileProvider);
  }

  // --- LOGOUT CONFIRMATION ---
  void _handleLogout(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('LOGOUT', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('LOGOUT', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await ref.read(authControllerProvider.notifier).logout();
      if (context.mounted) context.go('/login');
    }
  }
}

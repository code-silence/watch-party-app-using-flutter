import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/services/sound_service.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  // --- HELPER TO LAUNCH URLS ---
  Future<void> _launchURL(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $urlString'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14), // Dark Sci-Fi background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFF007F), Color(0xFFFF5E3A)],
          ).createShader(bounds),
          child: const Text(
            'CONTACT',
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // --- DEVELOPER PROFILE HUD CARD ---
              _buildDeveloperCard(),

              const SizedBox(height: 24),

              // --- COLLABORATION / GITHUB CARD ---
              _buildGithubCard(context),

              const SizedBox(height: 28),

              // --- SECTION TITLE ---
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'CONNECT WITH ME',
                  style: TextStyle(
                    color: Color(0xFF00F2FE),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // --- CONTACT OPTIONS ---
              _buildContactTile(
                context: context,
                title: 'Email (Recommended)',
                subtitle: 'Any feedback is appreciated',
                iconWidget: const Icon(Icons.email_rounded, color: Color(0xFFEA4335), size: 20),
                accentColor: const Color(0xFFEA4335), // Google Red
                onTap: () => _launchURL(context, 'mailto:arnob8855@gmail.com'),
              ),

              const SizedBox(height: 12),

              _buildContactTile(
                context: context,
                title: 'Telegram',
                subtitle: 'connect me on telegram',
                iconWidget: const FaIcon(FontAwesomeIcons.telegram, color: Color(0xFF229ED9), size: 20),
                accentColor: const Color(0xFF229ED9), // Telegram Blue
                onTap: () => _launchURL(context, 'https://t.me/arnob8855'),
              ),

              const SizedBox(height: 12),

              _buildContactTile(
                context: context,
                title: 'Facebook',
                subtitle: 'Connect on Facebook',
                iconWidget: const FaIcon(FontAwesomeIcons.facebook, color: Color(0xFF1877F2), size: 20),
                accentColor: const Color(0xFF1877F2), // Facebook Blue
                onTap: () => _launchURL(context, 'https://www.facebook.com/arnob.das.16906'),
              ),

              const SizedBox(height: 12),

              _buildContactTile(
                context: context,
                title: 'Discord',
                subtitle: 'Join or message on Discord',
                iconWidget: const FaIcon(FontAwesomeIcons.discord, color: Color(0xFF5865F2), size: 20),
                accentColor: const Color(0xFF5865F2), // Discord Blurple
                onTap: () => _launchURL(context, 'https://discord.com/users/1472969195288395838'),
              ),

              const SizedBox(height: 12),

              _buildContactTile(
                context: context,
                title: 'WhatsApp',
                subtitle: 'Chat directly on WhatsApp',
                iconWidget: const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366), size: 20),
                accentColor: const Color(0xFF25D366), // WhatsApp Green
                onTap: () => _launchURL(context, 'https://wa.me/8801409688763'),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- DEVELOPER PROFILE HUD CARD ---
  Widget _buildDeveloperCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF161B22), Color(0xFF0D1117)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFFFF007F).withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF007F).withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                // Tiny Profile Picture with Neon Glow Ring
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF007F), Color(0xFFFF5E3A)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF007F).withOpacity(0.5),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(3.0),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Color(0xFF0B0E14),
                      backgroundImage: AssetImage('assets/avatars/code_silence.jpg'),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Name
                const Text(
                  'code_silence',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),

                const SizedBox(height: 4),

                // Role/Subtitle Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Text(
                    'Lead Dev WatchNest',
                    style: TextStyle(
                      color: Color(0xFFFF5E3A),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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
  }

  // --- GITHUB COLLABORATION CARD ---
  Widget _buildGithubCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1F242D), Color(0xFF161B22)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFF00F2FE).withOpacity(0.4),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.08),
            ),
            child: const FaIcon(
              FontAwesomeIcons.github,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Want to collaborate?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Check my projects on GitHub',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00F2FE),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              SoundService.tap();
              _launchURL(context, 'https://github.com/code-silence');
            },
            child: const Text(
              'GITHUB',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- REUSABLE CONTACT TILE ---
  Widget _buildContactTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Widget iconWidget,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          SoundService.tap();
          onTap();
        },
        borderRadius: BorderRadius.circular(14),
        splashColor: accentColor.withOpacity(0.2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color(0xFF161B22),
            border: Border.all(
              color: accentColor.withOpacity(0.25),
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: accentColor.withOpacity(0.15),
                ),
                child: iconWidget,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
              Icon(
                Icons.open_in_new_rounded,
                color: Colors.grey.shade600,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
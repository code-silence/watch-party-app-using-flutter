import 'dart:ui';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
            'PRIVACY POLICY',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER CARD ---
              _buildHeaderCard(),

              const SizedBox(height: 24),

              // --- SECTIONS ---
              _buildSection(
                sectionNumber: '01',
                title: 'Information We Collect',
                icon: Icons.badge_rounded,
                accentColor: const Color(0xFF00F2FE),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'When you create and use a WatchNest account, we may collect:',
                      style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoBullet('Email address', 'Used for account authentication.'),
                    _buildInfoBullet('Password', 'Securely handled through Firebase Authentication.'),
                    _buildInfoBullet('Display name', 'Shown to other participants in a party.'),
                    _buildInfoBullet('Avatar selection', 'Used to identify your profile within the application.'),
                    _buildInfoBullet('Party information', 'Room codes, party membership, and host information.'),
                    _buildInfoBullet('Chat messages', 'Stored so participants can communicate in a party.'),
                    const SizedBox(height: 8),
                    _buildNoteBox('WatchNest does not currently allow users to upload photos or videos through the chat system.'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '02',
                title: 'How We Use Your Information',
                icon: Icons.tune_rounded,
                accentColor: const Color(0xFFFF007F),
                child: Column(
                  children: [
                    _buildUseItem('Create and manage your WatchNest account.'),
                    _buildUseItem('Allow you to join and create watch parties.'),
                    _buildUseItem('Display your profile information to other party participants.'),
                    _buildUseItem('Synchronize YouTube playback between party participants.'),
                    _buildUseItem('Provide the party chat feature.'),
                    _buildUseItem('Maintain and improve the application\'s functionality.'),
                    _buildUseItem('Protect the application from misuse.'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '03',
                title: 'Third-Party Services',
                icon: Icons.api_rounded,
                accentColor: const Color(0xFFFF5E3A),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WatchNest uses third-party services to provide core functionality:',
                      style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    _buildServiceTile('Firebase Authentication', 'Account authentication', Icons.lock_outline_rounded),
                    _buildServiceTile('Firebase Realtime Database', 'Storing application and party data', Icons.storage_rounded),
                    _buildServiceTile('YouTube', 'Displaying YouTube videos via YouTube player', Icons.play_circle_outline_rounded),
                    const SizedBox(height: 8),
                    const Text(
                      'Your use of YouTube content is also subject to YouTube\'s own terms and policies.',
                      style: TextStyle(color: Color(0xFF6C7A89), fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '04',
                title: 'Data Sharing',
                icon: Icons.share_rounded,
                accentColor: const Color(0xFF25D366),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WatchNest does not sell or rent your personal information.',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Some information is necessarily visible to other participants in a party. For example, your display name and avatar may be visible to other party members, and your chat messages are visible to members of that party.',
                      style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '05',
                title: 'Data Security',
                icon: Icons.shield_rounded,
                accentColor: const Color(0xFF5865F2),
                child: const Text(
                  'We use third-party services such as Firebase to help securely store and process application data. However, no method of electronic storage or transmission can be guaranteed to be completely secure.',
                  style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '06',
                title: 'Data Retention & Deletion',
                icon: Icons.delete_sweep_rounded,
                accentColor: const Color(0xFFEA4335),
                child: const Text(
                  'Your account and associated information may remain stored while your account is active.\n\nIf you would like your account or associated information deleted, please contact us through the Contact section of the application.',
                  style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '07',
                title: 'Children\'s Privacy',
                icon: Icons.child_care_rounded,
                accentColor: const Color(0xFF00F2FE),
                child: const Text(
                  'WatchNest is not specifically designed for children. We do not knowingly collect personal information from children in violation of applicable laws.',
                  style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '08',
                title: 'Changes to Privacy Policy',
                icon: Icons.update_rounded,
                accentColor: const Color(0xFFFF5E3A),
                child: const Text(
                  'This Privacy Policy may be updated from time to time. Any changes will be reflected in the application with an updated "Last Updated" date.',
                  style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '09',
                title: 'Contact Us',
                icon: Icons.contact_support_rounded,
                accentColor: const Color(0xFFFF007F),
                child: const Text(
                  'If you have questions about this Privacy Policy or how your information is handled, please contact us through the Contact section of WatchNest.',
                  style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- TOP HUD HEADER CARD ---
  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF007F), Color(0xFFFF5E3A)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF007F).withOpacity(0.4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.privacy_tip_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'WatchNest Policy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00F2FE).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF00F2FE).withOpacity(0.3)),
                        ),
                        child: const Text(
                          'Last Updated: August 27, 2026',
                          style: TextStyle(
                            color: Color(0xFF00F2FE),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- REUSABLE SECTION CONTAINER ---
  Widget _buildSection({
    required String sectionNumber,
    required String title,
    required IconData icon,
    required Color accentColor,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF161B22),
        border: Border.all(
          color: accentColor.withOpacity(0.25),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: accentColor.withOpacity(0.15),
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$sectionNumber. $title',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  // --- SUB-WIDGET HELPER BUILDERS ---
  Widget _buildInfoBullet(String label, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Color(0xFF00F2FE), fontSize: 14, fontWeight: FontWeight.bold)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13, height: 1.4),
                children: [
                  TextSpan(text: '$label — ', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  TextSpan(text: description, style: const TextStyle(color: Color(0xFF9EABB8))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUseItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: Color(0xFFFF007F), size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFF9EABB8), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTile(String name, String detail, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF5E3A), size: 16),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 12),
                  children: [
                    TextSpan(text: '$name: ', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    TextSpan(text: detail, style: const TextStyle(color: Color(0xFF9EABB8))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF00F2FE).withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF00F2FE).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFF00F2FE), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFF00F2FE), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
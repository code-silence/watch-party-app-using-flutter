import 'dart:ui';
import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
            'TERMS OF SERVICE',
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
                title: 'Use of WatchNest',
                icon: Icons.explore_rounded,
                accentColor: const Color(0xFF00F2FE),
                child: const Text(
                  'WatchNest provides a platform for users to create or join virtual watch parties and synchronize YouTube playback with other participants.\n\nYou agree to use WatchNest only for lawful purposes and in accordance with these Terms.',
                  style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '02',
                title: 'User Accounts',
                icon: Icons.manage_accounts_rounded,
                accentColor: const Color(0xFFFF007F),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'You are responsible for:',
                      style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 10),
                    _buildCheckItem('Providing accurate information when creating your account.'),
                    _buildCheckItem('Keeping your account credentials secure.'),
                    _buildCheckItem('All activity performed through your account.'),
                    _buildCheckItem('Not sharing your password with other people.'),
                    const SizedBox(height: 8),
                    _buildWarningBox('You must not use another person\'s account without permission.'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '03',
                title: 'Watch Parties',
                icon: Icons.groups_rounded,
                accentColor: const Color(0xFFFF5E3A),
                child: const Text(
                  'Users may create and join watch parties using room codes. The host may control playback synchronization and may end a party at any time.\n\nWatchNest does not host or distribute copies of YouTube videos. Videos are provided through YouTube and are subject to YouTube\'s own policies and terms.',
                  style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '04',
                title: 'Chat and User Content',
                icon: Icons.chat_bubble_outline_rounded,
                accentColor: const Color(0xFF25D366),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WatchNest allows participants to send text messages within party rooms. You agree not to use the chat system to:',
                      style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 10),
                    _buildProhibitedBullet('Send illegal or harmful content.'),
                    _buildProhibitedBullet('Harass, threaten, or abuse other users.'),
                    _buildProhibitedBullet('Send spam or malicious content.'),
                    _buildProhibitedBullet('Impersonate another person.'),
                    _buildProhibitedBullet('Share content that violates applicable laws.'),
                    const SizedBox(height: 10),
                    const Text(
                      'You are responsible for the content you send through WatchNest.',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '05',
                title: 'Prohibited Activities',
                icon: Icons.block_rounded,
                accentColor: const Color(0xFFEA4335),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'You must strictly refrain from:',
                      style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 10),
                    _buildProhibitedBullet('Attempting to gain unauthorized access to WatchNest or its services.'),
                    _buildProhibitedBullet('Interfering with the operation of the application.'),
                    _buildProhibitedBullet('Attempting to access another user\'s data.'),
                    _buildProhibitedBullet('Using WatchNest to distribute malicious software.'),
                    _buildProhibitedBullet('Abusing or exploiting application vulnerabilities.'),
                    _buildProhibitedBullet('Using the application for unlawful activities.'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '06',
                title: 'Third-Party Services',
                icon: Icons.cloud_queue_rounded,
                accentColor: const Color(0xFF5865F2),
                child: const Text(
                  'WatchNest relies on third-party services, including Firebase and YouTube.\n\nAvailability and functionality provided by these services may be affected by their respective systems, policies, or outages. WatchNest is not responsible for problems caused by third-party services.',
                  style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '07',
                title: 'Availability',
                icon: Icons.cloud_off_rounded,
                accentColor: const Color(0xFF00F2FE),
                child: const Text(
                  'WatchNest is provided on an "as is" and "as available" basis.\n\nWe do not guarantee that the application will always be available, error-free, or uninterrupted. Features may be modified, added, or removed as the application develops.',
                  style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '08',
                title: 'Account Suspension & Termination',
                icon: Icons.no_accounts_rounded,
                accentColor: const Color(0xFFFF007F),
                child: const Text(
                  'We may suspend or terminate access to an account if the user violates these Terms or misuses the application.\n\nYou may also stop using WatchNest at any time.',
                  style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '09',
                title: 'Limitation of Liability',
                icon: Icons.gavel_rounded,
                accentColor: const Color(0xFFFF5E3A),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'To the extent permitted by applicable law, WatchNest and its developers are not responsible for losses or damages resulting from:',
                      style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 10),
                    _buildLiabilityBullet('Use or inability to use the application.'),
                    _buildLiabilityBullet('Loss of data.'),
                    _buildLiabilityBullet('Third-party service interruptions.'),
                    _buildLiabilityBullet('User-generated content.'),
                    _buildLiabilityBullet('Unauthorized access resulting from circumstances outside our reasonable control.'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '10',
                title: 'Changes to These Terms',
                icon: Icons.edit_note_rounded,
                accentColor: const Color(0xFF25D366),
                child: const Text(
                  'These Terms of Service may be updated from time to time. Continued use of WatchNest after changes are published means you accept the updated terms.',
                  style: TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.5),
                ),
              ),

              const SizedBox(height: 16),

              _buildSection(
                sectionNumber: '11',
                title: 'Contact',
                icon: Icons.support_agent_rounded,
                accentColor: const Color(0xFF5865F2),
                child: const Text(
                  'If you have questions about these Terms of Service, please contact us through the Contact section of WatchNest.',
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
                  child: const Icon(Icons.assignment_turned_in_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Terms & Conditions',
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
  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: Color(0xFFFF007F), size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProhibitedBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.close_rounded, color: Color(0xFFEA4335), size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiabilityBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Color(0xFFFF5E3A), fontSize: 14, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFF9EABB8), fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFEA4335).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEA4335).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFEA4335), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFFEA4335), fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
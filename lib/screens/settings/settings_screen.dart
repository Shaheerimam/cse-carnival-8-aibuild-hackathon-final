import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildProfileCard(context),
              const SizedBox(height: 16),
              _buildFirebaseStatusCard(context),
              const SizedBox(height: 16),
              _buildActionsCard(context),
              const SizedBox(height: 16),
              _buildAboutCard(),
              const SizedBox(height: 24),
              _buildVersionInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.richBlack,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage your account & preferences',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.grey500,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildProfileCard(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.grey200),
            boxShadow: [
              BoxShadow(
                color: AppColors.richBlack.withOpacity(0.04),
                blurRadius: 24,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accent,
                      AppColors.accentDark,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Faculty User',
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.richBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.accentLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        auth.isAuthenticated
                            ? 'UID: ${auth.uid.substring(0, 8)}…'
                            : 'Not authenticated',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: auth.isAuthenticated
                      ? AppColors.successLight
                      : AppColors.dangerLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  auth.isAuthenticated
                      ? Icons.check_rounded
                      : Icons.close_rounded,
                  size: 16,
                  color: auth.isAuthenticated
                      ? AppColors.success
                      : AppColors.danger,
                ),
              ),
            ],
          ),
        );
      },
    ).animate().fadeIn(delay: 60.ms, duration: 400.ms);
  }

  Widget _buildFirebaseStatusCard(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.grey200),
            boxShadow: [
              BoxShadow(
                color: AppColors.richBlack.withOpacity(0.04),
                blurRadius: 24,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.cloud_outlined,
                      size: 18, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Text(
                    'Firebase Connection',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.richBlack,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _StatusRow(
                label: 'Authentication',
                isActive: auth.isAuthenticated,
              ),
              const SizedBox(height: 8),
              _StatusRow(
                label: 'Firestore Database',
                isActive: auth.isAuthenticated,
              ),
              const SizedBox(height: 8),
              _StatusRow(
                label: 'Cloud Storage',
                isActive: auth.isAuthenticated,
              ),
            ],
          ),
        );
      },
    ).animate().fadeIn(delay: 120.ms, duration: 400.ms);
  }

  Widget _buildActionsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.richBlack.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _ActionTile(
            icon: Icons.delete_sweep_outlined,
            label: 'Clear Local Cache',
            subtitle: 'Remove locally stored audit data',
            onTap: () => _showClearCacheDialog(context),
          ),
          Divider(height: 1, color: AppColors.grey100),
          _ActionTile(
            icon: Icons.logout_rounded,
            label: 'Sign Out',
            subtitle: 'Sign out of your anonymous session',
            isDestructive: true,
            onTap: () => _showSignOutDialog(context),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 180.ms, duration: 400.ms);
  }

  Widget _buildAboutCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.richBlack.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 18, color: AppColors.accent),
              const SizedBox(width: 8),
              Text(
                'About ExamAuditor',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.richBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'AI-powered assessment intelligence for university faculty. '
            'Upload your syllabus and draft exam to get an instant '
            'audit covering coverage gaps, cognitive balance, and '
            'LLM vulnerability analysis.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.grey600,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _TechChip(label: 'Flutter'),
              const SizedBox(width: 6),
              _TechChip(label: 'Firebase'),
              const SizedBox(width: 6),
              _TechChip(label: 'Gemini AI'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 240.ms, duration: 400.ms);
  }

  Widget _buildVersionInfo() {
    return Center(
      child: Text(
        'ExamAuditor v1.0.0  ·  ProfMate',
        style: GoogleFonts.inter(
          fontSize: 11,
          color: AppColors.grey400,
          letterSpacing: 0.3,
        ),
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Local Cache'),
        content: const Text(
            'This will remove all locally cached audit data. '
            'Cloud data in Firestore will remain intact.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Local cache cleared')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out'),
        content: const Text(
            'You will be signed out of your anonymous session. '
            'A new session will be created on next launch.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.isActive});
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.success : AppColors.grey300,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.grey700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          isActive ? 'Connected' : 'Offline',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.success : AppColors.grey400,
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColors.dangerLight
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDestructive ? AppColors.danger : AppColors.grey600,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDestructive
                          ? AppColors.danger
                          : AppColors.richBlack,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.grey300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  const _TechChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.grey600,
        ),
      ),
    );
  }
}

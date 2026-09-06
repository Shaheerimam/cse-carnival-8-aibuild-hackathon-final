import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/audit_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/score_ring.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<AuditProvider>().loadHistory(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildQuickActions(context),
                const SizedBox(height: 32),
                _buildStatsRow(context),
                const SizedBox(height: 32),
                _buildActivityChart(context),
                const SizedBox(height: 32),
                _buildInsightsSection(context),
                const SizedBox(height: 32),
                _buildRecentAuditsHeader(),
                const SizedBox(height: 16),
                _buildRecentAuditsList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting = 'Good evening';
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.grey500,
              ),
            ),
            const SizedBox(height: 8),
            Image.asset(
              'brandings/ProfMate_logo_black.png',
              height: 24,
              errorBuilder: (context, error, stackTrace) => Text(
                'ProfMate',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.richBlack,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
        Consumer<AuthProvider>(
          builder: (context, auth, _) {
            final email = auth.user?.email ?? 'Faculty';
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.grey200),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.richBlack.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.person_outline, size: 16, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Text(
                    email.split('@').first,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.richBlack,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionBtn(
            icon: Icons.add_circle_outline,
            label: 'New Audit',
            color: AppColors.accent,
            onTap: () {
              // Quick action could navigate to New Audit Tab
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionBtn(
            icon: Icons.compare_arrows_rounded,
            label: 'Compare',
            color: AppColors.accent,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionBtn(
            icon: Icons.file_copy_outlined,
            label: 'Drafts',
            color: AppColors.grey500,
            onTap: () {},
          ),
        ),
      ],
    ).animate().fadeIn(delay: 50.ms, duration: 400.ms);
  }

  Widget _buildActivityChart(BuildContext context) {
    return Consumer<AuditProvider>(
      builder: (context, provider, _) {
        if (provider.history.isEmpty) return const SizedBox.shrink();

        final recentScores = provider.history
            .where((h) => h.report != null)
            .take(5)
            .toList()
            .reversed
            .toList();

        if (recentScores.length < 2) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Trend',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.richBlack,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 160,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: recentScores.asMap().entries.map((e) {
                          return FlSpot(e.key.toDouble(), e.value.report!.overallScore.toDouble());
                        }).toList(),
                        isCurved: true,
                        color: AppColors.accent,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.accent.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
      },
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Consumer<AuditProvider>(
      builder: (context, provider, _) {
        final total = provider.history.length;
        final completed = provider.completedCount;
        final avgScore = provider.averageScore;

        return Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Total Audits',
                value: '$total',
                icon: Icons.article_outlined,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Completed',
                value: '$completed',
                icon: Icons.check_circle_outline_rounded,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Avg Score',
                value: '$avgScore',
                icon: Icons.speed_rounded,
                color: _scoreColor(avgScore),
              ),
            ),
          ],
        );
      },
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildInsightsSection(BuildContext context) {
    return Consumer<AuditProvider>(
      builder: (context, provider, _) {
        final last = provider.lastCompletedAudit;
        if (last == null) {
          return const SizedBox.shrink();
        }

        final trend = provider.theoryApplicationTrend;
        final recType = provider.mostCommonRecommendationType;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Insights',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.richBlack,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      ScoreRing(
                        score: last.report?.overallScore ?? 0,
                        size: 80,
                        lineWidth: 8,
                        showLabel: false,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Latest Audit Score',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.grey500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              last.courseTitle,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.richBlack,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Theory vs App',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.grey500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${trend.theory.toStringAsFixed(0)}% / ${trend.application.toStringAsFixed(0)}%',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.richBlack,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Top Action Area',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.grey500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _capitalize(recType),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ).animate().fadeIn(delay: 150.ms, duration: 400.ms);
      },
    );
  }

  Widget _buildRecentAuditsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent Audits',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.richBlack,
          ),
        ),
        Text(
          'View History',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.accent,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildRecentAuditsList(BuildContext context) {
    return Consumer<AuditProvider>(
      builder: (context, provider, _) {
        if (provider.history.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.grey200, width: 1),
            ),
            child: Column(
              children: [
                Icon(Icons.dashboard_customize_outlined, size: 48, color: AppColors.grey300),
                const SizedBox(height: 16),
                Text(
                  'No Audits Yet',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.richBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start your first AI exam audit\nfrom the New Audit tab.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 250.ms);
        }

        final recent = provider.history.take(3).toList();
        
        return Column(
          children: recent.map((session) {
            final score = session.report?.overallScore;
            final isError = session.status.name == 'error';
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isError
                            ? AppColors.dangerLight
                            : score != null
                                ? _scoreColor(score).withOpacity(0.15)
                                : AppColors.grey100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: isError
                            ? const Icon(Icons.error_rounded, color: AppColors.danger, size: 20)
                            : score != null
                                ? Text(
                                    '$score',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: _scoreColor(score),
                                    ),
                                  )
                                : const Icon(Icons.hourglass_top_rounded, color: AppColors.warning, size: 18),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.courseTitle,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.richBlack,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${session.createdAt.day}/${session.createdAt.month}/${session.createdAt.year} · ${session.status.name}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.grey500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ).animate().fadeIn(delay: 250.ms, duration: 400.ms);
      },
    );
  }

  Color _scoreColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.danger;
  }
  
  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.richBlack.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.richBlack,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.grey500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  const _QuickActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/audit_session.dart';
import '../../providers/audit_provider.dart';
import '../../widgets/glass_card.dart';
import '../ingestion/ingestion_screen.dart';
import '../history/history_screen.dart';
import '../report/report_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuditProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildQuickAction()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 12),
                child: Row(
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
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const HistoryScreen()),
                      ),
                      child: Text(
                        'View all',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildHistoryList(),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ExamAuditor',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.richBlack,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'AI-powered assessment intelligence',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.grey500,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.richBlack,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          // Stats row
          Consumer<AuditProvider>(
            builder: (context, provider, _) {
              final total = provider.history.length;
              final done =
                  provider.history.where((s) => s.status == AuditStatus.complete).length;
              final avgScore = done == 0
                  ? 0
                  : provider.history
                          .where((s) => s.status == AuditStatus.complete)
                          .map((s) => s.report?.overallScore ?? 0)
                          .fold(0, (a, b) => a + b) ~/
                      done;

              return Row(
                children: [
                  _StatChip(label: 'Total Audits', value: '$total'),
                  const SizedBox(width: 12),
                  _StatChip(label: 'Avg Score', value: '$avgScore'),
                  const SizedBox(width: 12),
                  _StatChip(label: 'Completed', value: '$done'),
                ],
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildQuickAction() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: GestureDetector(
        onTap: () => _navigateToIngestion(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.richBlack,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.richBlack.withOpacity(0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Audit',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Upload syllabus + exam to get started',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 500.ms).slideY(begin: 0.05);
  }

  Widget _buildHistoryList() {
    return Consumer<AuditProvider>(
      builder: (context, provider, _) {
        final history = provider.history.take(5).toList();

        if (history.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: GlassCard(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.inbox_outlined,
                        color: AppColors.grey400,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No audits yet',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.richBlack,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Upload your first exam to get started',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.grey500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              final session = history[i];
              return _AuditSessionCard(
                session: session,
                index: i,
                onTap: () {
                  if (session.status == AuditStatus.complete) {
                    context.read<AuditProvider>().setCurrentSession(session);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ReportScreen()),
                    );
                  }
                },
              );
            },
            childCount: history.length,
          ),
        );
      },
    );
  }

  void _navigateToIngestion() {
    context.read<AuditProvider>().reset();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const IngestionScreen()),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.richBlack,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.grey500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuditSessionCard extends StatelessWidget {
  const _AuditSessionCard({
    required this.session,
    required this.index,
    required this.onTap,
  });
  final AuditSession session;
  final int index;
  final VoidCallback onTap;

  Color get _statusColor {
    switch (session.status) {
      case AuditStatus.complete:
        return AppColors.success;
      case AuditStatus.error:
        return AppColors.danger;
      default:
        return AppColors.warning;
    }
  }

  IconData get _statusIcon {
    switch (session.status) {
      case AuditStatus.complete:
        return Icons.check_circle_rounded;
      case AuditStatus.error:
        return Icons.error_rounded;
      default:
        return Icons.hourglass_top_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final score = session.report?.overallScore;
    final questionCount = session.report?.questions.length ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: GlassCard(
        padding: const EdgeInsets.all(18),
        onTap: onTap,
        child: Row(
          children: [
            // Score badge or status icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: score != null
                    ? _scoreColor(score).withOpacity(0.1)
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: score != null
                    ? Text(
                        '$score',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: _scoreColor(score),
                        ),
                      )
                    : Icon(_statusIcon, color: _statusColor, size: 22),
              ),
            ),
            const SizedBox(width: 16),
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
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 11, color: AppColors.grey400),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(session.createdAt),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.grey500,
                        ),
                      ),
                      if (questionCount > 0) ...[
                        const SizedBox(width: 10),
                        Text('·', style: GoogleFonts.inter(color: AppColors.grey300)),
                        const SizedBox(width: 10),
                        Text(
                          '$questionCount questions',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.grey300, size: 20),
          ],
        ),
      ),
    )
        .animate(delay: (index * 60).ms)
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.04, duration: 400.ms);
  }

  Color _scoreColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.danger;
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}

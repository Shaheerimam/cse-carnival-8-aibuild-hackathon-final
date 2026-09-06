import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_colors.dart';
import '../../models/audit_report.dart';
import '../../models/question_analysis.dart';
import '../../providers/audit_provider.dart';
import '../../widgets/coverage_bar.dart';
import '../../widgets/cognitive_chart.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/score_ring.dart';
import '../../widgets/vulnerability_badge.dart';
import 'question_detail_screen.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuditProvider>(
      builder: (context, provider, _) {
        final session = provider.currentSession;
        final report = session?.report;

        if (report == null) {
          return const Scaffold(
            body: Center(child: Text('No report data available.')),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.ghostWhite,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(context, session!.courseTitle, report, provider),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: Column(
                    children: [
                      _buildScoreSection(report),
                      const SizedBox(height: 20),
                      _buildExecutiveSummary(report),
                      const SizedBox(height: 20),
                      _buildMarkWeightedRatio(report),
                      const SizedBox(height: 20),
                      _buildCloCoverage(report),
                      const SizedBox(height: 20),
                      _buildTopicCoverage(report),
                      const SizedBox(height: 20),
                      _buildCognitiveSection(report),
                      const SizedBox(height: 20),
                      _buildVulnerabilitySection(context, report),
                      const SizedBox(height: 20),
                      _buildRecommendations(report),
                      const SizedBox(height: 20),
                      _buildQuestionList(context, report, provider),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── App Bar ───────────────────────────────────────────────────────────────

  Widget _buildSliverAppBar(
    BuildContext context,
    String title,
    AuditReport report,
    AuditProvider provider,
  ) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.ghostWhite,
      foregroundColor: AppColors.richBlack,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.richBlack,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, size: 20),
          onPressed: () => _shareReport(report, title),
        ),
      ],
    );
  }

  // ─── Score Section ─────────────────────────────────────────────────────────

  Widget _buildScoreSection(AuditReport report) {
    return GlassCard(
      child: Column(
        children: [
          ScoreRing(score: report.overallScore),
          const SizedBox(height: 20),
          Row(
            children: [
              _ScorePill(
                  label: 'CLO Coverage',
                  value: report.cloCoverage.isEmpty
                      ? '-'
                      : '${_avgCoverage(report.cloCoverage).toStringAsFixed(0)}%'),
              const SizedBox(width: 10),
              _ScorePill(
                  label: 'Topics Covered',
                  value: '${report.topicCoverage.length}'),
              const SizedBox(width: 10),
              _ScorePill(
                  label: 'Questions',
                  value: '${report.questions.length}'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  // ─── Executive Summary ─────────────────────────────────────────────────────

  Widget _buildExecutiveSummary(AuditReport report) {
    if (report.executiveSummary.isEmpty) return const SizedBox.shrink();
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.summarize_outlined,
                  size: 18, color: AppColors.accent),
              const SizedBox(width: 8),
              Text('Executive Summary',
                  style: GoogleFonts.inter(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            report.executiveSummary,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.grey700,
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 80.ms, duration: 400.ms);
  }

  // ─── Mark-Weighted Ratio ───────────────────────────────────────────────────

  Widget _buildMarkWeightedRatio(AuditReport report) {
    final r = report.markWeightedRatio;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
              icon: Icons.balance_rounded, title: 'Mark-Weighted Ratio'),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 14,
              child: Row(
                children: [
                  Flexible(
                    flex: r.theoryPercent.toInt(),
                    child: Container(color: AppColors.info),
                  ),
                  Flexible(
                    flex: r.applicationPercent.toInt(),
                    child: Container(color: AppColors.accent),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _LegendDot(color: AppColors.info,
                  label: 'Theory',
                  value: '${r.theoryPercent.toStringAsFixed(0)}%'),
              const Spacer(),
              _LegendDot(color: AppColors.accent,
                  label: 'Application',
                  value: '${r.applicationPercent.toStringAsFixed(0)}%'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 120.ms, duration: 400.ms);
  }

  // ─── CLO Coverage ─────────────────────────────────────────────────────────

  Widget _buildCloCoverage(AuditReport report) {
    if (report.cloCoverage.isEmpty) return const SizedBox.shrink();
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
              icon: Icons.checklist_rounded, title: 'CLO Coverage'),
          const SizedBox(height: 16),
          ...report.cloCoverage.asMap().entries.map((e) {
            final item = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _cloColor(item.status),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item.cloId} — ${item.description}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.richBlack,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        CoverageBar(
                          label: '',
                          percent: item.coveragePercent,
                          delay: Duration(milliseconds: e.key * 60),
                          color: _cloColor(item.status),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 160.ms, duration: 400.ms);
  }

  // ─── Topic Coverage ────────────────────────────────────────────────────────

  Widget _buildTopicCoverage(AuditReport report) {
    if (report.topicCoverage.isEmpty) return const SizedBox.shrink();
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
              icon: Icons.topic_outlined, title: 'Topic Coverage'),
          const SizedBox(height: 16),
          ...report.topicCoverage.asMap().entries.map((e) => CoverageBar(
                label: e.value.topic,
                percent: e.value.coveragePercent,
                hint: e.value.syllabusWeightHint,
                delay: Duration(milliseconds: e.key * 50),
              )),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  // ─── Cognitive Distribution ────────────────────────────────────────────────

  Widget _buildCognitiveSection(AuditReport report) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
              icon: Icons.psychology_outlined,
              title: 'Cognitive Distribution'),
          const SizedBox(height: 20),
          CognitiveChart(distribution: report.cognitiveDistribution),
        ],
      ),
    ).animate().fadeIn(delay: 240.ms, duration: 400.ms);
  }

  // ─── LLM Vulnerability ────────────────────────────────────────────────────

  Widget _buildVulnerabilitySection(
      BuildContext context, AuditReport report) {
    final flags = report.llmVulnerabilityFlags
        .where((f) => f.severity == 'high' || f.severity == 'medium')
        .toList();
    if (flags.isEmpty) {
      return GlassCard(
        child: Row(
          children: [
            const Icon(Icons.shield_outlined,
                color: AppColors.success, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'No high or medium LLM vulnerability flags. Good academic integrity!',
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.grey700),
              ),
            ),
          ],
        ),
      );
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
              icon: Icons.security_outlined, title: 'LLM Vulnerability'),
          const SizedBox(height: 14),
          ...flags.map(
            (flag) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: flag.severity == 'high'
                      ? AppColors.dangerLight
                      : AppColors.warningLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        VulnerabilityBadge(severity: flag.severity),
                        const SizedBox(width: 8),
                        Text(
                          flag.questionId,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.grey700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      flag.questionText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.richBlack,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      flag.suggestion,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.grey600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 280.ms, duration: 400.ms);
  }

  // ─── Recommendations ──────────────────────────────────────────────────────

  Widget _buildRecommendations(AuditReport report) {
    if (report.recommendations.isEmpty) return const SizedBox.shrink();
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
              icon: Icons.tips_and_updates_outlined,
              title: 'Recommendations'),
          const SizedBox(height: 14),
          ...report.recommendations.asMap().entries.map((e) {
            final rec = e.value;
            final severityColor = rec.severity == 'high'
                ? AppColors.danger
                : rec.severity == 'medium'
                    ? AppColors.warning
                    : AppColors.info;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(top: 1),
                    decoration: BoxDecoration(
                      color: severityColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${e.key + 1}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: severityColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rec.description,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.richBlack,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rec.action,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.grey600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 320.ms, duration: 400.ms);
  }

  // ─── Question List ─────────────────────────────────────────────────────────

  Widget _buildQuestionList(
      BuildContext context, AuditReport report, AuditProvider provider) {
    if (report.questions.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Question Analysis',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.richBlack,
            ),
          ),
        ),
        ...report.questions.asMap().entries.map((e) =>
            _QuestionCard(
              question: e.value,
              index: e.key,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuestionDetailScreen(
                      question: e.value,
                    ),
                  ),
                );
              },
            )),
      ],
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  Color _cloColor(String status) {
    switch (status) {
      case 'good':
        return AppColors.success;
      case 'missing':
        return AppColors.danger;
      default:
        return AppColors.warning;
    }
  }

  double _avgCoverage(List<CloCoverageItem> items) {
    if (items.isEmpty) return 0;
    return items.map((i) => i.coveragePercent).reduce((a, b) => a + b) /
        items.length;
  }

  void _shareReport(AuditReport report, String title) {
    final sb = StringBuffer();
    sb.writeln('ExamAuditor Report — $title');
    sb.writeln('Overall Score: ${report.overallScore}/100');
    sb.writeln('\n${report.executiveSummary}');
    sb.writeln('\nRecommendations:');
    for (final r in report.recommendations) {
      sb.writeln('• ${r.description}');
      sb.writeln('  → ${r.action}');
    }
    Share.share(sb.toString(), subject: 'ExamAuditor Report — $title');
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.accent),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.richBlack,
          ),
        ),
      ],
    );
  }
}

class _ScorePill extends StatelessWidget {
  const _ScorePill({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.richBlack,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.grey500,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot(
      {required this.color, required this.label, required this.value});
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 10,
            height: 10,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(
          '$label  ',
          style: GoogleFonts.inter(
              fontSize: 12, color: AppColors.grey500),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.richBlack,
          ),
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.index,
    required this.onTap,
  });
  final QuestionAnalysis question;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  question.id,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.richBlack,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _Tag(label: '${question.marks}m', color: AppColors.info),
                      const SizedBox(width: 6),
                      _Tag(
                          label: question.cognitiveLevel,
                          color: AppColors.accent),
                      const SizedBox(width: 6),
                      VulnerabilityBadge(
                        severity: question.llmVulnerabilitySeverity,
                        showIcon: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.grey300, size: 18),
          ],
        ),
      ),
    )
        .animate(delay: (index * 40).ms)
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.03, duration: 350.ms);
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

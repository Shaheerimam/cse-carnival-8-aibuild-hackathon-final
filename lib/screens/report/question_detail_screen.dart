import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/question_analysis.dart';
import '../../providers/audit_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/vulnerability_badge.dart';
import '../reskinner/reskinner_screen.dart';

class QuestionDetailScreen extends StatelessWidget {
  const QuestionDetailScreen({super.key, required this.question});

  final QuestionAnalysis question;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      appBar: AppBar(
        title: Text(question.id),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuestionText(),
            const SizedBox(height: 16),
            _buildMetadataGrid(),
            const SizedBox(height: 16),
            _buildVulnerabilityCard(),
            const SizedBox(height: 16),
            _buildRecommendationCard(),
            const SizedBox(height: 24),
            _buildReskinnerButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionText() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.grey400,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            question.text,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.richBlack,
              height: 1.55,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildMetadataGrid() {
    final items = [
      _MetaItem(
          label: 'Marks',
          value: '${question.marks}',
          icon: Icons.star_outline_rounded),
      _MetaItem(
          label: 'Topic',
          value: question.topic,
          icon: Icons.topic_outlined),
      _MetaItem(
          label: 'CLO',
          value: question.clo,
          icon: Icons.flag_outlined),
      _MetaItem(
          label: 'Difficulty',
          value: _capitalize(question.difficulty),
          icon: Icons.bar_chart_rounded),
      _MetaItem(
          label: 'Cognitive Level',
          value: question.cognitiveLevel,
          icon: Icons.psychology_outlined),
      _MetaItem(
          label: 'Type',
          value: _capitalize(question.type),
          icon: Icons.category_outlined),
    ];

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.8,
            children: items
                .map((item) => _MetaTile(item: item))
                .toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 80.ms, duration: 400.ms);
  }

  Widget _buildVulnerabilityCard() {
    final isHighRisk = question.llmVulnerabilitySeverity == 'high';
    final isMedium = question.llmVulnerabilitySeverity == 'medium';
    final bg = isHighRisk
        ? AppColors.dangerLight
        : isMedium
            ? AppColors.warningLight
            : AppColors.successLight;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security_outlined, size: 18),
              const SizedBox(width: 8),
              Text(
                'LLM Vulnerability',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.richBlack,
                ),
              ),
              const Spacer(),
              VulnerabilityBadge(severity: question.llmVulnerabilitySeverity),
            ],
          ),
          if (question.llmVulnerabilityReason.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              question.llmVulnerabilityReason,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.grey700,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 140.ms, duration: 400.ms);
  }

  Widget _buildRecommendationCard() {
    if (question.recommendation.isEmpty) return const SizedBox.shrink();
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tips_and_updates_outlined,
                  size: 18, color: AppColors.accent),
              const SizedBox(width: 8),
              Text(
                'Recommendation',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.richBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            question.recommendation,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.grey700,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 180.ms, duration: 400.ms);
  }

  Widget _buildReskinnerButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          context.read<AuditProvider>().generateVariants(question);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReskinnerScreen(question: question),
            ),
          );
        },
        icon: const Icon(Icons.auto_fix_high_rounded, size: 18),
        label: Text(
          'Reskinner — Generate Variant',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ).animate().fadeIn(delay: 250.ms, duration: 400.ms).slideY(begin: 0.05);
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _MetaItem {
  final String label;
  final String value;
  final IconData icon;

  const _MetaItem(
      {required this.label, required this.value, required this.icon});
}

class _MetaTile extends StatelessWidget {
  const _MetaTile({required this.item});
  final _MetaItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Row(
        children: [
          Icon(item.icon, size: 14, color: AppColors.grey400),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.grey400,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  item.value,
                  style: GoogleFonts.inter(
                    fontSize: 13,
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
    );
  }
}

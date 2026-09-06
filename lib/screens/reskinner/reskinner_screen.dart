import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/question_analysis.dart';
import '../../providers/audit_provider.dart';
import '../../widgets/glass_card.dart';

class ReskinnerScreen extends StatefulWidget {
  const ReskinnerScreen({super.key, required this.question});
  final QuestionAnalysis question;

  @override
  State<ReskinnerScreen> createState() => _ReskinnerScreenState();
}

class _ReskinnerScreenState extends State<ReskinnerScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      appBar: AppBar(
        title: const Text('Semantic Reskinner'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AuditProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOriginalCard(),
                const SizedBox(height: 24),
                _buildVariantsHeader(),
                const SizedBox(height: 14),
                if (provider.reskinnerLoading)
                  _buildLoading()
                else if (provider.reskinnerError.isNotEmpty)
                  _buildError(provider.reskinnerError, context)
                else if (provider.reskinnerVariants.isEmpty)
                  _buildEmpty()
                else
                  _buildVariantCards(provider.reskinnerVariants),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOriginalCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'ORIGINAL',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey500,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${widget.question.marks} marks · ${widget.question.cognitiveLevel}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.question.text,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.richBlack,
              height: 1.55,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildVariantsHeader() {
    return Row(
      children: [
        const Icon(Icons.auto_fix_high_rounded,
            size: 18, color: AppColors.accent),
        const SizedBox(width: 8),
        Text(
          'AI-Generated Variants',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.richBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const CircularProgressIndicator(
          color: AppColors.accent,
          strokeWidth: 3,
        ),
        const SizedBox(height: 20),
        Text(
          'Generating variants…',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.grey500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Gemini is creating semantically equivalent\nbut uniquely contextualised questions.',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.grey400,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildError(String message, BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.danger, size: 32),
          const SizedBox(height: 12),
          Text(
            'Could not generate variants',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.richBlack,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message.length > 200
                ? '${message.substring(0, 200)}…'
                : message,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.grey500,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () =>
                context.read<AuditProvider>().generateVariants(widget.question),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return GlassCard(
      child: Center(
        child: Text(
          'No variants generated yet.',
          style: GoogleFonts.inter(color: AppColors.grey500),
        ),
      ),
    );
  }

  Widget _buildVariantCards(List<String> variants) {
    return Column(
      children: [
        // Tab selector
        Row(
          children: List.generate(variants.length, (i) {
            final isSelected = i == _selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: i < variants.length - 1 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.richBlack : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.richBlack
                          : AppColors.grey200,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Variant ${i + 1}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.grey600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 14),
        // Active variant card
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _VariantCard(
            key: ValueKey(_selectedIndex),
            variantNumber: _selectedIndex + 1,
            text: variants[_selectedIndex],
            originalQuestion: widget.question,
          ),
        ),
        const SizedBox(height: 12),
        // Navigation hint
        Text(
          'Tap tabs to browse variants',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.grey400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _VariantCard extends StatelessWidget {
  const _VariantCard({
    super.key,
    required this.variantNumber,
    required this.text,
    required this.originalQuestion,
  });

  final int variantNumber;
  final String text;
  final QuestionAnalysis originalQuestion;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Variant $variantNumber',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.copy_rounded,
                    size: 18, color: AppColors.grey400),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard')),
                  );
                },
                tooltip: 'Copy',
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.richBlack,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _InfoChip(
                  label: '${originalQuestion.marks} marks',
                  color: AppColors.info),
              const SizedBox(width: 8),
              _InfoChip(
                  label: originalQuestion.cognitiveLevel,
                  color: AppColors.accent),
              const SizedBox(width: 8),
              _InfoChip(
                  label: originalQuestion.type,
                  color: AppColors.grey500),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Variant copied — paste into your exam.'),
                  ),
                );
              },
              child: Text(
                'Use This Variant',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

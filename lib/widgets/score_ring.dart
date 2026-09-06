import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';

/// Animated circular score indicator.
/// [score] is 0-100.
class ScoreRing extends StatelessWidget {
  const ScoreRing({
    super.key,
    required this.score,
    this.size = 160.0,
    this.lineWidth = 12.0,
    this.label = 'Quality Score',
    this.showLabel = true,
  });

  final int score;
  final double size;
  final double lineWidth;
  final String label;
  final bool showLabel;

  Color get _ringColor {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: size / 2,
      lineWidth: lineWidth,
      animation: true,
      animationDuration: 1200,
      curve: Curves.easeOutCubic,
      percent: score / 100,
      circularStrokeCap: CircularStrokeCap.round,
      backgroundColor: AppColors.grey100,
      progressColor: _ringColor,
      center: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$score',
            style: GoogleFonts.inter(
              fontSize: size * 0.22,
              fontWeight: FontWeight.w800,
              color: AppColors.richBlack,
              letterSpacing: -1,
            ),
          ),
          if (showLabel)
            Text(
              'out of 100',
              style: GoogleFonts.inter(
                fontSize: size * 0.08,
                fontWeight: FontWeight.w500,
                color: AppColors.grey500,
              ),
            ),
        ],
      ),
      footer: showLabel
          ? Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey600,
                  letterSpacing: 0.2,
                ),
              ),
            )
          : null,
    );
  }
}

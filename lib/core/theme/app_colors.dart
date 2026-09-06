import 'package:flutter/material.dart';

/// Monochromatic design system colour tokens.
/// Primary palette: Ghost White + Rich Black with Indigo accent.
abstract final class AppColors {
  // ── Base ──────────────────────────────────────────────────────────────────
  static const Color ghostWhite = Color(0xFFF8F8FF);
  static const Color richBlack = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFFFFFFFF);

  // ── Greys ─────────────────────────────────────────────────────────────────
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ── Accent ────────────────────────────────────────────────────────────────
  static const Color accent = Color(0xFF4F46E5);       // Indigo-600
  static const Color accentLight = Color(0xFFEEF2FF);  // Indigo-50
  static const Color accentDark = Color(0xFF3730A3);   // Indigo-800

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF16A34A);      // Green-600
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);      // Amber-600
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFDC2626);       // Red-600
  static const Color dangerLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0284C7);         // Sky-600
  static const Color infoLight = Color(0xFFE0F2FE);

  // ── Glassmorphism ─────────────────────────────────────────────────────────
  static const Color glassWhite = Color(0xCCFFFFFF);   // 80% white
  static const Color glassBorder = Color(0x33FFFFFF);  // 20% white

  // ── Chart Palette ─────────────────────────────────────────────────────────
  static const List<Color> chartPalette = [
    Color(0xFF4F46E5), // Indigo
    Color(0xFF7C3AED), // Violet
    Color(0xFF0284C7), // Sky
    Color(0xFF16A34A), // Green
    Color(0xFFD97706), // Amber
    Color(0xFFDC2626), // Red
  ];

  // ── Cognitive Level Colours ────────────────────────────────────────────────
  static const Color cogRemember = Color(0xFF6366F1);
  static const Color cogUnderstand = Color(0xFF8B5CF6);
  static const Color cogApply = Color(0xFF0EA5E9);
  static const Color cogAnalyze = Color(0xFF10B981);
  static const Color cogEvaluate = Color(0xFFF59E0B);
  static const Color cogCreate = Color(0xFFEF4444);
}

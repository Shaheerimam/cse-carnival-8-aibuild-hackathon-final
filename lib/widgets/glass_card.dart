import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// A card with a subtle frosted/glass look.
/// Uses BackdropFilter for blur effect on supported platforms.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 20.0,
    this.color,
    this.borderColor,
    this.onTap,
    this.useBlur = false,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;

  /// Enable BackdropFilter blur (expensive — use sparingly).
  final bool useBlur;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? AppColors.grey200,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.richBlack.withOpacity(0.04),
          blurRadius: 24,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: AppColors.richBlack.withOpacity(0.02),
          blurRadius: 6,
          offset: const Offset(0, 1),
        ),
      ],
    );

    Widget card = Container(
      margin: margin,
      decoration: decoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: useBlur
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Padding(padding: padding, child: child),
              )
            : Padding(padding: padding, child: child),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }
}

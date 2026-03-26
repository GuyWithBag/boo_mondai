// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/painters/streak_flame_painter.dart
// PURPOSE: CustomPainter that draws a flame icon scaled by streak count
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/theme_constants.dart';

class StreakFlamePainter extends CustomPainter {
  final int streakCount;

  StreakFlamePainter({required this.streakCount});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Flame intensity: 0.0 (no streak) to 1.0 (streak >= 30)
    final intensity = min(streakCount / 30.0, 1.0);

    // Outer flame (orange-red)
    final outerPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          AppColors.streakFire,
          Color.lerp(AppColors.streakFire, AppColors.incorrect, intensity)!,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final outerPath = Path()
      ..moveTo(w * 0.5, 0)
      ..cubicTo(w * 0.15, h * 0.35, w * 0.0, h * 0.55, w * 0.2, h * 0.85)
      ..quadraticBezierTo(w * 0.35, h, w * 0.5, h)
      ..quadraticBezierTo(w * 0.65, h, w * 0.8, h * 0.85)
      ..cubicTo(w * 1.0, h * 0.55, w * 0.85, h * 0.35, w * 0.5, 0)
      ..close();

    canvas.drawPath(outerPath, outerPaint);

    // Inner flame (bright yellow-white core), only visible when streak > 0
    if (streakCount > 0) {
      final innerPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.streakFire.withValues(alpha: 0.9),
            Colors.white.withValues(alpha: 0.6 * intensity),
          ],
        ).createShader(Rect.fromLTWH(w * 0.25, h * 0.3, w * 0.5, h * 0.7));

      final innerPath = Path()
        ..moveTo(w * 0.5, h * 0.3)
        ..cubicTo(w * 0.32, h * 0.5, w * 0.28, h * 0.65, w * 0.35, h * 0.85)
        ..quadraticBezierTo(w * 0.42, h * 0.95, w * 0.5, h * 0.95)
        ..quadraticBezierTo(w * 0.58, h * 0.95, w * 0.65, h * 0.85)
        ..cubicTo(w * 0.72, h * 0.65, w * 0.68, h * 0.5, w * 0.5, h * 0.3)
        ..close();

      canvas.drawPath(innerPath, innerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant StreakFlamePainter oldDelegate) =>
      oldDelegate.streakCount != streakCount;
}

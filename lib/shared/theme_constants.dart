// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/shared/theme_constants.dart
// PURPOSE: Color palette, shadow, and border radius constants for the design system
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Light theme ─────────────────────────────
  static const primary = Color(0xFF5C6BC0);
  static const onPrimary = Color(0xFFFFFFFF);
  static const secondary = Color(0xFFFF7043);
  static const tertiary = Color(0xFF26A69A);
  static const background = Color(0xFFF8F9FA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF0F2F5);
  static const error = Color(0xFFE53935);
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);

  // ── Dark theme ──────────────────────────────
  static const primaryDark = Color(0xFF7986CB);
  static const onPrimaryDark = Color(0xFF000000);
  static const secondaryDark = Color(0xFFFF8A65);
  static const tertiaryDark = Color(0xFF4DB6AC);
  static const backgroundDark = Color(0xFF121212);
  static const surfaceDark = Color(0xFF1E1E1E);
  static const surfaceVariantDark = Color(0xFF2C2C2C);
  static const errorDark = Color(0xFFEF5350);
  static const textPrimaryDark = Color(0xFFE0E0E0);
  static const textSecondaryDark = Color(0xFF9E9E9E);

  // ── Semantic colors ─────────────────────────
  static const correct = Color(0xFF4CAF50);
  static const correctDark = Color(0xFF81C784);
  static const incorrect = Color(0xFFF44336);
  static const incorrectDark = Color(0xFFE57373);
  static const hard = Color(0xFFFF9800);
  static const hardDark = Color(0xFFFFB74D);
  static const easy = Color(0xFF2196F3);
  static const easyDark = Color(0xFF64B5F6);
  static const streakFire = Color(0xFFFFC107);
  static const streakFireDark = Color(0xFFFFD54F);
}

abstract final class AppShadows {
  static const card = [
    BoxShadow(
      color: Color(0x0D000000), // 5% opacity
      offset: Offset(0, 2),
      blurRadius: 8,
    ),
  ];
}

abstract final class AppRadii {
  static const double card = 16;
  static const double button = 12;
  static const double input = 12;
  static const double bottomSheet = 24;
  static const double badge = 100;
}

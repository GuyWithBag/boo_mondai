// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/status_badge.dart
// PURPOSE: Consolidated pill-shaped semantic badge for status/labels
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.showBorder = false,
    this.fontWeight = FontWeight.bold,
    this.backgroundOpacity = 0.12,
  });

  final String label;
  final Color color;
  final bool showBorder;
  final FontWeight fontWeight;
  final double backgroundOpacity;

  /// Orange "Premade" badge.
  const StatusBadge.premade({super.key})
      : label = 'Premade',
        color = AppColors.secondary,
        showBorder = false,
        fontWeight = FontWeight.w500,
        backgroundOpacity = 0.15;

  /// FSRS state badge (0=New, 1=Learning, 2=Review, 3=Relearning).
  StatusBadge.fsrsState({super.key, required int state})
      : label = switch (state) {
          0 => 'New',
          1 => 'Learning',
          2 => 'Review',
          3 => 'Relearning',
          _ => '',
        },
        color = switch (state) {
          0 => AppColors.easy,
          2 => AppColors.correct,
          _ => AppColors.incorrect,
        },
        showBorder = true,
        fontWeight = FontWeight.bold,
        backgroundOpacity = 0.12;

  /// Grey "Uneditable" badge.
  StatusBadge.uneditable({super.key})
      : label = 'Uneditable',
        color = AppColors.textSecondary,
        showBorder = true,
        fontWeight = FontWeight.bold,
        backgroundOpacity = 0.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundOpacity > 0
            ? color.withValues(alpha: backgroundOpacity)
            : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadii.badge),
        border: showBorder
            ? Border.all(
                color: backgroundOpacity > 0
                    ? color.withValues(alpha: 0.3)
                    : scheme.outlineVariant,
              )
            : null,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: backgroundOpacity > 0 ? color : AppColors.textSecondary,
              fontWeight: fontWeight,
            ),
      ),
    );
  }
}

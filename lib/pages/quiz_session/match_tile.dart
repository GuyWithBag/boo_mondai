// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/match_tile.dart
// PURPOSE: Individual tappable tile for match madness term/match pairing
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.dart';

class MatchTile extends StatelessWidget {
  const MatchTile({
    super.key,
    required this.label,
    required this.isMatched,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isMatched;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color;
    if (isMatched) {
      color = AppColors.correct;
    } else if (isSelected) {
      color = AppColors.primary;
    } else {
      color = AppColors.textSecondary;
    }

    return GestureDetector(
      onTap: isMatched ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(AppRadii.button),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: color),
        ),
      ),
    );
  }
}

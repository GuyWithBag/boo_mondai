// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/word_chip_area.dart
// PURPOSE: Tappable word chip area used in word scramble interaction
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class WordChipArea extends StatelessWidget {
  const WordChipArea({
    super.key,
    required this.label,
    required this.chips,
    required this.onTap,
    this.chipColor,
    this.minHeight = 40,
    this.textColor,
  });

  final String label;
  final List<String> chips;
  final void Function(int index) onTap;
  final Color? chipColor;
  final Color? textColor;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(AppRadii.input),
            ),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: List.generate(
                chips.length,
                (i) => GestureDetector(
                  onTap: () => onTap(i),
                  child: Chip(
                    label: Text(chips[i]),
                    backgroundColor:
                        chipColor ?? AppColors.primary.withValues(alpha: 0.12),
                    //TODO: Probably should refine
                    color: WidgetStatePropertyAll(textColor),
                    side: BorderSide.none,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

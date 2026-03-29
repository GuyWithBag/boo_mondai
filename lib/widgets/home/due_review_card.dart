// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/home/due_review_card.dart
// PURPOSE: Card showing count of due FSRS reviews with tap-to-start action
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class DueReviewCard extends StatelessWidget {
  final int dueCount;
  final VoidCallback onTap;
  const DueReviewCard({super.key, required this.dueCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primary,
      child: InkWell(
        onTap: dueCount > 0 ? onTap : null,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(Icons.replay, color: theme.colorScheme.onPrimary, size: 40),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$dueCount card${dueCount == 1 ? '' : 's'} due',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      dueCount > 0
                          ? 'Tap to start review'
                          : "You're all caught up!",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (dueCount > 0)
                Icon(Icons.arrow_forward, color: theme.colorScheme.onPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

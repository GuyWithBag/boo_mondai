// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/researcher_dashboard/completion_matrix.dart
// PURPOSE: Displays a matrix of completion counts with horizontal progress bars
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.dart';

class CompletionMatrix extends StatelessWidget {
  final List<(String, int)> rows;

  const CompletionMatrix({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    final maxN = rows.isEmpty
        ? 1
        : rows.map((r) => r.$2).reduce((a, b) => a > b ? a : b).clamp(1, 999);
    return Column(
      children: rows.map((row) {
        final fraction = row.$2 / maxN;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            children: [
              SizedBox(
                width: 190,
                child: Text(row.$1,
                    style: Theme.of(context).textTheme.bodySmall),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 12,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: 24,
                child: Text(
                  '${row.$2}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

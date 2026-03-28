// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/researcher_dashboard/bar_histogram.dart
// PURPOSE: Vertical bar histogram for displaying score distribution buckets
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

class BarHistogram extends StatelessWidget {
  final List<(String, int)> buckets;

  const BarHistogram({super.key, required this.buckets});

  @override
  Widget build(BuildContext context) {
    final maxCount = buckets.isEmpty
        ? 1
        : buckets.map((b) => b.$2).reduce((a, b) => a > b ? a : b).clamp(1, 999);

    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: buckets.map((bucket) {
          final fraction = bucket.$2 / maxCount;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (bucket.$2 > 0)
                    Text(
                      '${bucket.$2}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  const SizedBox(height: 2),
                  Container(
                    height: 60 * fraction + 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(3)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bucket.$1,
                    style: Theme.of(context).textTheme.labelSmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

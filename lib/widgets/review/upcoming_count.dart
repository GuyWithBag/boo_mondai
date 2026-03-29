// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/review/upcoming_count.dart
// PURPOSE: Displays count of upcoming cards arriving later
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class UpcomingCount extends StatelessWidget {
  const UpcomingCount({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$count more card${count == 1 ? '' : 's'} coming later',
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
    );
  }
}

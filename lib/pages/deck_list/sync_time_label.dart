// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_list/sync_time_label.dart
// PURPOSE: Displays formatted last-synced timestamp in the app bar
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.dart';

class SyncTimeLabel extends StatelessWidget {
  const SyncTimeLabel(this.syncedAt, {super.key});

  final DateTime syncedAt;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.xs),
        child: Text(
          formatSyncTime(syncedAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ),
    );
  }
}

String formatSyncTime(DateTime dt) {
  final now = DateTime.now();
  final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final min = dt.minute.toString().padLeft(2, '0');
  final ampm = dt.hour < 12 ? 'AM' : 'PM';
  if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
    return 'Synced $hour:$min $ampm';
  }
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return 'Synced ${months[dt.month - 1]} ${dt.day}';
}

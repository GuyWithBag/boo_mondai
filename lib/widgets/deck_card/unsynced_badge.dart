// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/deck_card/unsynced_badge.dart
// PURPOSE: Small badge indicating unsynced local changes or push-in-progress
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class UnsyncedBadge extends StatelessWidget {
  const UnsyncedBadge({super.key, required this.isPushing});

  final bool isPushing;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isPushing ? 'Pushing to cloud…' : 'Unsynced local changes',
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.xs),
        child: isPushing
            ? const SizedBox.square(
                dimension: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                Icons.cloud_upload_outlined,
                size: 16,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.7),
              ),
      ),
    );
  }
}

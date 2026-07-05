// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/downloads_tile.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        ChangeTrackerEntry,
        ChangeTrackerStatus,
        Button,
        Deck,
        showViewDeckSingleSheet;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart' show Surface;

class DownloadsTile extends StatelessWidget {
  const DownloadsTile({
    super.key,
    required this.entry,
    required this.progress,
    this.localDeck,
    this.onPause,
    this.onResume,
    this.onCancel,
    this.onDismiss,
  });

  final ChangeTrackerEntry entry;
  final double progress;
  final Deck? localDeck;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onCancel;
  final VoidCallback? onDismiss;

  String get _statusLabel {
    return switch (entry.status) {
      ChangeTrackerStatus.planning => 'Fetching deck info...',
      ChangeTrackerStatus.fetching => 'Fetching deck info...',
      ChangeTrackerStatus.applying => _applyingLabel,
      ChangeTrackerStatus.paused => 'Paused — $_percentLabel',
      ChangeTrackerStatus.completed => _completedLabel,
      ChangeTrackerStatus.failed => 'Download failed.',
      _ => 'Canceled.',
    };
  }

  String get _applyingLabel {
    final pct = _percentLabel;
    if (progress < 0.1) return 'Fetching deck info... $pct';
    if (progress < 0.9) return 'Downloading cards... $pct';
    return 'Saving locally... $pct';
  }

  String get _percentLabel => '${(progress * 100).round()}%';

  String get _completedLabel {
    final cardCount = entry.changes
        .where((c) => c.entityType == 'card_template')
        .length;
    return 'Downloaded $cardCount card${cardCount == 1 ? '' : 's'}.';
  }

  bool get _isActive =>
      entry.status == ChangeTrackerStatus.planning ||
      entry.status == ChangeTrackerStatus.fetching ||
      entry.status == ChangeTrackerStatus.applying ||
      entry.status == ChangeTrackerStatus.paused;

  bool get _isPaused => entry.status == ChangeTrackerStatus.paused;
  bool get _isCompleted => entry.status == ChangeTrackerStatus.completed;
  bool get _isFailed => entry.status == ChangeTrackerStatus.failed;

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Thumbnail placeholder
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: const Icon(Icons.layers_rounded),
            ),
            const SizedBox(width: 12),

            // Title + status + progress
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  if (_isActive) ...[
                    LinearProgressIndicator(
                      value: progress > 0 ? progress : null,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    _statusLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Actions
            if (_isActive) ...[
              if (_isPaused)
                Button(
                  leading: const Icon(Icons.play_arrow_rounded),
                  onPressed: onResume,
                )
              else
                Button(
                  leading: const Icon(Icons.pause_rounded),
                  onPressed: onPause,
                ),
              Button(
                leading: const Icon(Icons.delete_outline_rounded),
                onPressed: onCancel,
              ),
            ] else if (_isCompleted && localDeck != null) ...[
              Button(
                onPressed: () => showViewDeckSingleSheet(context, localDeck!),
                child: const Text('VIEW DECK'),
              ),
              Button(
                leading: const Icon(Icons.delete_outline_rounded),
                onPressed: onDismiss,
              ),
            ] else if (_isFailed) ...[
              Button(
                leading: const Icon(Icons.delete_outline_rounded),
                onPressed: onDismiss,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

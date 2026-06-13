// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/downloads_tile.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        ChangeReviewPlan,
        ChangeReviewStatus,
        Button,
        Deck,
        showViewDeckLocalSheet;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart' show Surface;

class DownloadsTile extends StatelessWidget {
  const DownloadsTile({
    super.key,
    required this.plan,
    required this.progress,
    this.localDeck,
    this.onPause,
    this.onResume,
    this.onCancel,
    this.onDismiss,
  });

  final ChangeReviewPlan plan;
  final double progress;
  final Deck? localDeck;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onCancel;
  final VoidCallback? onDismiss;

  String get _statusLabel {
    return switch (plan.status) {
      ChangeReviewStatus.previewing => 'Fetching deck info...',
      ChangeReviewStatus.applying => _applyingLabel,
      ChangeReviewStatus.paused => 'Paused — ${_percentLabel}',
      ChangeReviewStatus.completed => _completedLabel,
      ChangeReviewStatus.failed => 'Download failed.',
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
    final cardCount = plan.changes
        .where((c) => c.entityType == 'card_template')
        .length;
    return 'Downloaded $cardCount card${cardCount == 1 ? '' : 's'}.';
  }

  bool get _isActive =>
      plan.status == ChangeReviewStatus.previewing ||
      plan.status == ChangeReviewStatus.applying ||
      plan.status == ChangeReviewStatus.paused;

  bool get _isPaused => plan.status == ChangeReviewStatus.paused;
  bool get _isCompleted => plan.status == ChangeReviewStatus.completed;
  bool get _isFailed => plan.status == ChangeReviewStatus.failed;

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
                color: Theme.of(context).colorScheme.surfaceVariant,
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
                    plan.title,
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
                Button.icon(icon: Icons.play_arrow_rounded, onPressed: onResume)
              else
                Button.icon(icon: Icons.pause_rounded, onPressed: onPause),
              Button.icon(
                icon: Icons.delete_outline_rounded,
                onPressed: onCancel,
              ),
            ] else if (_isCompleted && localDeck != null) ...[
              Button(
                onPressed: () => showViewDeckLocalSheet(context, localDeck!),
                child: const Text('VIEW DECK'),
              ),
              Button.icon(
                icon: Icons.delete_outline_rounded,
                onPressed: onDismiss,
              ),
            ] else if (_isFailed) ...[
              Button.icon(
                icon: Icons.delete_outline_rounded,
                onPressed: onDismiss,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

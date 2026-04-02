import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter/material.dart';

class DeckDetails extends StatelessWidget {
  const DeckDetails({
    super.key,
    required this.deck,
    this.author,
    this.sourceAuthor,
  });

  final Deck deck;
  final CachedProfile? author;
  final CachedProfile? sourceAuthor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Title + version
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                deck.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Chip(
              label: Text(
                'v${deck.version}',
                style: theme.textTheme.labelSmall,
              ),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        // Author avatars row
        AuthorAvatarRow(author: author, sourceAuthor: sourceAuthor),
        const SizedBox(height: AppSpacing.sm),
        // Metadata chips
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            MetaChip(deck.targetLanguage),
            MetaChip('${deck.cardCount} cards'),
            if (deck.isPremade) const MetaChip('Premade'),
            for (final tag in deck.tags) MetaChip('#$tag'),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        // Short description
        if (deck.shortDescription.isNotEmpty) ...[
          Text(
            deck.shortDescription,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        // Long description
        if (deck.longDescription.isNotEmpty) ...[
          Text(deck.longDescription, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
        ],
      ],
    );
  }
}

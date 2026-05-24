// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/online_deck_detail_sheet.dart
// PURPOSE: Bottom sheet shown when tapping a deck in the online browser
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class DeckDetailSheet extends HookWidget {
  const DeckDetailSheet({super.key, required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final author = _cachedProfileFromAuthor(deck.author);

    Future<void> copyDeck() async {
      final auth = context.read<AuthController>();
      final now = DateTime.now();
      final copy = Deck(
        id: uuid.v7(),
        userId: auth.currentProfile.id,
        title: deck.title,
        shortDescription: deck.shortDescription,
        longDescription: deck.longDescription,
        coverImageUrl: deck.coverImageUrl,
        sourceDeckId: deck.sourceDeckId ?? deck.id,
        isPremade: false,
        visibilityState: VisibilityState.private,
        isPublished: false,
        isEditable: true,
        cardCount: deck.cardCount,
        version: deck.version,
        buildNumber: deck.buildNumber,
        createdAt: now,
        updatedAt: now,
        tags: deck.tags,
      );

      await LocalDB.deck.upsert(copy);

      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Deck copied to My Decks.')));
      context.read<ViewDecksLocalController>().load();
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                children: [
                  DeckDetails(
                    deck: deck,
                    author: author,
                    sourceAuthor: null,
                  ),
                  _ListingStats(listing: deck.listing),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton.icon(
                    onPressed: copyDeck,
                    icon: const Icon(Icons.file_copy_outlined),
                    label: const Text('Copy to My Decks'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _CommentsPlaceholder(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  CachedProfile? _cachedProfileFromAuthor(Profile? author) {
    if (author == null) return null;

    return CachedProfile(
      id: author.id,
      username: author.username,
      avatarUrl: author.avatarUrl,
      createdAt: author.createdAt,
    );
  }
}

class _ListingStats extends StatelessWidget {
  const _ListingStats({required this.listing});

  final DeckListing? listing;

  @override
  Widget build(BuildContext context) {
    if (listing == null) return const SizedBox.shrink();

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        _ListingStatChip(
          icon: Icons.thumb_up_alt_outlined,
          label: '${listing!.upvotesCount} upvotes',
        ),
        _ListingStatChip(
          icon: Icons.thumb_down_alt_outlined,
          label: '${listing!.downvotesCount} downvotes',
        ),
        _ListingStatChip(
          icon: Icons.download_outlined,
          label: '${listing!.downloadsCount} downloads',
        ),
        _ListingStatChip(
          icon: Icons.favorite_border,
          label: '${listing!.favoritesCount} favorites',
        ),
        _ListingStatChip(
          icon: Icons.call_split_outlined,
          label: '${listing!.forksCount} forks',
        ),
        _ListingStatChip(
          icon: Icons.rate_review_outlined,
          label: '${listing!.reviewsCount} reviews',
        ),
        _ListingStatChip(
          icon: Icons.chat_bubble_outline,
          label: '${listing!.commentsCount} comments',
        ),
      ],
    );
  }
}

class _ListingStatChip extends StatelessWidget {
  const _ListingStatChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }
}

class _CommentsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 18,
              color: scheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Comments',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadii.card),
          ),
          child: Text(
            'Comments are coming soon.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

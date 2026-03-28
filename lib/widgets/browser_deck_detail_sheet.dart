// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/browser_deck_detail_sheet.dart
// PURPOSE: Bottom sheet shown when tapping a deck in the online browser
// PROVIDERS: AuthProvider, DeckProvider, SupabaseService
// HOOKS: useEffect, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/services/services.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/widgets/widgets.dart';

// ── Types ─────────────────────────────────────────────────────────

typedef _ProfileInfo = ({String displayName, String? avatarUrl});

// ── Deck detail bottom sheet ──────────────────────────────────────

class DeckDetailSheet extends HookWidget {
  const DeckDetailSheet({super.key, required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final supabase = context.read<SupabaseService>();

    // Fetch author profiles asynchronously
    final authorProfile = useState<_ProfileInfo?>(null);
    final originalAuthorProfile = useState<_ProfileInfo?>(null);

    useEffect(() {
      Future.microtask(() async {
        final raw = await supabase.getProfile(deck.creatorId);
        if (raw != null) {
          authorProfile.value = (
            displayName: raw['display_name'] as String? ?? 'Unknown',
            avatarUrl: raw['avatar_url'] as String?,
          );
        }
        if (deck.sourceDeckCreatorId != null) {
          final srcRaw = await supabase.getProfile(deck.sourceDeckCreatorId!);
          if (srcRaw != null) {
            originalAuthorProfile.value = (
              displayName: srcRaw['display_name'] as String? ?? 'Unknown',
              avatarUrl: srcRaw['avatar_url'] as String?,
            );
          }
        }
      });
      return null;
    }, [deck.creatorId, deck.sourceDeckCreatorId]);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollController) => Column(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Container(
              width: 32,
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
                _AuthorAvatarRow(
                  authorProfile: authorProfile.value,
                  originalAuthorProfile: originalAuthorProfile.value,
                  hasOriginal: deck.sourceDeckCreatorId != null,
                ),
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
                const Divider(),
                const SizedBox(height: AppSpacing.md),
                // Copy action — user must copy before they can play
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    final auth = context.read<AuthProvider>();
                    if (!auth.isAuthenticated) return;
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (_) => _CopySheet(deck: deck),
                    );
                  },
                  icon: const Icon(Icons.file_copy_outlined),
                  label: const Text('Copy to My Decks'),
                ),
                const SizedBox(height: AppSpacing.xl),
                // Comments placeholder
                Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 18,
                      color: AppColors.textSecondary,
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
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppRadii.card),
                  ),
                  child: Text(
                    'Comments are coming soon. You\'ll be able to leave '
                    'feedback for the deck author and reply to other learners.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Author avatars row ────────────────────────────────────────────

class _AuthorAvatarRow extends StatelessWidget {
  const _AuthorAvatarRow({
    required this.authorProfile,
    required this.originalAuthorProfile,
    required this.hasOriginal,
  });

  final _ProfileInfo? authorProfile;
  final _ProfileInfo? originalAuthorProfile;
  final bool hasOriginal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _AvatarWithLabel(
          profile: authorProfile,
          label: hasOriginal ? 'Published by' : 'By',
        ),
        if (hasOriginal) ...[
          const SizedBox(width: AppSpacing.lg),
          _AvatarWithLabel(
            profile: originalAuthorProfile,
            label: 'Original by',
            isOriginal: true,
          ),
        ],
      ],
    );
  }
}

class _AvatarWithLabel extends StatelessWidget {
  const _AvatarWithLabel({
    required this.profile,
    required this.label,
    this.isOriginal = false,
  });

  final _ProfileInfo? profile;
  final String label;
  final bool isOriginal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final name = profile?.displayName ?? '…';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: isOriginal ? 16 : 18,
              backgroundColor: isOriginal
                  ? scheme.tertiaryContainer
                  : scheme.primaryContainer,
              backgroundImage: profile?.avatarUrl != null
                  ? NetworkImage(profile!.avatarUrl!)
                  : null,
              child: profile?.avatarUrl == null
                  ? Text(
                      initials,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isOriginal
                            ? scheme.onTertiaryContainer
                            : scheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            if (isOriginal)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: scheme.tertiary,
                    shape: BoxShape.circle,
                    border: Border.all(color: scheme.surface, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.xs),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              name,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Copy confirmation bottom sheet ────────────────────────────────

class _CopySheet extends HookWidget {
  const _CopySheet({required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    final isCopying = useState(false);
    final error = useState<String?>(null);

    Future<void> doCopy() async {
      isCopying.value = true;
      error.value = null;
      try {
        final userId = context.read<AuthProvider>().userProfile!.id;
        final deckProvider = context.read<DeckProvider>();
        final result = await deckProvider.copyDeck(userId, deck);
        if (!context.mounted) return;
        if (result == null) {
          error.value = deckProvider.error ?? 'Copy failed — please try again';
          isCopying.value = false;
          return;
        }
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${deck.title}" copied to My Decks')),
        );
        context.go('/my-decks');
      } catch (e) {
        error.value = e.toString();
        isCopying.value = false;
      }
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Copy "${deck.title}"?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'All ${deck.cardCount} cards will be copied to your My Decks. '
              'Each card will keep a link to the original so you can pull '
              'in the author\'s future updates.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (error.value != null) ...[
              const SizedBox(height: AppSpacing.sm),
              ErrorText(error.value!),
            ],
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: isCopying.value ? null : doCopy,
                    child: isCopying.value
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Copy'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

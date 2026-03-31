// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/browser_deck_detail_sheet.dart
// PURPOSE: Bottom sheet shown when tapping a deck in the online browser
// PROVIDERS: AuthProvider, DeckProvider, SupabaseService
// HOOKS: useEffect, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class DeckDetailSheet extends HookWidget {
  const DeckDetailSheet({super.key, required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final supabase = context.read<SupabaseService>();

    // Fetch author profiles asynchronously
    final authorProfile = useState<ProfileInfo?>(null);
    final originalAuthorProfile = useState<ProfileInfo?>(null);

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
                DeckDetails(
                  deck: deck,
                  authorProfile: authorProfile.value,
                  originalAuthorProfile: originalAuthorProfile.value,
                ),
                const SizedBox(height: AppSpacing.md),
                // Copy action — user must copy before they can play
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    final auth = context.read<AuthProvider>();
                    if (!auth.isAuthenticated) return;
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (_) => CopySheet(deck: deck),
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

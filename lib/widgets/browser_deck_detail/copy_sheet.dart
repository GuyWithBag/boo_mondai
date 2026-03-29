// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/browser_deck_detail/copy_sheet.dart
// PURPOSE: Bottom sheet confirmation dialog for copying a deck to My Decks
// PROVIDERS: AuthProvider, DeckProvider
// HOOKS: useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class CopySheet extends HookWidget {
  const CopySheet({super.key, required this.deck});

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

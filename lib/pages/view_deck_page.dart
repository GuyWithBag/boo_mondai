// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/view_deck_page.dart
// PURPOSE: View a deck's cards and start quiz or preview
// PROVIDERS: ViewDeckController, DeckProvider
// HOOKS: useEffect, useScrollController, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/repositories/repositories.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class ViewDeckPage extends HookWidget {
  final String? deckId;
  const ViewDeckPage({super.key, required this.deckId});

  @override
  Widget build(BuildContext context) {
    if (deckId == null) {
      return Center(child: ErrorText('Error 404: deck Id not found'));
    }
    final deckRepo = Repositories.deck;
    final currentDeck = deckRepo.getById(deckId!);
    final cachedProfsRepo = Repositories.cachedProfile;
    final author = cachedProfsRepo.getById(currentDeck!.authorId);
    final sourceAuthor = cachedProfsRepo.getById(
      currentDeck.sourceAuthorId ?? '',
    );

    Future<void> deleteDeckDialog() async {
      final title = currentDeck.title;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete deck?'),
          content: Text('"$title" and all its cards will be removed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      if (confirmed == true && context.mounted) {
        // await deckProv.deleteDeck(deckId);

        if (context.mounted) context.pop();
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/my-decks/$deckId/edit'),
        child: const Icon(Icons.edit_rounded),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.push('/quiz/$deckId/preview'),
                child: const Text('Preview'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: FilledButton(
                onPressed: () => context.go('/quiz/$deckId/session'),
                child: const Text('Start Quiz'),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(currentDeck.title),
        actions: [
          // if (vdc.isDirty)
          //   Tooltip(
          //     message: 'Unsaved changes',
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: AppSpacing.xs,
          //       ),
          //       child: TextButton.icon(
          //         onPressed: () async {
          //           await context.read<ViewDeckController>().save();
          //           if (context.mounted) {
          //             ScaffoldMessenger.of(context).showSnackBar(
          //               const SnackBar(content: Text('Saved')),
          //             );
          //           }
          //         },
          //         icon: const Icon(Icons.save_outlined, size: 18),
          //         label: const Text('Save'),
          //       ),
          //     ),
          //   ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit deck',
            onPressed: () => context.push('/my-decks/$deckId/edit'),
          ),

          IconButton(
            onPressed: () {
              deleteDeckDialog();
            },
            icon: Icon(Icons.delete_outline, size: 18, color: Colors.red),
          ),
          // PopupMenuButton<String>(
          //   tooltip: 'More options',
          //   onSelected: (value) {
          //     if (value == 'delete') confirmDeleteDeck();
          //   },
          //   itemBuilder: (context) => const [
          //     PopupMenuItem(
          //       value: 'delete',
          //       child: Row(
          //         children: [
          //           Icon(Icons.delete_outline, size: 18, color: Colors.red),
          //           SizedBox(width: 8),
          //           Text('Delete deck', style: TextStyle(color: Colors.red)),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),

      body: DeckDetails(
        deck: currentDeck,
        author: author,
        sourceAuthor: sourceAuthor,
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_creator_page.dart
// PURPOSE: Create or edit a deck with title, short/long description, target language, and publish toggle
// PROVIDERS: DeckProvider, AuthProvider, CardProvider
// HOOKS: useTextEditingController, useEffect, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/controllers/my_decks_page_controller.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/repositories/repositories.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

// ... imports remains the same
// ... imports ...

class CreateDeckPage extends HookWidget {
  const CreateDeckPage({super.key, this.deckId});

  final String? deckId;

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final shortDescController = useTextEditingController();
    final longDescController = useTextEditingController();
    final langController = useTextEditingController(text: 'japanese');
    final formKey = useMemoized(GlobalKey<FormState>.new);

    final isPublished = useState(true);
    final wasPublicInitially = useState(true);
    final isPublic = useState(false);

    final auth = context.read<AuthProvider>();
    final isEdit = deckId != null;
    final deckRepo = Repositories.deck;

    // Load existing data if editing
    useEffect(() {
      if (isEdit) {
        final existing = deckRepo
            .getByCurrentUser()
            .where((d) => d.id == deckId)
            .firstOrNull;

        if (existing != null) {
          titleController.text = existing.title;
          shortDescController.text = existing.shortDescription;
          longDescController.text = existing.longDescription;
          langController.text = existing.targetLanguage;
          isPublished.value = existing.isPublished;
          isPublic.value = existing.isPublic;
          wasPublicInitially.value = existing.isPublic;
        }
      }
      return null;
    }, [deckId]);

    Future<void> handleSave() async {
      if (!formKey.currentState!.validate()) return;

      final userId = auth.userProfile?.id;
      if (userId == null) return;

      String? finalDeckId;

      if (isEdit) {
        final existing = deckRepo
            .getByCurrentUser()
            .where((d) => d.id == deckId)
            .firstOrNull;

        if (existing != null) {
          final updated = existing.copyWith(
            title: titleController.text.trim(),
            shortDescription: shortDescController.text.trim(),
            longDescription: longDescController.text.trim(),
            targetLanguage: langController.text.trim(),
            isPublic: isPublic.value,
            isPublished: isPublished.value,
            updatedAt: DateTime.now(), // Manual update for edit
          );
          await deckRepo.save(updated);
          finalDeckId = existing.id;
        }
      } else {
        // Use the factory for New Decks (Auto-UUID & Auto-Timestamps)
        final newDeck = Deck.createNow(
          authorId: userId,
          title: titleController.text.trim(),
          shortDescription: shortDescController.text.trim(),
          longDescription: longDescController.text.trim(),
          targetLanguage: langController.text.trim(),
          isPremade: false,
          isPublic: isPublic.value,
          isPublished: isPublished.value,
          cardCount: 0,
        );

        await deckRepo.save(newDeck);
        finalDeckId = newDeck.id;
      }

      if (!context.mounted) return;

      // SnackBar logic for first-time publishing
      final beingPublished =
          isPublished.value && (!isEdit || !wasPublicInitially.value);
      if (beingPublished && finalDeckId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your deck will be published after your next sync.'),
          ),
        );
      }

      context.pop();
      context.read<MyDecksPageController>().load();
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Deck' : 'Create Deck')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Title is required'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: shortDescController,
                      decoration: const InputDecoration(
                        labelText: 'Short Description',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: longDescController,
                      decoration: const InputDecoration(
                        labelText: 'Long Description',
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: langController,
                      decoration: const InputDecoration(
                        labelText: 'Target Language',
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Language is required'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PublishToggle(
                      value: isPublished.value,
                      onChanged: (v) => isPublished.value = v,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    FilledButton(
                      onPressed: handleSave,
                      child: Text(isEdit ? 'Save' : 'Create'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

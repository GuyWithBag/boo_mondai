// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_creator_page.dart
// PURPOSE: Create or edit a deck with title, descriptions, visibility, and publish toggle
// PROVIDERS: DeckProvider, AuthController, CardProvider
// HOOKS: useTextEditingController, useEffect, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class CreateDeckPage extends HookWidget {
  const CreateDeckPage({super.key, this.deckId});

  final String? deckId;

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final shortDescController = useTextEditingController();
    final longDescController = useTextEditingController();
    final formKey = useMemoized(GlobalKey<FormState>.new);

    final isPublished = useState(true);
    final wasPublishedInitially = useState(true);

    // Use the new VisibilityState enum
    final visibilityState = useState(VisibilityState.private);

    final auth = context.read<AuthController>();
    final isEdit = deckId != null;
    final deckDB = LocalDB.deck;

    // Load existing data if editing
    useEffect(() {
      if (isEdit) {
        final existing = deckDB
            .getByCurrentUser()
            .where((d) => d.id == deckId)
            .firstOrNull;

        if (existing != null) {
          titleController.text = existing.title;
          shortDescController.text = existing.shortDescription;
          longDescController.text = existing.longDescription;
          isPublished.value = existing.isPublished;
          wasPublishedInitially.value = existing.isPublished;
          visibilityState.value = existing.visibilityState;
        }
      }
      return null;
    }, [deckId]);

    Future<void> handleSave() async {
      if (!formKey.currentState!.validate()) return;

      final userId = auth.currentProfile.id;
      String? finalDeckId;

      if (isEdit) {
        final existing = deckDB
            .getByCurrentUser()
            .where((d) => d.id == deckId)
            .firstOrNull;

        if (existing != null) {
          final updated = existing.copyWith(
            title: titleController.text.trim(),
            shortDescription: shortDescController.text.trim(),
            longDescription: longDescController.text.trim(),
            visibilityState: visibilityState.value,
            isPublished: isPublished.value,
            updatedAt: DateTime.now(), // Manual update for edit
          );
          await deckDB.upsert(updated);
          finalDeckId = existing.id;
        }
      } else {
        // Use the factory for New Decks (Auto-UUID & Auto-Timestamps)
        final newDeck = Deck.createNow(
          userId: userId,
          title: titleController.text.trim(),
          shortDescription: shortDescController.text.trim(),
          longDescription: longDescController.text.trim(),
          visibilityState: visibilityState.value,
          isPremade: false,
          isPublished: isPublished.value,
        );

        await deckDB.upsert(newDeck);
        finalDeckId = newDeck.id;
      }

      if (!context.mounted) return;

      // SnackBar logic for first-time publishing
      final beingPublished =
          isPublished.value && (!isEdit || !wasPublishedInitially.value);
      if (beingPublished && finalDeckId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your deck will be published after your next sync.'),
          ),
        );
      }

      context.pop();
      context.read<ViewDecksLocalController>().load();
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

                    // Replaced Language Field and isPublic toggle with Visibility Dropdown
                    DropdownButtonFormField<VisibilityState>(
                      value: visibilityState.value,
                      decoration: const InputDecoration(
                        labelText: 'Visibility',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: VisibilityState.private,
                          child: Text('Private (Only you)'),
                        ),
                        DropdownMenuItem(
                          value: VisibilityState.unlisted,
                          child: Text('Unlisted (Anyone with link)'),
                        ),
                        DropdownMenuItem(
                          value: VisibilityState.public,
                          child: Text('Public (Discoverable)'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) visibilityState.value = v;
                      },
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

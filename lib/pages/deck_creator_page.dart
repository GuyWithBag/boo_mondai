// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_creator_page.dart
// PURPOSE: Create or edit a deck with title, short/long description, target language, and publish toggle
// PROVIDERS: DeckProvider, AuthProvider, CardProvider
// HOOKS: useTextEditingController, useEffect, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/widgets/widgets.dart';

class DeckCreatorPage extends HookWidget {
  const DeckCreatorPage({super.key, this.deckId});

  final String? deckId;

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final shortDescController = useTextEditingController();
    final longDescController = useTextEditingController();
    final langController = useTextEditingController(text: 'japanese');
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final isPublic = useState(true);
    final wasPublicInitially = useState(true);
    final deckProvider = context.watch<DeckProvider>();
    final auth = context.read<AuthProvider>();
    final isEdit = deckId != null;

    useEffect(() {
      if (isEdit) {
        final existing = deckProvider.userDecks
            .where((d) => d.id == deckId)
            .firstOrNull;
        if (existing != null) {
          titleController.text = existing.title;
          shortDescController.text = existing.shortDescription;
          longDescController.text = existing.longDescription;
          langController.text = existing.targetLanguage;
          isPublic.value = existing.isPublic;
          wasPublicInitially.value = existing.isPublic;
        }
      }
      return null;
    }, [deckId]);

    Future<void> save() async {
      if (!formKey.currentState!.validate()) return;
      final userId = auth.userProfile?.id;
      if (userId == null) return;

      String? savedDeckId;

      if (isEdit) {
        final existing = deckProvider.userDecks
            .where((d) => d.id == deckId)
            .firstOrNull;
        if (existing != null) {
          await context.read<DeckProvider>().updateDeck(
                existing.copyWith(
                  title: titleController.text.trim(),
                  shortDescription: shortDescController.text.trim(),
                  longDescription: longDescController.text.trim(),
                  targetLanguage: langController.text.trim(),
                  isPublic: isPublic.value,
                  updatedAt: DateTime.now(),
                ),
              );
          savedDeckId = deckId;
        }
      } else {
        final newDeck = await context.read<DeckProvider>().createDeck(
              userId,
              titleController.text.trim(),
              shortDescController.text.trim(),
              langController.text.trim(),
              isPublic: isPublic.value,
            );
        savedDeckId = newDeck?.id;
      }

      if (!context.mounted) return;

      // Show snackbar when publishing for the first time
      final beingPublished =
          isPublic.value && (!isEdit || !wasPublicInitially.value);
      if (beingPublished && savedDeckId != null) {
        final capturedCardProv = context.read<CardProvider>();
        final capturedDeckId = savedDeckId;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Your deck will be published after your next sync.'),
            action: SnackBarAction(
              label: 'Sync Now',
              onPressed: () => capturedCardProv.pushDeck(capturedDeckId),
            ),
          ),
        );
      }

      context.pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Deck' : 'Create Deck'),
      ),
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
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'e.g. JLPT N5 Vocabulary',
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Title is required'
                              : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: shortDescController,
                      decoration: const InputDecoration(
                        labelText: 'Short Description',
                        hintText: 'One-line summary shown in list tiles',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: longDescController,
                      decoration: const InputDecoration(
                        labelText: 'Long Description',
                        hintText:
                            'Full description shown on the deck detail page',
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: langController,
                      decoration: const InputDecoration(
                        labelText: 'Target Language',
                        hintText: 'e.g. japanese',
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Language is required'
                              : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _PublishToggle(
                      value: isPublic.value,
                      onChanged: (v) => isPublic.value = v,
                    ),
                    if (deckProvider.error != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      ErrorText(deckProvider.error!),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    FilledButton(
                      onPressed: deckProvider.isLoading ? null : save,
                      child: deckProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(isEdit ? 'Save' : 'Create'),
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

// ── Publish toggle row ────────────────────────────────────────────

class _PublishToggle extends StatelessWidget {
  const _PublishToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.surfaceContainerHighest,
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: const Text('Publish to public browser'),
        subtitle: Text(
          value
              ? 'Anyone can find and copy this deck'
              : 'Only you can see this deck',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        secondary: Icon(
          value ? Icons.public : Icons.lock_outline,
          color: value ? scheme.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}

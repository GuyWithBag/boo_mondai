// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_creator_page.dart
// PURPOSE: Create or edit a deck with title, description, and target language
// PROVIDERS: DeckProvider, AuthProvider
// HOOKS: useTextEditingController, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/auth_provider.dart';
import 'package:boo_mondai/providers/deck_provider.dart';
import 'package:boo_mondai/shared/app_spacing.dart';

class DeckCreatorPage extends HookWidget {
  const DeckCreatorPage({super.key, this.deckId});

  final String? deckId;

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final descController = useTextEditingController();
    final langController = useTextEditingController(text: 'japanese');
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final deckProvider = context.watch<DeckProvider>();
    final auth = context.read<AuthProvider>();
    final isEdit = deckId != null;

    useEffect(() {
      if (isEdit) {
        final existing = deckProvider.decks
            .where((d) => d.id == deckId)
            .firstOrNull;
        if (existing != null) {
          titleController.text = existing.title;
          descController.text = existing.description;
          langController.text = existing.targetLanguage;
        }
      }
      return null;
    }, [deckId]);

    Future<void> save() async {
      if (!formKey.currentState!.validate()) return;
      final userId = auth.userProfile?.id;
      if (userId == null) return;

      if (isEdit) {
        final existing = deckProvider.decks
            .where((d) => d.id == deckId)
            .firstOrNull;
        if (existing != null) {
          await context.read<DeckProvider>().updateDeck(
                existing.copyWith(
                  title: titleController.text.trim(),
                  description: descController.text.trim(),
                  targetLanguage: langController.text.trim(),
                  updatedAt: DateTime.now(),
                ),
              );
        }
      } else {
        await context.read<DeckProvider>().createDeck(
              userId,
              titleController.text.trim(),
              descController.text.trim(),
              langController.text.trim(),
            );
      }

      if (context.mounted) context.pop();
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
                          (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Optional description',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: langController,
                      decoration: const InputDecoration(
                        labelText: 'Target Language',
                        hintText: 'e.g. japanese',
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Language is required' : null,
                    ),
                    if (deckProvider.error != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        deckProvider.error!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
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

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/card_editor_page.dart
// PURPOSE: Add or edit a card within a deck
// PROVIDERS: CardProvider
// HOOKS: useTextEditingController, useFocusNode, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/card_provider.dart';
import 'package:boo_mondai/shared/app_spacing.dart';

class CardEditorPage extends HookWidget {
  const CardEditorPage({super.key, required this.deckId, this.cardId});

  final String deckId;
  final String? cardId;

  @override
  Widget build(BuildContext context) {
    final questionController = useTextEditingController();
    final answerController = useTextEditingController();
    final questionFocus = useFocusNode();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final cardProvider = context.watch<CardProvider>();
    final isEdit = cardId != null;

    useEffect(() {
      questionFocus.requestFocus();
      if (isEdit) {
        final existing =
            cardProvider.cards.where((c) => c.id == cardId).firstOrNull;
        if (existing != null) {
          questionController.text = existing.question;
          answerController.text = existing.answer;
        }
      }
      return null;
    }, [cardId]);

    Future<void> save() async {
      if (!formKey.currentState!.validate()) return;

      if (isEdit) {
        final existing =
            cardProvider.cards.where((c) => c.id == cardId).firstOrNull;
        if (existing != null) {
          await context.read<CardProvider>().updateCard(
                existing.copyWith(
                  question: questionController.text.trim(),
                  answer: answerController.text.trim(),
                ),
              );
        }
      } else {
        await context.read<CardProvider>().addCard(
              deckId,
              questionController.text.trim(),
              answerController.text.trim(),
            );
      }

      if (context.mounted) context.pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Card' : 'Add Card'),
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
                      controller: questionController,
                      focusNode: questionFocus,
                      decoration: const InputDecoration(
                        labelText: 'Question / Term',
                        hintText: 'e.g. 犬',
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: answerController,
                      decoration: const InputDecoration(
                        labelText: 'Answer(s)',
                        hintText: 'Comma-separated: dog, いぬ, inu',
                        helperText: 'Multiple accepted answers separated by commas',
                      ),
                      maxLines: 2,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    if (cardProvider.error != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        cardProvider.error!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    FilledButton(
                      onPressed: save,
                      child: Text(isEdit ? 'Save' : 'Add Card'),
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

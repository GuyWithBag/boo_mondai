// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/flashcard_interaction.dart
// PURPOSE: Flashcard interaction with reveal answer button and Space shortcut
// PROVIDERS: QuizProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';

class FlashcardInteraction extends StatelessWidget {
  const FlashcardInteraction({
    super.key,
    required this.card,
    required this.quiz,
  });
  final DeckCard card;
  final QuizProvider quiz;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      child: Actions(
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) => context.read<QuizProvider>().revealAnswer(),
          ),
        },
        child: SizedBox(
          width: double.infinity,
          child: Tooltip(
            message: 'Press Space',
            child: FilledButton.icon(
              onPressed: () => context.read<QuizProvider>().revealAnswer(),
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('Show Answer'),
            ),
          ),
        ),
      ),
    );
  }
}

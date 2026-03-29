// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/identification_interaction.dart
// PURPOSE: Text input interaction for identification question type
// PROVIDERS: QuizProvider
// HOOKS: useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';

class IdentificationInteraction extends HookWidget {
  const IdentificationInteraction({
    super.key,
    required this.card,
    required this.quiz,
    required this.shakeController,
  });
  final DeckCard card;
  final QuizProvider quiz;
  final AnimationController shakeController;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    void submit() {
      final answer = controller.text.trim();
      if (answer.isEmpty) return;
      final isCorrect = card.checkAnswer(answer);
      if (!isCorrect) shakeController.forward(from: 0);
      context.read<QuizProvider>().submitIdentificationAnswer(answer);
      controller.clear();
    }

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      },
      child: Actions(
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) => submit(),
          ),
        },
        child: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Type your answer...',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: submit,
            ),
          ),
          onSubmitted: (_) => submit(),
        ),
      ),
    );
  }
}

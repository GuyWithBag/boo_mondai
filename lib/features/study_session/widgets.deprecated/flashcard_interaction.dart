// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/drill_session/flashcard_interaction.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/features/cards/models/flashcard_template.dto.dart'
    show FlashcardTemplate;
import 'package:boo_mondai/lib.barrel.dart'
    show StudySessionCardStageController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FlashcardInteraction extends HookWidget {
  const FlashcardInteraction({
    super.key,
    required this.template, // <-- Changed from card
    required this.isReversed,
    required this.controller, // <-- Added flip state
  });

  final FlashcardTemplate template;
  final bool isReversed;
  final StudySessionCardStageController controller;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      controller.setCanReveal(true);
      controller.answer = template.getAnswer(isReversed: isReversed);
      return null;
    }, []);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Use our smart getters! They automatically show the right text.
        Text(
          template.getQuestion(isReversed: isReversed),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}

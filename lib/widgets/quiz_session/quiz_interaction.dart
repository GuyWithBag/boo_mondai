// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/quiz_interaction.dart
// PURPOSE: Dispatches to the correct interaction widget based on template type
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuizInteraction extends HookWidget {
  const QuizInteraction({
    super.key,
    required this.template,
    required this.reviewCard,
    required this.controller,
    required this.shakeController,
  });

  final CardTemplate template;
  final ReviewCard reviewCard;
  final SessionController controller;
  final AnimationController shakeController;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      controller.calculateNextIntervals();
      return null;
    });
    return switch (template) {
      FlashcardTemplate f => FlashcardInteraction(
        template: f,
        isReversed: reviewCard.isReversed,
        controller: controller,
      ),
      IdentificationTemplate i => IdentificationInteraction(
        template: i,
        isReversed: reviewCard.isReversed,
        controller: controller,
        shakeController: shakeController,
      ),
      MultipleChoiceTemplate m => MultipleChoiceInteraction(
        template: m,
        isReversed: reviewCard.isReversed,
        controller: controller,
        shakeController: shakeController,
      ),
      FillInTheBlanksTemplate fb => FitbInteraction(
        template: fb,
        isReversed: reviewCard.isReversed,
        controller: controller,
        shakeController: shakeController,
      ),
      WordScrambleTemplate ws => WordScrambleInteraction(
        template: ws,
        isReversed: reviewCard.isReversed,
        controller: controller,
        shakeController: shakeController,
      ),
      MatchMadnessTemplate mm => MatchMadnessInteraction(
        template: mm,
        controller: controller,
      ),

      // <-- NEW: The wildcard fallback required for abstract classes
      _ => Center(
        child: Text(
          'Unsupported card type: ${template.runtimeType}',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    };
  }
}

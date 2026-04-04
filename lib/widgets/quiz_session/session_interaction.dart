// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/quiz_interaction.dart
// PURPOSE: Dispatches to the correct interaction widget based on template type
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SessionInteraction extends HookWidget {
  const SessionInteraction({
    super.key,
    required this.template,
    required this.reviewCard,
    required this.controller,
    required this.shakeController,
    required this.interactionsController,
  });

  final CardTemplate template;
  final ReviewCard reviewCard;
  final SessionController controller;
  final SessionInteractionsController interactionsController;
  final AnimationController shakeController;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      controller.calculateNextIntervals();

      return null;
    }, []);

    return switch (template) {
      FlashcardTemplate f => FlashcardInteraction(
        template: f,
        isReversed: reviewCard.isReversed,
        controller: interactionsController,
      ),
      IdentificationTemplate i => IdentificationInteraction(
        template: i,
        controller: interactionsController,
        shakeController: shakeController,
      ),
      MultipleChoiceTemplate m => MultipleChoiceInteraction(
        template: m,
        controller: interactionsController,
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
        controller: interactionsController,
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

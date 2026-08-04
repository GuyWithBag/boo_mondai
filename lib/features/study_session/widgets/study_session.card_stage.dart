import 'package:boo_mondai/lib.barrel.dart'
    show
        StudySessionController,
        FlashcardTemplate,
        IdentificationTemplate,
        StudySessionCardStageController,
        CardTemplate,
        MultipleChoiceTemplate,
        FillInTheBlanksTemplate,
        MatchMadnessTemplate,
        WordScrambleTemplate,
        FlashcardCard,
        MultipleChoiceCard,
        FillInTheBlanksCard,
        MatchingTypeCard,
        IdentificationCard,
        WordScrambleCard;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StudySessionCardStage extends HookWidget {
  const StudySessionCardStage({
    required this.studySessionController,
    required this.interactionsController,
    super.key,
  });

  final StudySessionController studySessionController;
  final StudySessionCardStageController interactionsController;

  // Temporary helper
  static bool isImplemented(CardTemplate template) {
    return template is FlashcardTemplate ||
        template is MultipleChoiceTemplate ||
        template is IdentificationTemplate ||
        template is FillInTheBlanksTemplate ||
        template is MatchMadnessTemplate ||
        template is WordScrambleTemplate;
  }

  @override
  Widget build(BuildContext context) {
    final template = studySessionController.currentTemplate;
    final studyCard = studySessionController.currentStudyCard;

    if (template == null || studyCard == null) {
      return const Center(child: Text('No card available'));
    }

    final child = switch (template) {
      FlashcardTemplate f => FlashcardCard(
        template: f,
        studyCard: studyCard,
        interactionsController: interactionsController,
        studySessionController: studySessionController,
      ),
      MultipleChoiceTemplate m => MultipleChoiceCard(
        template: m,
        interactionsController: interactionsController,
      ),
      IdentificationTemplate i => IdentificationCard(
        template: i,
        interactionsController: interactionsController,
      ),
      FillInTheBlanksTemplate fb => FillInTheBlanksCard(
        template: fb,
        interactionsController: interactionsController,
      ),
      MatchMadnessTemplate mm => MatchingTypeCard(
        template: mm,
        interactionsController: interactionsController,
      ),
      WordScrambleTemplate ws => WordScrambleCard(
        template: ws,
        interactionsController: interactionsController,
      ),
      _ => Center(
        // Replace with error text
        child: Text(
          'Unsupported card type: ${template.runtimeType}',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    };

    return Center(child: child);
  }
}

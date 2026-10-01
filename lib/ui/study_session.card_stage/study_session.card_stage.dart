import 'package:boo_mondai/lib.barrel.dart'
    show
        StudySessionController,
        CardTemplateController,
        FlashcardTemplate,
        IdentificationTemplate,
        StudySessionCardStageController,
        CardTemplate,
        MultipleChoiceTemplate,
        FillInTheBlanksTemplate,
        MatchingTypeTemplate,
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
    required this.cardStageController,
    super.key,
  });

  final StudySessionController studySessionController;
  final StudySessionCardStageController<CardTemplateController>
  cardStageController;

  // Temporary helper
  static bool isImplemented(CardTemplate template) {
    return template is FlashcardTemplate ||
        template is MultipleChoiceTemplate ||
        template is IdentificationTemplate ||
        template is FillInTheBlanksTemplate ||
        template is MatchingTypeTemplate ||
        template is WordScrambleTemplate;
  }

  @override
  Widget build(BuildContext context) {
    final template = studySessionController.currentTemplate.value;
    final studyCard = studySessionController.currentStudyCard.value;

    if (template == null || studyCard == null) {
      return const Center(child: Text('No card available'));
    }

    final child = switch (template) {
      FlashcardTemplate f => FlashcardCard(
        template: f,
        studyCard: studyCard,
        cardStageController: cardStageController,
      ),
      MultipleChoiceTemplate m => MultipleChoiceCard(
        template: m,
        cardStageController: cardStageController,
      ),
      IdentificationTemplate i => IdentificationCard(
        template: i,
        cardStageController: cardStageController,
      ),
      FillInTheBlanksTemplate fb => FillInTheBlanksCard(
        template: fb,
        cardStageController: cardStageController,
      ),
      MatchingTypeTemplate mm => MatchingTypeCard(
        template: mm,
        cardStageController: cardStageController,
      ),
      WordScrambleTemplate ws => WordScrambleCard(
        template: ws,
        cardStageController: cardStageController,
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

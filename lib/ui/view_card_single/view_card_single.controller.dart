import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        CardTemplateController,
        FlashcardTemplate,
        LocalDB,
        StudyCard,
        StudySessionCardStageController,
        WordScrambleController,
        WordScrambleTemplate;
import 'package:signals/signals_flutter.dart';

final class ViewCardSingleController {
  ViewCardSingleController({
    required this.templateId,
    CardTemplate? initialTemplate,
  }) {
    load(initialTemplate: initialTemplate);
  }

  final String templateId;
  final template = signal<CardTemplate?>(null);
  final error = signal<Exception?>(null);
  final cardStageController =
      signal<StudySessionCardStageController<CardTemplateController>?>(null);

  late final isRevealed = computed(
    () => cardStageController.value?.isRevealed.value ?? false,
  );

  late final previewStudyCard = computed<StudyCard?>(() {
    final current = template.value;
    if (current == null) return null;

    final now = DateTime.now();
    return StudyCard(
      id: '__view_card_single_preview__${current.id}',
      createdAt: now,
      updatedAt: now,
      templateId: current.id,
      deckId: current.deckId,
      isReversed: false,
    );
  });

  void load({CardTemplate? initialTemplate}) {
    try {
      final nextTemplate =
          initialTemplate ??
          LocalDB.cardTemplate.selectByPk({'id': templateId});
      if (nextTemplate == null) {
        throw Exception('Card template was not found.');
      }

      final previousController = cardStageController.value;
      template.value = nextTemplate;
      cardStageController.value = _createCardStageController(nextTemplate);
      previousController?.dispose();
      error.value = null;
    } on Exception catch (cause) {
      error.value = cause;
    }
  }

  void toggleReveal() {
    final stage = cardStageController.value;
    if (stage == null) return;

    stage
      ..canReveal.value = true
      ..pendingRating.value = null
      ..isRevealed.value = !stage.isRevealed.value;
  }

  StudySessionCardStageController<CardTemplateController>
  _createCardStageController(CardTemplate template) {
    return StudySessionCardStageController<CardTemplateController>(
      template: template,
      canReveal: true,
      createCardController: template is WordScrambleTemplate
          ? (stage) => WordScrambleController(
              template: template,
              answer: stage.answer,
              canReveal: stage.canReveal,
              isRevealed: stage.isRevealed,
            )
          : null,
    );
  }

  void dispose() {
    cardStageController.value?.dispose();
    cardStageController.dispose();
    previewStudyCard.dispose();
    isRevealed.dispose();
    error.dispose();
    template.dispose();
  }
}

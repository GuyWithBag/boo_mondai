import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        CardTemplateDirection,
        CardTemplateType,
        FillInTheBlanksTemplate,
        FlashcardTemplate,
        IdentificationTemplate,
        MatchingTypeValue,
        MatchingTypeTemplate,
        MultipleChoiceTemplate,
        WordScrambleTemplate,
        defaultMultipleChoiceOptions,
        Vector2Hive,
        uuid;

abstract final class CardTemplatesService {
  static CardTemplateType typeFor(CardTemplate template) {
    return switch (template) {
      FlashcardTemplate _ => CardTemplateType.flashcard,
      IdentificationTemplate _ => CardTemplateType.identification,
      MultipleChoiceTemplate _ => CardTemplateType.multipleChoice,
      FillInTheBlanksTemplate _ => CardTemplateType.fillInTheBlanks,
      WordScrambleTemplate _ => CardTemplateType.wordScramble,
      MatchingTypeTemplate _ => CardTemplateType.matchMadness,
      _ => CardTemplateType.flashcard,
    };
  }

  static CardTemplate create({
    required CardTemplateType type,
    required String deckId,
    required int sortOrder,
    String? id,
    DateTime? createdAt,
    String? sourceTemplateId,
  }) {
    final now = DateTime.now();
    final templateId = id ?? uuid.v7();
    final created = createdAt ?? now;

    return switch (type) {
      CardTemplateType.flashcard => FlashcardTemplate(
        id: templateId,
        deckId: deckId,
        sortOrder: sortOrder,
        createdAt: created,
        updatedAt: now,
        sourceTemplateId: sourceTemplateId,
        frontText: '',
        backText: '',
        direction: CardTemplateDirection.normal,
      ),
      CardTemplateType.identification => IdentificationTemplate(
        id: templateId,
        deckId: deckId,
        sortOrder: sortOrder,
        createdAt: created,
        updatedAt: now,
        sourceTemplateId: sourceTemplateId,
        promptText: '',
        answers: const [],
      ),
      CardTemplateType.multipleChoice => MultipleChoiceTemplate(
        id: templateId,
        deckId: deckId,
        sortOrder: sortOrder,
        createdAt: created,
        updatedAt: now,
        sourceTemplateId: sourceTemplateId,
        questionPrompt: '',
        options: defaultMultipleChoiceOptions(templateId),
      ),
      CardTemplateType.fillInTheBlanks => FillInTheBlanksTemplate(
        id: templateId,
        deckId: deckId,
        sortOrder: sortOrder,
        createdAt: created,
        updatedAt: now,
        sourceTemplateId: sourceTemplateId,
        promptText: '',
        answerKeys: const [],
      ),
      CardTemplateType.wordScramble => WordScrambleTemplate(
        id: templateId,
        deckId: deckId,
        sortOrder: sortOrder,
        createdAt: created,
        updatedAt: now,
        sourceTemplateId: sourceTemplateId,
        sentenceToScramble: '',
      ),
      CardTemplateType.matchMadness => MatchingTypeTemplate(
        id: templateId,
        deckId: deckId,
        sortOrder: sortOrder,
        createdAt: created,
        updatedAt: now,
        sourceTemplateId: sourceTemplateId,
        values: [
          MatchingTypeValue(
            text: '',
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: '',
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
        ],
      ),
    };
  }
}

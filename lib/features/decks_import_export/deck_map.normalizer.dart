import 'package:boo_mondai/lib.barrel.dart'
    show
        DeckImportResult,
        uuid,
        Deck,
        MapHelper,
        FlashcardTemplate,
        WordScrambleTemplate,
        IdentificationTemplate,
        IdentificationAnswer,
        MultipleChoiceTemplate,
        MultipleChoiceOption,
        FillInTheBlanksTemplate,
        FillInTheBlankSegment,
        MatchMadnessTemplate,
        MatchMadnessPair;

abstract class DeckMapNormalizer {
  static DeckImportResult flattenDeckMap(Map<String, dynamic> imported) {
    MapHelper.requireKeysOrThrowException(imported, const {'title'});

    final deckId = uuid.v7();
    final now = DateTime.now();
    final deck = MapHelper.normalizeWithBaseMap(
      base: Deck.createDummy(id: deckId).toMap(),
      imported: imported,
      injectValues: {'id': deckId, 'created_at': now, 'updated_at': now},
      removeKeys: const {'templates'},
      requiredKeys: const {'title'},
    );
    final templateValues = imported['templates'];
    if (templateValues is! List) {
      throw const FormatException('Deck import must include templates.');
    }

    var output = DeckImportResult(decks: [deck]);
    for (final entry in templateValues.asMap().entries) {
      final value = entry.value;
      if (value is! Map<dynamic, dynamic>) {
        throw const FormatException(
          'Deck templates must only contain objects.',
        );
      }

      output = output.merge(
        flattenCardTemplateMap(
          MapHelper.normalizeKeysToString(value),
          deckId: deckId,
          sortOrder: entry.key,
        ),
      );
    }

    return output;
  }

  static DeckImportResult flattenCardTemplateMap(
    Map<String, dynamic> imported, {
    required String deckId,
    required int sortOrder,
  }) {
    final type = imported['type']?.toString().toLowerCase();
    if (type == null || type.isEmpty) {
      throw const FormatException('Card template import must include type.');
    }

    final templateId = uuid.v7();
    final now = DateTime.now();
    final injectValues = {
      'id': templateId,
      'deck_id': deckId,
      'sort_order': sortOrder,
      'created_at': now,
      'updated_at': now,
    };

    return switch (type) {
      'flashcard' => DeckImportResult(
        cardTemplates: [
          MapHelper.normalizeWithBaseMap(
            base: FlashcardTemplate.createDummy(id: templateId).toMap(),
            imported: imported,
            injectValues: injectValues,
            requiredKeys: const {'type', 'front_text', 'back_text'},
          ),
        ],
      ),
      'identification' => _flattenIdentificationTemplate(
        imported,
        templateId: templateId,
        injectValues: injectValues,
      ),
      'multiple_choice' => _flattenMultipleChoiceTemplate(
        imported,
        templateId: templateId,
        injectValues: injectValues,
      ),
      'fill_in_the_blanks' => _flattenFillInTheBlanksTemplate(
        imported,
        templateId: templateId,
        injectValues: injectValues,
      ),
      'match_madness' => _flattenMatchMadnessTemplate(
        imported,
        templateId: templateId,
        injectValues: injectValues,
      ),
      'word_scramble' => DeckImportResult(
        cardTemplates: [
          MapHelper.normalizeWithBaseMap(
            base: WordScrambleTemplate.createDummy(id: templateId).toMap(),
            imported: imported,
            injectValues: injectValues,
            requiredKeys: const {'type', 'sentence_to_scramble'},
          ),
        ],
      ),
      _ => throw FormatException('Unsupported card template type: $type'),
    };
  }

  static DeckImportResult _flattenIdentificationTemplate(
    Map<String, dynamic> imported, {
    required String templateId,
    required Map<String, dynamic> injectValues,
  }) {
    final answers = MapHelper.requireNestedMaps(
      imported,
      'accepted_answers',
      'Identification template accepted_answers',
    );
    return DeckImportResult(
      cardTemplates: [
        MapHelper.normalizeWithBaseMap(
          base: IdentificationTemplate.createDummy(id: templateId).toMap(),
          imported: imported,
          injectValues: injectValues,
          removeKeys: const {'accepted_answers'},
          requiredKeys: const {'type', 'prompt_text', 'accepted_answers'},
        ),
      ],
      identificationAnswers: [
        for (final entry in answers.asMap().entries)
          MapHelper.normalizeWithBaseMap(
            base: IdentificationAnswer.createDummy(
              templateId: templateId,
            ).toMap(),
            imported: entry.value,
            injectValues: {
              'id': uuid.v7(),
              'template_id': templateId,
              'display_order': entry.key,
            },
            requiredKeys: const {'answer'},
          ),
      ],
    );
  }

  static DeckImportResult _flattenMultipleChoiceTemplate(
    Map<String, dynamic> imported, {
    required String templateId,
    required Map<String, dynamic> injectValues,
  }) {
    final options = MapHelper.requireNestedMaps(
      imported,
      'options',
      'Multiple choice template options',
    );
    return DeckImportResult(
      cardTemplates: [
        MapHelper.normalizeWithBaseMap(
          base: MultipleChoiceTemplate.createDummy(id: templateId).toMap(),
          imported: imported,
          injectValues: injectValues,
          removeKeys: const {'options'},
          requiredKeys: const {'type', 'question_prompt', 'options'},
        ),
      ],
      multipleChoiceOptions: [
        for (final entry in options.asMap().entries)
          MapHelper.normalizeWithBaseMap(
            base: MultipleChoiceOption.createDummy(
              templateId: templateId,
            ).toMap(),
            imported: entry.value,
            injectValues: {
              'id': uuid.v7(),
              'template_id': templateId,
              'display_order': entry.key,
            },
            requiredKeys: const {'option_text', 'is_correct'},
          ),
      ],
    );
  }

  static DeckImportResult _flattenFillInTheBlanksTemplate(
    Map<String, dynamic> imported, {
    required String templateId,
    required Map<String, dynamic> injectValues,
  }) {
    final segments = MapHelper.requireNestedMaps(
      imported,
      'segments',
      'Fill in the blanks template segments',
    );
    return DeckImportResult(
      cardTemplates: [
        MapHelper.normalizeWithBaseMap(
          base: FillInTheBlanksTemplate.createDummy(id: templateId).toMap(),
          imported: imported,
          injectValues: injectValues,
          removeKeys: const {'segments'},
          requiredKeys: const {'type', 'segments'},
        ),
      ],
      fillInTheBlankSegments: [
        for (final segment in segments)
          MapHelper.normalizeWithBaseMap(
            base: FillInTheBlankSegment.createDummy(cardId: templateId).toMap(),
            imported: segment,
            injectValues: {'id': uuid.v7(), 'card_id': templateId},
            requiredKeys: const {
              'full_text',
              'blank_start',
              'blank_end',
              'correct_answer',
            },
          ),
      ],
    );
  }

  static DeckImportResult _flattenMatchMadnessTemplate(
    Map<String, dynamic> imported, {
    required String templateId,
    required Map<String, dynamic> injectValues,
  }) {
    final pairs = MapHelper.requireNestedMaps(
      imported,
      'pairs',
      'Match madness template pairs',
    );
    return DeckImportResult(
      cardTemplates: [
        MapHelper.normalizeWithBaseMap(
          base: MatchMadnessTemplate.createDummy(id: templateId).toMap(),
          imported: imported,
          injectValues: injectValues,
          removeKeys: const {'pairs'},
          requiredKeys: const {'type', 'pairs'},
        ),
      ],
      matchMadnessPairs: [
        for (final entry in pairs.asMap().entries)
          MapHelper.normalizeWithBaseMap(
            base: MatchMadnessPair.createDummy(templateId: templateId).toMap(),
            imported: entry.value,
            injectValues: {
              'id': uuid.v7(),
              'template_id': templateId,
              'display_order': entry.key,
            },
            requiredKeys: const {'term', 'match'},
          ),
      ],
    );
  }
}

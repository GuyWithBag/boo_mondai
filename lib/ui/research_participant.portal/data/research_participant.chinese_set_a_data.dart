import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        CardTemplateDirection,
        CasingType,
        Deck,
        FillInTheBlankAnswerKey,
        FillInTheBlanksTemplate,
        FlashcardTemplate,
        IdentificationAnswerKey,
        IdentificationTemplate,
        LocalDB,
        MatchingTypeTemplate,
        MatchingTypeValue,
        MultipleChoiceOption,
        MultipleChoiceTemplate,
        Profile,
        ResearchParticipantData,
        StudyCardService,
        Vector2Hive,
        WordScrambleTemplate;

class ResearchParticipantChineseSetAData extends ResearchParticipantData {
  static const idPrefix = 'research_participant_chinese_set_a_';
  static const dataDeckId = '${idPrefix}data_deck';
  static const attachmentAssetDirectory =
      'assets/temporary/chinese_set_a_attachments/';
  static const matchingTypeTemplateId = '${idPrefix}matching_type_template';
  static const flashcardTemplateId = '${idPrefix}flashcard_template';
  static const wordScrambleTemplateId = '${idPrefix}word_scramble_template';
  static const identificationTemplateId = '${idPrefix}identification_template';
  static const fillInTheBlanksTemplateId =
      '${idPrefix}fill_in_the_blanks_template';
  static const multipleChoiceTemplateId = '${idPrefix}multiple_choice_template';

  @override
  String get participantDeckId => dataDeckId;

  @override
  Future<void> initialize(Profile profile) async {
    final now = DateTime.now();
    final deck = Deck(
      id: dataDeckId,
      createdAt: now,
      updatedAt: now,
      profileId: profile.id,
      title: 'Chinese Set A',
      isPremade: true,
      isEditable: false,
    );

    final templates = <CardTemplate>[
      MatchingTypeTemplate(
        id: matchingTypeTemplateId,
        deckId: dataDeckId,
        sortOrder: 0,
        createdAt: now,
        updatedAt: now,
        values: const [
          MatchingTypeValue(
            text: 'bonjour',
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: 'hello',
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: 'merci',
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: 'thank you',
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: 'eau',
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: 'water',
            position: Vector2Hive(1, 2),
            matchPosition: Vector2Hive(0, 2),
          ),
        ],
      ),
      FlashcardTemplate(
        id: flashcardTemplateId,
        deckId: dataDeckId,
        sortOrder: 1,
        createdAt: now,
        updatedAt: now,
        frontText:
            'bonjour ![Person](person.webp) ![sound](button_pressed.wav)',
        backText: 'hello',
        direction: CardTemplateDirection.normal,
      ),
      WordScrambleTemplate(
        id: wordScrambleTemplateId,
        deckId: dataDeckId,
        sortOrder: 2,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: 'Je parle francais',
      ),
      IdentificationTemplate(
        id: identificationTemplateId,
        deckId: dataDeckId,
        sortOrder: 3,
        createdAt: now,
        updatedAt: now,
        promptText: 'Translate: hello',
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_0',
            templateId: identificationTemplateId,
            displayOrder: 0,
            value: 'bonjour',
            casingType: CasingType.any,
          ),
        ],
      ),
      FillInTheBlanksTemplate(
        id: fillInTheBlanksTemplateId,
        deckId: dataDeckId,
        sortOrder: 4,
        createdAt: now,
        updatedAt: now,
        promptText: 'Je parle francais.',
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: 'francais',
            casingType: CasingType.any,
            order: 0,
          ),
        ],
      ),
      MultipleChoiceTemplate(
        id: multipleChoiceTemplateId,
        deckId: dataDeckId,
        sortOrder: 5,
        createdAt: now,
        updatedAt: now,
        questionPrompt: 'Which word means hello?',
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_0',
            templateId: multipleChoiceTemplateId,
            optionText: 'bonjour',
            isCorrect: true,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_1',
            templateId: multipleChoiceTemplateId,
            optionText: 'fromage',
            isCorrect: false,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_2',
            templateId: multipleChoiceTemplateId,
            optionText: 'rouge',
            isCorrect: false,
            displayOrder: 2,
          ),
        ],
      ),
    ];

    await LocalDB.deck.upsert(deck);
    await LocalDB.cardTemplate.upsertMany(templates);
    await StudyCardService.syncDeckStudyCards(
      deckId: deck.id,
      templates: templates,
    );
    await copyAttachmentAssets(
      assetDirectory: attachmentAssetDirectory,
      deckTitle: deck.title,
    );
  }
}

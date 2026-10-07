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

class ResearchParticipantJapaneseSetAData extends ResearchParticipantData {
  static const idPrefix = 'research_participant_japanese_set_a_';
  static const dataDeckId = '${idPrefix}data_deck';
  static const attachmentAssetDirectory =
      'assets/temporary/japanese_set_a_attachments/';

  static const multipleChoiceQuestions = [
    (
      questionPrompt: 'What does みんなさん [Minnasan] mean?',
      options: [
        (optionText: 'you', isCorrect: false),
        (optionText: 'that person', isCorrect: false),
        (optionText: 'everyone', isCorrect: true),
        (optionText: 'us', isCorrect: false),
      ],
    ),
    (
      questionPrompt: 'What does ほん [hon] mean?',
      options: [
        (optionText: 'book', isCorrect: true),
        (optionText: 'magazine', isCorrect: false),
        (optionText: 'notebook', isCorrect: false),
        (optionText: 'newspaper', isCorrect: false),
      ],
    ),
    (
      questionPrompt: 'What does ここ [koko] mean?',
      options: [
        (optionText: 'there', isCorrect: false),
        (optionText: 'here', isCorrect: true),
        (optionText: 'where', isCorrect: false),
        (optionText: 'over there', isCorrect: false),
      ],
    ),
    (
      questionPrompt: 'What does いま [ima] mean?',
      options: [
        (optionText: 'today', isCorrect: false),
        (optionText: 'now', isCorrect: true),
        (optionText: 'tomorrow', isCorrect: false),
        (optionText: 'yesterday', isCorrect: false),
      ],
    ),
    (
      questionPrompt: 'What does いきます [ikimasu] mean?',
      options: [
        (optionText: 'return', isCorrect: false),
        (optionText: 'come', isCorrect: false),
        (optionText: 'go', isCorrect: true),
        (optionText: 'eat', isCorrect: false),
      ],
    ),
  ];

  static const identificationQuestions = [
    (promptText: 'What does みず [mizu] mean?', answer: 'water'),
    (promptText: 'What does あげます [agemasu] mean?', answer: 'give'),
    (promptText: 'What does おおきい [ookii] mean?', answer: 'big'),
    (promptText: 'What does わかります [wakarimasu] mean?', answer: 'understand'),
    (promptText: 'What does いぬ [inu] mean?', answer: 'dog'),
  ];

  static const flashcards = [
    (frontText: 'かさ', backText: 'umbrella'),
    (frontText: 'すし ![food](food.mp3)', backText: 'sushi'),
    (frontText: 'さとう', backText: 'sugar'),
    (frontText: 'りんご', backText: 'apple'),
    (frontText: 'ねこ', backText: 'cat'),
  ];

  static const matchingValueGroups = [
    [
      MatchingTypeValue(
        text: 'じてんしゃ',
        position: Vector2Hive(0, 0),
        matchPosition: Vector2Hive(1, 0),
      ),
      MatchingTypeValue(
        text: 'bicycle',
        position: Vector2Hive(1, 0),
        matchPosition: Vector2Hive(0, 0),
      ),
      MatchingTypeValue(
        text: 'いす',
        position: Vector2Hive(0, 1),
        matchPosition: Vector2Hive(1, 1),
      ),
      MatchingTypeValue(
        text: 'chair',
        position: Vector2Hive(1, 1),
        matchPosition: Vector2Hive(0, 1),
      ),
      MatchingTypeValue(
        text: 'とけい',
        position: Vector2Hive(0, 2),
        matchPosition: Vector2Hive(1, 2),
      ),
      MatchingTypeValue(
        text: 'clock',
        position: Vector2Hive(1, 2),
        matchPosition: Vector2Hive(0, 2),
      ),
    ],
    [
      MatchingTypeValue(
        text: 'いす',
        position: Vector2Hive(0, 0),
        matchPosition: Vector2Hive(1, 0),
      ),
      MatchingTypeValue(
        text: 'chair',
        position: Vector2Hive(1, 0),
        matchPosition: Vector2Hive(0, 0),
      ),
      MatchingTypeValue(
        text: 'とけい',
        position: Vector2Hive(0, 1),
        matchPosition: Vector2Hive(1, 1),
      ),
      MatchingTypeValue(
        text: 'clock',
        position: Vector2Hive(1, 1),
        matchPosition: Vector2Hive(0, 1),
      ),
      MatchingTypeValue(
        text: 'かばん',
        position: Vector2Hive(0, 2),
        matchPosition: Vector2Hive(1, 2),
      ),
      MatchingTypeValue(
        text: 'bag',
        position: Vector2Hive(1, 2),
        matchPosition: Vector2Hive(0, 2),
      ),
    ],
    [
      MatchingTypeValue(
        text: 'とけい',
        position: Vector2Hive(0, 0),
        matchPosition: Vector2Hive(1, 0),
      ),
      MatchingTypeValue(
        text: 'clock',
        position: Vector2Hive(1, 0),
        matchPosition: Vector2Hive(0, 0),
      ),
      MatchingTypeValue(
        text: 'かばん',
        position: Vector2Hive(0, 1),
        matchPosition: Vector2Hive(1, 1),
      ),
      MatchingTypeValue(
        text: 'bag',
        position: Vector2Hive(1, 1),
        matchPosition: Vector2Hive(0, 1),
      ),
      MatchingTypeValue(
        text: 'えんぴつ',
        position: Vector2Hive(0, 2),
        matchPosition: Vector2Hive(1, 2),
      ),
      MatchingTypeValue(
        text: 'pencil',
        position: Vector2Hive(1, 2),
        matchPosition: Vector2Hive(0, 2),
      ),
    ],
    [
      MatchingTypeValue(
        text: 'かばん',
        position: Vector2Hive(0, 0),
        matchPosition: Vector2Hive(1, 0),
      ),
      MatchingTypeValue(
        text: 'bag',
        position: Vector2Hive(1, 0),
        matchPosition: Vector2Hive(0, 0),
      ),
      MatchingTypeValue(
        text: 'えんぴつ',
        position: Vector2Hive(0, 1),
        matchPosition: Vector2Hive(1, 1),
      ),
      MatchingTypeValue(
        text: 'pencil',
        position: Vector2Hive(1, 1),
        matchPosition: Vector2Hive(0, 1),
      ),
      MatchingTypeValue(
        text: 'みんなさん [Minnasan]',
        position: Vector2Hive(0, 2),
        matchPosition: Vector2Hive(1, 2),
      ),
      MatchingTypeValue(
        text: 'everyone',
        position: Vector2Hive(1, 2),
        matchPosition: Vector2Hive(0, 2),
      ),
    ],
    [
      MatchingTypeValue(
        text: 'えんぴつ',
        position: Vector2Hive(0, 0),
        matchPosition: Vector2Hive(1, 0),
      ),
      MatchingTypeValue(
        text: 'pencil',
        position: Vector2Hive(1, 0),
        matchPosition: Vector2Hive(0, 0),
      ),
      MatchingTypeValue(
        text: 'みんなさん [Minnasan]',
        position: Vector2Hive(0, 1),
        matchPosition: Vector2Hive(1, 1),
      ),
      MatchingTypeValue(
        text: 'everyone',
        position: Vector2Hive(1, 1),
        matchPosition: Vector2Hive(0, 1),
      ),
      MatchingTypeValue(
        text: 'ほん [hon]',
        position: Vector2Hive(0, 2),
        matchPosition: Vector2Hive(1, 2),
      ),
      MatchingTypeValue(
        text: 'book',
        position: Vector2Hive(1, 2),
        matchPosition: Vector2Hive(0, 2),
      ),
    ],
  ];

  static const fillInTheBlanksQuestions = [
    (
      promptText: 'Watashi wa ____ ni norimasu.\nMeaning: I ride in a car.',
      answer: 'kuruma',
    ),
    (
      promptText: 'Kore wa ____ desu.\nMeaning: This is a telephone.',
      answer: 'denwa',
    ),
    (
      promptText: 'Watashi wa ____ o yomimasu.\nMeaning: I read a newspaper.',
      answer: 'shinbun',
    ),
    (
      promptText: 'Watashi wa ____ e ikimasu.\nMeaning: I go to school.',
      answer: 'gakkou',
    ),
    (
      promptText: 'Kore wa ____ desu.\nMeaning: This is food.',
      answer: 'tabemono',
    ),
  ];

  static const wordScrambleSentences = [
    'Kore wa nomimono desu',
    'Watashi wa kutsu o hakimasu',
    'Tori wa sora o tobimasu',
    'Watashi wa sakana o tabemasu',
    'Watashi wa densha ni norimasu',
  ];

  @override
  String get participantDeckId => dataDeckId;

  @override
  Future<void> initialize(Profile profile) async {
    const multipleChoiceOffset = 0;
    const identificationOffset = 5;
    const flashcardOffset = 10;
    const matchingTypeOffset = 15;
    const fillInTheBlanksOffset = 20;
    const wordScrambleOffset = 25;

    final now = DateTime.now();
    final deck = Deck(
      id: dataDeckId,
      createdAt: now,
      updatedAt: now,
      profileId: profile.id,
      title: 'Japanese Set A',
      isPremade: true,
      isEditable: false,
    );

    final templates = <CardTemplate>[
      for (final entry in multipleChoiceQuestions.indexed)
        MultipleChoiceTemplate(
          id: multipleChoiceTemplateId(entry.$1),
          deckId: dataDeckId,
          sortOrder: multipleChoiceOffset + entry.$1,
          createdAt: now,
          updatedAt: now,
          questionPrompt: entry.$2.questionPrompt,
          options: [
            for (final optionEntry in entry.$2.options.indexed)
              MultipleChoiceOption(
                id: multipleChoiceOptionId(entry.$1, optionEntry.$1),
                templateId: multipleChoiceTemplateId(entry.$1),
                optionText: optionEntry.$2.optionText,
                isCorrect: optionEntry.$2.isCorrect,
                displayOrder: optionEntry.$1,
              ),
          ],
        ),
      for (final entry in identificationQuestions.indexed)
        IdentificationTemplate(
          id: identificationTemplateId(entry.$1),
          deckId: dataDeckId,
          sortOrder: identificationOffset + entry.$1,
          createdAt: now,
          updatedAt: now,
          promptText: entry.$2.promptText,
          answers: [
            IdentificationAnswerKey(
              id: identificationAnswerId(entry.$1),
              templateId: identificationTemplateId(entry.$1),
              displayOrder: 0,
              value: entry.$2.answer,
              casingType: CasingType.any,
            ),
          ],
        ),
      for (final entry in flashcards.indexed)
        FlashcardTemplate(
          id: flashcardTemplateId(entry.$1),
          deckId: dataDeckId,
          sortOrder: flashcardOffset + entry.$1,
          createdAt: now,
          updatedAt: now,
          frontText: entry.$2.frontText,
          backText: entry.$2.backText,
          direction: CardTemplateDirection.both,
        ),
      for (final entry in matchingValueGroups.indexed)
        MatchingTypeTemplate(
          id: matchingTypeTemplateId(entry.$1),
          deckId: dataDeckId,
          sortOrder: matchingTypeOffset + entry.$1,
          createdAt: now,
          updatedAt: now,
          values: entry.$2,
        ),
      for (final entry in fillInTheBlanksQuestions.indexed)
        FillInTheBlanksTemplate(
          id: fillInTheBlanksTemplateId(entry.$1),
          deckId: dataDeckId,
          sortOrder: fillInTheBlanksOffset + entry.$1,
          createdAt: now,
          updatedAt: now,
          promptText: entry.$2.promptText,
          answerKeys: [
            FillInTheBlankAnswerKey(
              value: entry.$2.answer,
              casingType: CasingType.any,
              order: 0,
            ),
          ],
        ),
      for (final entry in wordScrambleSentences.indexed)
        WordScrambleTemplate(
          id: wordScrambleTemplateId(entry.$1),
          deckId: dataDeckId,
          sortOrder: wordScrambleOffset + entry.$1,
          createdAt: now,
          updatedAt: now,
          sentenceToScramble: entry.$2,
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

  static String multipleChoiceTemplateId(int index) {
    return '${idPrefix}multiple_choice_template_$index';
  }

  static String multipleChoiceOptionId(int templateIndex, int optionIndex) {
    return '${idPrefix}multiple_choice_${templateIndex}_option_$optionIndex';
  }

  static String identificationTemplateId(int index) {
    return '${idPrefix}identification_template_$index';
  }

  static String identificationAnswerId(int index) {
    return '${idPrefix}identification_answer_$index';
  }

  static String flashcardTemplateId(int index) {
    return '${idPrefix}flashcard_template_$index';
  }

  static String matchingTypeTemplateId(int index) {
    return '${idPrefix}matching_type_template_$index';
  }

  static String fillInTheBlanksTemplateId(int index) {
    return '${idPrefix}fill_in_the_blanks_template_$index';
  }

  static String wordScrambleTemplateId(int index) {
    return '${idPrefix}word_scramble_template_$index';
  }
}

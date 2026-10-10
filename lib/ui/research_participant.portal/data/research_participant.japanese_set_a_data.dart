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
      title: "Japanese Set A",
      isPremade: true,
      isEditable: false,
    );

    final templates = <CardTemplate>[
      MultipleChoiceTemplate(
        id: '${idPrefix}template_0',
        deckId: dataDeckId,
        sortOrder: 0,
        createdAt: now,
        updatedAt: now,
        questionPrompt: "What does みんなさん [Minnasan] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_0_0',
            templateId: '${idPrefix}template_0',
            optionText: "you",
            isCorrect: false,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_0_1',
            templateId: '${idPrefix}template_0',
            optionText: "that person",
            isCorrect: false,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_0_2',
            templateId: '${idPrefix}template_0',
            optionText: "everyone",
            isCorrect: true,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_0_3',
            templateId: '${idPrefix}template_0',
            optionText: "us",
            isCorrect: false,
            displayOrder: 3,
          ),
        ],
      ),
      MultipleChoiceTemplate(
        id: '${idPrefix}template_1',
        deckId: dataDeckId,
        sortOrder: 1,
        createdAt: now,
        updatedAt: now,
        questionPrompt: "What does ほん [hon] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_1_0',
            templateId: '${idPrefix}template_1',
            optionText: "book",
            isCorrect: true,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_1_1',
            templateId: '${idPrefix}template_1',
            optionText: "magazine",
            isCorrect: false,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_1_2',
            templateId: '${idPrefix}template_1',
            optionText: "notebook",
            isCorrect: false,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_1_3',
            templateId: '${idPrefix}template_1',
            optionText: "newspaper",
            isCorrect: false,
            displayOrder: 3,
          ),
        ],
      ),
      MultipleChoiceTemplate(
        id: '${idPrefix}template_2',
        deckId: dataDeckId,
        sortOrder: 2,
        createdAt: now,
        updatedAt: now,
        questionPrompt: "What does ここ [koko] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_2_0',
            templateId: '${idPrefix}template_2',
            optionText: "there",
            isCorrect: false,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_2_1',
            templateId: '${idPrefix}template_2',
            optionText: "here",
            isCorrect: true,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_2_2',
            templateId: '${idPrefix}template_2',
            optionText: "where",
            isCorrect: false,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_2_3',
            templateId: '${idPrefix}template_2',
            optionText: "over there",
            isCorrect: false,
            displayOrder: 3,
          ),
        ],
      ),
      MultipleChoiceTemplate(
        id: '${idPrefix}template_3',
        deckId: dataDeckId,
        sortOrder: 3,
        createdAt: now,
        updatedAt: now,
        questionPrompt: "What does いま [ima] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_3_0',
            templateId: '${idPrefix}template_3',
            optionText: "today",
            isCorrect: false,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_3_1',
            templateId: '${idPrefix}template_3',
            optionText: "now",
            isCorrect: true,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_3_2',
            templateId: '${idPrefix}template_3',
            optionText: "tomorrow",
            isCorrect: false,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_3_3',
            templateId: '${idPrefix}template_3',
            optionText: "yesterday",
            isCorrect: false,
            displayOrder: 3,
          ),
        ],
      ),
      MultipleChoiceTemplate(
        id: '${idPrefix}template_4',
        deckId: dataDeckId,
        sortOrder: 4,
        createdAt: now,
        updatedAt: now,
        questionPrompt: "What does いきます [ikimasu] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_4_0',
            templateId: '${idPrefix}template_4',
            optionText: "return",
            isCorrect: false,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_4_1',
            templateId: '${idPrefix}template_4',
            optionText: "come",
            isCorrect: false,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_4_2',
            templateId: '${idPrefix}template_4',
            optionText: "go",
            isCorrect: true,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_4_3',
            templateId: '${idPrefix}template_4',
            optionText: "eat",
            isCorrect: false,
            displayOrder: 3,
          ),
        ],
      ),
      IdentificationTemplate(
        id: '${idPrefix}template_5',
        deckId: dataDeckId,
        sortOrder: 5,
        createdAt: now,
        updatedAt: now,
        promptText: "What does みず [mizu] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_5_0',
            templateId: '${idPrefix}template_5',
            displayOrder: 0,
            value: "water",
            casingType: CasingType.any,
          ),
        ],
      ),
      IdentificationTemplate(
        id: '${idPrefix}template_6',
        deckId: dataDeckId,
        sortOrder: 6,
        createdAt: now,
        updatedAt: now,
        promptText: "What does あげます [agemasu] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_6_0',
            templateId: '${idPrefix}template_6',
            displayOrder: 0,
            value: "give",
            casingType: CasingType.any,
          ),
        ],
      ),
      IdentificationTemplate(
        id: '${idPrefix}template_7',
        deckId: dataDeckId,
        sortOrder: 7,
        createdAt: now,
        updatedAt: now,
        promptText: "What does おおきい [ookii] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_7_0',
            templateId: '${idPrefix}template_7',
            displayOrder: 0,
            value: "big",
            casingType: CasingType.any,
          ),
        ],
      ),
      IdentificationTemplate(
        id: '${idPrefix}template_8',
        deckId: dataDeckId,
        sortOrder: 8,
        createdAt: now,
        updatedAt: now,
        promptText: "What does わかります [wakarimasu] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_8_0',
            templateId: '${idPrefix}template_8',
            displayOrder: 0,
            value: "understand",
            casingType: CasingType.any,
          ),
        ],
      ),
      IdentificationTemplate(
        id: '${idPrefix}template_9',
        deckId: dataDeckId,
        sortOrder: 9,
        createdAt: now,
        updatedAt: now,
        promptText: "What does いぬ [inu] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_9_0',
            templateId: '${idPrefix}template_9',
            displayOrder: 0,
            value: "dog",
            casingType: CasingType.any,
          ),
        ],
      ),
      FlashcardTemplate(
        id: '${idPrefix}template_10',
        deckId: dataDeckId,
        sortOrder: 10,
        createdAt: now,
        updatedAt: now,
        frontText: "![Image](umbrella.webp)",
        backText: "かさ\nkasa\numbrella",
        direction: CardTemplateDirection.normal,
      ),
      FlashcardTemplate(
        id: '${idPrefix}template_11',
        deckId: dataDeckId,
        sortOrder: 11,
        createdAt: now,
        updatedAt: now,
        frontText: "![Image](sushi.webp)",
        backText: "すし\nsushi\nsushi",
        direction: CardTemplateDirection.normal,
      ),
      FlashcardTemplate(
        id: '${idPrefix}template_12',
        deckId: dataDeckId,
        sortOrder: 12,
        createdAt: now,
        updatedAt: now,
        frontText: "![Image](sugar.webp)",
        backText: "さとう\nsatou\nsugar",
        direction: CardTemplateDirection.normal,
      ),
      FlashcardTemplate(
        id: '${idPrefix}template_13',
        deckId: dataDeckId,
        sortOrder: 13,
        createdAt: now,
        updatedAt: now,
        frontText: "![Image](apple.webp)",
        backText: "りんご\nringo\napple",
        direction: CardTemplateDirection.normal,
      ),
      FlashcardTemplate(
        id: '${idPrefix}template_14',
        deckId: dataDeckId,
        sortOrder: 14,
        createdAt: now,
        updatedAt: now,
        frontText: "![Image](cat.webp)",
        backText: "ねこ\nneko\ncat",
        direction: CardTemplateDirection.normal,
      ),
      MatchingTypeTemplate(
        id: '${idPrefix}template_15',
        deckId: dataDeckId,
        sortOrder: 15,
        createdAt: now,
        updatedAt: now,
        values: const [
          MatchingTypeValue(
            text: "![Image](bicycle.webp)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "じてんしゃ\njitensha\nbicycle",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "![Image](chair.webp)",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "いす\nisu\nchair",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "![Image](clock.webp)",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "とけい\ntokei\nclock",
            position: Vector2Hive(1, 2),
            matchPosition: Vector2Hive(0, 2),
          ),
        ],
      ),
      MatchingTypeTemplate(
        id: '${idPrefix}template_16',
        deckId: dataDeckId,
        sortOrder: 16,
        createdAt: now,
        updatedAt: now,
        values: const [
          MatchingTypeValue(
            text: "![Image](chair.webp)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "いす\nisu\nchair",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "![Image](clock.webp)",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "とけい\ntokei\nclock",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "![Image](bag.webp)",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "かばん\nkaban\nbag",
            position: Vector2Hive(1, 2),
            matchPosition: Vector2Hive(0, 2),
          ),
        ],
      ),
      MatchingTypeTemplate(
        id: '${idPrefix}template_17',
        deckId: dataDeckId,
        sortOrder: 17,
        createdAt: now,
        updatedAt: now,
        values: const [
          MatchingTypeValue(
            text: "![Image](clock.webp)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "とけい\ntokei\nclock",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "![Image](bag.webp)",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "かばん\nkaban\nbag",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "![Image](pencil.webp)",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "えんぴつ\nenpitsu\npencil",
            position: Vector2Hive(1, 2),
            matchPosition: Vector2Hive(0, 2),
          ),
        ],
      ),
      MatchingTypeTemplate(
        id: '${idPrefix}template_18',
        deckId: dataDeckId,
        sortOrder: 18,
        createdAt: now,
        updatedAt: now,
        values: const [
          MatchingTypeValue(
            text: "![Image](bag.webp)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "かばん\nkaban\nbag",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "![Image](pencil.webp)",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "えんぴつ\nenpitsu\npencil",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "みんなさん [Minnasan]",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "everyone",
            position: Vector2Hive(1, 2),
            matchPosition: Vector2Hive(0, 2),
          ),
        ],
      ),
      MatchingTypeTemplate(
        id: '${idPrefix}template_19',
        deckId: dataDeckId,
        sortOrder: 19,
        createdAt: now,
        updatedAt: now,
        values: const [
          MatchingTypeValue(
            text: "![Image](pencil.webp)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "えんぴつ\nenpitsu\npencil",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "みんなさん [Minnasan]",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "everyone",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "ほん [hon]",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "book",
            position: Vector2Hive(1, 2),
            matchPosition: Vector2Hive(0, 2),
          ),
        ],
      ),
      FillInTheBlanksTemplate(
        id: '${idPrefix}template_20',
        deckId: dataDeckId,
        sortOrder: 20,
        createdAt: now,
        updatedAt: now,
        promptText:
            "![Audio](car.mp3)\nWatashi wa kuruma ni norimasu.\nMeaning: I ride in a car.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "kuruma",
            casingType: CasingType.any,
            order: 0,
          ),
        ],
      ),
      FillInTheBlanksTemplate(
        id: '${idPrefix}template_21',
        deckId: dataDeckId,
        sortOrder: 21,
        createdAt: now,
        updatedAt: now,
        promptText:
            "![Audio](telephone.mp3)\nKore wa denwa desu.\nMeaning: This is a telephone.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "denwa",
            casingType: CasingType.any,
            order: 0,
          ),
        ],
      ),
      FillInTheBlanksTemplate(
        id: '${idPrefix}template_22',
        deckId: dataDeckId,
        sortOrder: 22,
        createdAt: now,
        updatedAt: now,
        promptText:
            "![Audio](newspaper.mp3)\nWatashi wa shinbun o yomimasu.\nMeaning: I read a newspaper.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "shinbun",
            casingType: CasingType.any,
            order: 0,
          ),
        ],
      ),
      FillInTheBlanksTemplate(
        id: '${idPrefix}template_23',
        deckId: dataDeckId,
        sortOrder: 23,
        createdAt: now,
        updatedAt: now,
        promptText:
            "![Audio](school.mp3)\nWatashi wa gakkou e ikimasu.\nMeaning: I go to school.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "gakkou",
            casingType: CasingType.any,
            order: 0,
          ),
        ],
      ),
      FillInTheBlanksTemplate(
        id: '${idPrefix}template_24',
        deckId: dataDeckId,
        sortOrder: 24,
        createdAt: now,
        updatedAt: now,
        promptText:
            "![Audio](food.mp3)\nKore wa tabemono desu.\nMeaning: This is food.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "tabemono",
            casingType: CasingType.any,
            order: 0,
          ),
        ],
      ),
      WordScrambleTemplate(
        id: '${idPrefix}template_25',
        deckId: dataDeckId,
        sortOrder: 25,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: "Kore wa nomimono desu",
      ),
      WordScrambleTemplate(
        id: '${idPrefix}template_26',
        deckId: dataDeckId,
        sortOrder: 26,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: "Watashi wa kutsu o hakimasu",
      ),
      WordScrambleTemplate(
        id: '${idPrefix}template_27',
        deckId: dataDeckId,
        sortOrder: 27,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: "Tori wa sora o tobimasu",
      ),
      WordScrambleTemplate(
        id: '${idPrefix}template_28',
        deckId: dataDeckId,
        sortOrder: 28,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: "Watashi wa sakana o tabemasu",
      ),
      WordScrambleTemplate(
        id: '${idPrefix}template_29',
        deckId: dataDeckId,
        sortOrder: 29,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: "Watashi wa densha ni norimasu",
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

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

class ResearchParticipantJapaneseSetBData extends ResearchParticipantData {
  static const idPrefix = 'research_participant_japanese_set_b_';
  static const dataDeckId = '${idPrefix}data_deck';
  static const attachmentAssetDirectory =
      'assets/temporary/japanese_set_b_attachments/';

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
      title: "Japanese Set B",
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
        questionPrompt: "What does あさ [asa] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_0_0',
            templateId: '${idPrefix}template_0',
            optionText: "Evening",
            isCorrect: false,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_0_1',
            templateId: '${idPrefix}template_0',
            optionText: "Morning",
            isCorrect: true,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_0_2',
            templateId: '${idPrefix}template_0',
            optionText: "Noon",
            isCorrect: false,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_0_3',
            templateId: '${idPrefix}template_0',
            optionText: "Night",
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
        questionPrompt: "What does ひる [hiru] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_1_0',
            templateId: '${idPrefix}template_1',
            optionText: "Morning",
            isCorrect: false,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_1_1',
            templateId: '${idPrefix}template_1',
            optionText: "Evening",
            isCorrect: false,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_1_2',
            templateId: '${idPrefix}template_1',
            optionText: "Noon",
            isCorrect: true,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_1_3',
            templateId: '${idPrefix}template_1',
            optionText: "Night",
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
        questionPrompt: "What does ばん [ban] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_2_0',
            templateId: '${idPrefix}template_2',
            optionText: "Morning",
            isCorrect: false,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_2_1',
            templateId: '${idPrefix}template_2',
            optionText: "Evening",
            isCorrect: true,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_2_2',
            templateId: '${idPrefix}template_2',
            optionText: "Noon",
            isCorrect: false,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_2_3',
            templateId: '${idPrefix}template_2',
            optionText: "Night",
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
        questionPrompt: "What does よる [yoru] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_3_0',
            templateId: '${idPrefix}template_3',
            optionText: "Morning",
            isCorrect: false,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_3_1',
            templateId: '${idPrefix}template_3',
            optionText: "Evening",
            isCorrect: false,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_3_2',
            templateId: '${idPrefix}template_3',
            optionText: "Today",
            isCorrect: false,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_3_3',
            templateId: '${idPrefix}template_3',
            optionText: "Night",
            isCorrect: true,
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
        questionPrompt: "What does きょう [kyou] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_4_0',
            templateId: '${idPrefix}template_4',
            optionText: "Today",
            isCorrect: true,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_4_1',
            templateId: '${idPrefix}template_4',
            optionText: "Tomorrow",
            isCorrect: false,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_4_2',
            templateId: '${idPrefix}template_4',
            optionText: "Yesterday",
            isCorrect: false,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_4_3',
            templateId: '${idPrefix}template_4',
            optionText: "Every day",
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
        promptText: "What does あした [ashita] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_5_0',
            templateId: '${idPrefix}template_5',
            displayOrder: 0,
            value: "Tomorrow",
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
        promptText: "What does きのう [kinou] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_6_0',
            templateId: '${idPrefix}template_6',
            displayOrder: 0,
            value: "Yesterday",
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
        promptText: "What does まいにち [mainichi] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_7_0',
            templateId: '${idPrefix}template_7',
            displayOrder: 0,
            value: "Every day",
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
        promptText: "What does まいあさ [maiasa] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_8_0',
            templateId: '${idPrefix}template_8',
            displayOrder: 0,
            value: "Every morning",
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
        promptText: "What does こんばん [konban] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_9_0',
            templateId: '${idPrefix}template_9',
            displayOrder: 0,
            value: "Tonight",
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
        frontText: "![Image](egg.webp)",
        backText: "たまご\ntamago\negg",
        direction: CardTemplateDirection.normal,
      ),
      FlashcardTemplate(
        id: '${idPrefix}template_11',
        deckId: dataDeckId,
        sortOrder: 11,
        createdAt: now,
        updatedAt: now,
        frontText: "![Image](bread.webp)",
        backText: "パン\npan\nbread",
        direction: CardTemplateDirection.normal,
      ),
      FlashcardTemplate(
        id: '${idPrefix}template_12',
        deckId: dataDeckId,
        sortOrder: 12,
        createdAt: now,
        updatedAt: now,
        frontText: "![Image](coffee.webp)",
        backText: "コーヒー\nkoohii\ncoffee",
        direction: CardTemplateDirection.normal,
      ),
      FlashcardTemplate(
        id: '${idPrefix}template_13',
        deckId: dataDeckId,
        sortOrder: 13,
        createdAt: now,
        updatedAt: now,
        frontText: "![Image](cake.webp)",
        backText: "ケーキ\nkeeki\ncake",
        direction: CardTemplateDirection.normal,
      ),
      FlashcardTemplate(
        id: '${idPrefix}template_14',
        deckId: dataDeckId,
        sortOrder: 14,
        createdAt: now,
        updatedAt: now,
        frontText: "![Image](camera.webp)",
        backText: "カメラ\nkamera\ncamera",
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
            text: "![Image](tv.webp)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "テレビ\nterebi\ntelevision",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "![Image](socks.webp)",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "くつした\nkutsushita\nsocks",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "![Image](glasses.webp)",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "めがね\nmegane\nglasses",
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
            text: "![Image](socks.webp)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "くつした\nkutsushita\nsocks",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "![Image](glasses.webp)",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "めがね\nmegane\nglasses",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "![Image](radio.webp)",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "ラジオ\nrajio\nradio",
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
            text: "![Image](glasses.webp)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "めがね\nmegane\nglasses",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "![Image](radio.webp)",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "ラジオ\nrajio\nradio",
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
            text: "![Image](radio.webp)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "ラジオ\nrajio\nradio",
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
            text: "あさ [asa]",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "Morning",
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
            text: "あさ [asa]",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "Morning",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "ひる [hiru]",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "Noon",
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
            "![Audio](buy.mp3)\nWatashi wa hon o kaimasu.\nMeaning: I buy a book.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "kaimasu",
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
            "![Audio](sell.mp3)\nWatashi wa hon o urimasu.\nMeaning: I sell a book.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "urimasu",
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
            "![Audio](mother.mp3)\nKono hito wa watashi no okaasan desu.\nMeaning: This person is my mother.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "okaasan",
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
            "![Audio](father.mp3)\nKono hito wa watashi no otousan desu.\nMeaning: This person is my father.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "otousan",
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
            "![Audio](big.mp3)\nKono inu wa ookii desu.\nMeaning: This dog is big.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "ookii",
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
        sentenceToScramble: "Kono inu wa chiisai desu",
      ),
      WordScrambleTemplate(
        id: '${idPrefix}template_26',
        deckId: dataDeckId,
        sortOrder: 26,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: "Kono heya wa shizuka desu",
      ),
      WordScrambleTemplate(
        id: '${idPrefix}template_27',
        deckId: dataDeckId,
        sortOrder: 27,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: "Kono machi wa nigiyaka desu",
      ),
      WordScrambleTemplate(
        id: '${idPrefix}template_28',
        deckId: dataDeckId,
        sortOrder: 28,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: "Kono mondai wa yasashii desu",
      ),
      WordScrambleTemplate(
        id: '${idPrefix}template_29',
        deckId: dataDeckId,
        sortOrder: 29,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: "Kono mondai wa muzukashii desu",
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

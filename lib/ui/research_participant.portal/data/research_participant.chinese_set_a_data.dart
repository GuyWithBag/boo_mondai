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
      title: "Chinese Set A",
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
        questionPrompt: "What does 你 [nǐ] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_0_0',
            templateId: '${idPrefix}template_0',
            optionText: "I",
            isCorrect: false,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_0_1',
            templateId: '${idPrefix}template_0',
            optionText: "You",
            isCorrect: true,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_0_2',
            templateId: '${idPrefix}template_0',
            optionText: "He",
            isCorrect: false,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_0_3',
            templateId: '${idPrefix}template_0',
            optionText: "She",
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
        questionPrompt: "What does 我 [wǒ] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_1_0',
            templateId: '${idPrefix}template_1',
            optionText: "I",
            isCorrect: true,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_1_1',
            templateId: '${idPrefix}template_1',
            optionText: "You",
            isCorrect: false,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_1_2',
            templateId: '${idPrefix}template_1',
            optionText: "He",
            isCorrect: false,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_1_3',
            templateId: '${idPrefix}template_1',
            optionText: "She",
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
        questionPrompt: "What does 他 [tā] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_2_0',
            templateId: '${idPrefix}template_2',
            optionText: "I",
            isCorrect: false,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_2_1',
            templateId: '${idPrefix}template_2',
            optionText: "You",
            isCorrect: false,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_2_2',
            templateId: '${idPrefix}template_2',
            optionText: "He",
            isCorrect: true,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_2_3',
            templateId: '${idPrefix}template_2',
            optionText: "She",
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
        questionPrompt: "What does 她 [tā] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_3_0',
            templateId: '${idPrefix}template_3',
            optionText: "I",
            isCorrect: false,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_3_1',
            templateId: '${idPrefix}template_3',
            optionText: "You",
            isCorrect: false,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_3_2',
            templateId: '${idPrefix}template_3',
            optionText: "He",
            isCorrect: false,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_3_3',
            templateId: '${idPrefix}template_3',
            optionText: "She",
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
        questionPrompt: "What does 好 [hǎo] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_4_0',
            templateId: '${idPrefix}template_4',
            optionText: "Good",
            isCorrect: true,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_4_1',
            templateId: '${idPrefix}template_4',
            optionText: "Bad",
            isCorrect: false,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_4_2',
            templateId: '${idPrefix}template_4',
            optionText: "Big",
            isCorrect: false,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_4_3',
            templateId: '${idPrefix}template_4',
            optionText: "Small",
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
        promptText: "What does 是 [shì] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_5_0',
            templateId: '${idPrefix}template_5',
            displayOrder: 0,
            value: "To be",
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
        promptText: "What does 不 [bù] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_6_0',
            templateId: '${idPrefix}template_6',
            displayOrder: 0,
            value: "No",
            casingType: CasingType.any,
          ),
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_6_1',
            templateId: '${idPrefix}template_6',
            displayOrder: 1,
            value: "Not",
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
        promptText: "What does 的 [de] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_7_0',
            templateId: '${idPrefix}template_7',
            displayOrder: 0,
            value: "Possessive particle ('s)",
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
        promptText: "What does 什么 [shénme] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_8_0',
            templateId: '${idPrefix}template_8',
            displayOrder: 0,
            value: "What",
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
        promptText: "What does 谁 [shéi] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_9_0',
            templateId: '${idPrefix}template_9',
            displayOrder: 0,
            value: "Who",
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
        frontText: "![Audio](father.mp3)",
        backText: "爸爸\nbàba\nFather",
        direction: CardTemplateDirection.normal,
      ),
      FlashcardTemplate(
        id: '${idPrefix}template_11',
        deckId: dataDeckId,
        sortOrder: 11,
        createdAt: now,
        updatedAt: now,
        frontText: "![Audio](mother.mp3)",
        backText: "妈妈\nmāma\nMother",
        direction: CardTemplateDirection.normal,
      ),
      FlashcardTemplate(
        id: '${idPrefix}template_12',
        deckId: dataDeckId,
        sortOrder: 12,
        createdAt: now,
        updatedAt: now,
        frontText: "![Audio](teacher.mp3)",
        backText: "老师\nlǎoshī\nTeacher",
        direction: CardTemplateDirection.normal,
      ),
      FlashcardTemplate(
        id: '${idPrefix}template_13',
        deckId: dataDeckId,
        sortOrder: 13,
        createdAt: now,
        updatedAt: now,
        frontText: "![Audio](student.mp3)",
        backText: "学生\nxuésheng\nStudent",
        direction: CardTemplateDirection.normal,
      ),
      FlashcardTemplate(
        id: '${idPrefix}template_14',
        deckId: dataDeckId,
        sortOrder: 14,
        createdAt: now,
        updatedAt: now,
        frontText: "![Audio](friend.mp3)",
        backText: "朋友\npéngyou\nFriend",
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
            text: "![Audio](cat.mp3)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "猫\nmāo\nCat",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "![Audio](dog.mp3)",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "狗\ngǒu\nDog",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "![Audio](book.mp3)",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "书\nshū\nBook",
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
            text: "![Audio](dog.mp3)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "狗\ngǒu\nDog",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "![Audio](book.mp3)",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "书\nshū\nBook",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "![Image](water.webp)",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "水\nshuǐ\nWater",
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
            text: "![Audio](book.mp3)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "书\nshū\nBook",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "![Image](water.webp)",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "水\nshuǐ\nWater",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "![Image](tea.webp)",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "茶\nchá\nTea",
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
            text: "![Image](water.webp)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "水\nshuǐ\nWater",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "![Image](tea.webp)",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "茶\nchá\nTea",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "你 [nǐ]",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "You",
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
            text: "![Image](tea.webp)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "茶\nchá\nTea",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "你 [nǐ]",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "You",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "我 [wǒ]",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "I",
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
        promptText: "![Image](eat.webp)\nWǒ chī mǐfàn.\nMeaning: I eat rice.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "chī",
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
            "![Image](drink.webp)\nWǒ hē shuǐ.\nMeaning: I drink water.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "hē",
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
            "![Image](look.webp)\nWǒ kàn diànyǐng.\nMeaning: I watch a movie.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "kàn",
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
            "![Image](go.webp)\nWǒ qù Běijīng.\nMeaning: I go to Beijing.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "qù",
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
            "![Image](come.webp)\nTā lái wǒ jiā.\nMeaning: He comes to my home.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "lái",
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
        sentenceToScramble: "Wǒ zuò zài yǐzi shàng",
      ),
      WordScrambleTemplate(
        id: '${idPrefix}template_26',
        deckId: dataDeckId,
        sortOrder: 26,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: "Jīntiān tiānqì hěn hǎo",
      ),
      WordScrambleTemplate(
        id: '${idPrefix}template_27',
        deckId: dataDeckId,
        sortOrder: 27,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: "Wǒ míngtiān qù Běijīng",
      ),
      WordScrambleTemplate(
        id: '${idPrefix}template_28',
        deckId: dataDeckId,
        sortOrder: 28,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: "Wǒ chī píngguǒ",
      ),
      WordScrambleTemplate(
        id: '${idPrefix}template_29',
        deckId: dataDeckId,
        sortOrder: 29,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: "Wǒ xǐhuan chī mǐfàn",
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

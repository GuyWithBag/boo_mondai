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

class ResearchParticipantChineseSetBData extends ResearchParticipantData {
  static const idPrefix = 'research_participant_chinese_set_b_';
  static const dataDeckId = '${idPrefix}data_deck';
  static const attachmentAssetDirectory =
      'assets/temporary/chinese_set_b_attachments/';

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
      title: "Chinese Set B",
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
        questionPrompt: "What does 谢谢 [xièxiè] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_0_0',
            templateId: '${idPrefix}template_0',
            optionText: "Please",
            isCorrect: false,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_0_1',
            templateId: '${idPrefix}template_0',
            optionText: "Thank you",
            isCorrect: true,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_0_2',
            templateId: '${idPrefix}template_0',
            optionText: "Sorry",
            isCorrect: false,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_0_3',
            templateId: '${idPrefix}template_0',
            optionText: "Goodbye",
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
        questionPrompt: "What does 再见 [zàijiàn] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_1_0',
            templateId: '${idPrefix}template_1',
            optionText: "Hello",
            isCorrect: false,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_1_1',
            templateId: '${idPrefix}template_1',
            optionText: "Thank you",
            isCorrect: false,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_1_2',
            templateId: '${idPrefix}template_1',
            optionText: "Sorry",
            isCorrect: false,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_1_3',
            templateId: '${idPrefix}template_1',
            optionText: "Goodbye",
            isCorrect: true,
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
        questionPrompt: "What does 请 [qǐng] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_2_0',
            templateId: '${idPrefix}template_2',
            optionText: "Please",
            isCorrect: true,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_2_1',
            templateId: '${idPrefix}template_2',
            optionText: "Thank you",
            isCorrect: false,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_2_2',
            templateId: '${idPrefix}template_2',
            optionText: "Sorry",
            isCorrect: false,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_2_3',
            templateId: '${idPrefix}template_2',
            optionText: "Goodbye",
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
        questionPrompt: "What does 有 [yǒu] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_3_0',
            templateId: '${idPrefix}template_3',
            optionText: "To have",
            isCorrect: true,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_3_1',
            templateId: '${idPrefix}template_3',
            optionText: "To be",
            isCorrect: false,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_3_2',
            templateId: '${idPrefix}template_3',
            optionText: "To want",
            isCorrect: false,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_3_3',
            templateId: '${idPrefix}template_3',
            optionText: "To like",
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
        questionPrompt: "What does 没有 [méiyǒu] mean?",
        options: const [
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_4_0',
            templateId: '${idPrefix}template_4',
            optionText: "To have",
            isCorrect: false,
            displayOrder: 0,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_4_1',
            templateId: '${idPrefix}template_4',
            optionText: "Don't have, there isn't",
            isCorrect: true,
            displayOrder: 1,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_4_2',
            templateId: '${idPrefix}template_4',
            optionText: "To want",
            isCorrect: false,
            displayOrder: 2,
          ),
          MultipleChoiceOption(
            id: '${idPrefix}multiple_choice_option_4_3',
            templateId: '${idPrefix}template_4',
            optionText: "To like",
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
        promptText: "What does 多少 [duōshao] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_5_0',
            templateId: '${idPrefix}template_5',
            displayOrder: 0,
            value: "How many",
            casingType: CasingType.any,
          ),
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_5_1',
            templateId: '${idPrefix}template_5',
            displayOrder: 1,
            value: "How much",
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
        promptText: "What does 怎么 [zěnme] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_6_0',
            templateId: '${idPrefix}template_6',
            displayOrder: 0,
            value: "How",
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
        promptText: "What does 现在 [xiànzài] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_7_0',
            templateId: '${idPrefix}template_7',
            displayOrder: 0,
            value: "Now",
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
        promptText: "What does 喜欢 [xǐhuan] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_8_0',
            templateId: '${idPrefix}template_8',
            displayOrder: 0,
            value: "To like",
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
        promptText: "What does 想 [xiǎng] mean?",
        answers: const [
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_9_0',
            templateId: '${idPrefix}template_9',
            displayOrder: 0,
            value: "To want",
            casingType: CasingType.any,
          ),
          IdentificationAnswerKey(
            id: '${idPrefix}identification_answer_9_1',
            templateId: '${idPrefix}template_9',
            displayOrder: 1,
            value: "Would like",
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
        frontText: "![Audio](classmate.mp3)",
        backText: "同学\ntóngxué\nClassmate",
        direction: CardTemplateDirection.both,
      ),
      FlashcardTemplate(
        id: '${idPrefix}template_11',
        deckId: dataDeckId,
        sortOrder: 11,
        createdAt: now,
        updatedAt: now,
        frontText: "![Audio](doctor.mp3)",
        backText: "医生\nyīshēng\nDoctor",
        direction: CardTemplateDirection.both,
      ),
      FlashcardTemplate(
        id: '${idPrefix}template_12',
        deckId: dataDeckId,
        sortOrder: 12,
        createdAt: now,
        updatedAt: now,
        frontText: "![Audio](sir.mp3)",
        backText: "先生\nxiānsheng\nMr., sir",
        direction: CardTemplateDirection.both,
      ),
      FlashcardTemplate(
        id: '${idPrefix}template_13',
        deckId: dataDeckId,
        sortOrder: 13,
        createdAt: now,
        updatedAt: now,
        frontText: "![Audio](miss.mp3)",
        backText: "小姐\nxiǎojiě\nMiss, young lady",
        direction: CardTemplateDirection.both,
      ),
      FlashcardTemplate(
        id: '${idPrefix}template_14',
        deckId: dataDeckId,
        sortOrder: 14,
        createdAt: now,
        updatedAt: now,
        frontText: "![Audio](son.mp3)",
        backText: "儿子\nérzi\nSon",
        direction: CardTemplateDirection.both,
      ),
      MatchingTypeTemplate(
        id: '${idPrefix}template_15',
        deckId: dataDeckId,
        sortOrder: 15,
        createdAt: now,
        updatedAt: now,
        values: const [
          MatchingTypeValue(
            text: "![Audio](daughter.mp3)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "女儿\nnǚ'ér\nDaughter",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "![Audio](name.mp3)",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "名字\nmíngzi\nName",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "![Audio](chinese.mp3)",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "汉语\nHànyǔ\nChinese (language)",
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
            text: "![Audio](name.mp3)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "名字\nmíngzi\nName",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "![Audio](chinese.mp3)",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "汉语\nHànyǔ\nChinese (language)",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "![Audio](china.mp3)",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "中国\nZhōngguó\nChina",
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
            text: "![Audio](chinese.mp3)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "汉语\nHànyǔ\nChinese (language)",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "![Audio](china.mp3)",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "中国\nZhōngguó\nChina",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "![Audio](beijing.mp3)",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "北京\nBěijīng\nBeijing",
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
            text: "![Audio](china.mp3)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "中国\nZhōngguó\nChina",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "![Audio](beijing.mp3)",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "北京\nBěijīng\nBeijing",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "谢谢 [xièxiè]",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "Thank you",
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
            text: "![Audio](beijing.mp3)",
            position: Vector2Hive(0, 0),
            matchPosition: Vector2Hive(1, 0),
          ),
          MatchingTypeValue(
            text: "北京\nBěijīng\nBeijing",
            position: Vector2Hive(1, 0),
            matchPosition: Vector2Hive(0, 0),
          ),
          MatchingTypeValue(
            text: "谢谢 [xièxiè]",
            position: Vector2Hive(0, 1),
            matchPosition: Vector2Hive(1, 1),
          ),
          MatchingTypeValue(
            text: "Thank you",
            position: Vector2Hive(1, 1),
            matchPosition: Vector2Hive(0, 1),
          ),
          MatchingTypeValue(
            text: "再见 [zàijiàn]",
            position: Vector2Hive(0, 2),
            matchPosition: Vector2Hive(1, 2),
          ),
          MatchingTypeValue(
            text: "Goodbye",
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
            "![Image](cup.webp)\nZhè shì wǒ de bēizi.\nMeaning: This is my cup.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "bēizi",
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
            "![Image](desk.webp)\nShū zài zhuōzi shàng.\nMeaning: The book is on the table.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "zhuōzi",
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
            "![Image](chair.webp)\nWǒ zuò zài yǐzi shàng.\nMeaning: I sit on the chair.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "yǐzi",
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
            "![Image](computer.webp)\nWǒ yǒu yì tái diànnǎo.\nMeaning: I have a computer.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "diànnǎo",
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
            "![Image](tv.webp)\nWǒ kàn diànshì.\nMeaning: I watch television.",
        answerKeys: const [
          FillInTheBlankAnswerKey(
            value: "diànshì",
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
        sentenceToScramble: "Wǒ kàn diànyǐng",
      ),
      WordScrambleTemplate(
        id: '${idPrefix}template_26',
        deckId: dataDeckId,
        sortOrder: 26,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: "Wǒ zuò fēijī qù Běijīng",
      ),
      WordScrambleTemplate(
        id: '${idPrefix}template_27',
        deckId: dataDeckId,
        sortOrder: 27,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: "Wǒ zuò chūzūchē",
      ),
      WordScrambleTemplate(
        id: '${idPrefix}template_28',
        deckId: dataDeckId,
        sortOrder: 28,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: "Zhè shì wǒ de yīfu",
      ),
      WordScrambleTemplate(
        id: '${idPrefix}template_29',
        deckId: dataDeckId,
        sortOrder: 29,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: "Wǒ xǐhuan chī shuǐguǒ",
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

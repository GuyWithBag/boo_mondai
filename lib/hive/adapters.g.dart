// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String,
      userName: fields[2] as String,
      role: fields[3] as String,
      avatarUrl: fields[4] as String?,
      targetLanguage: fields[5] as String?,
      createdAt: fields[6] as DateTime,
      userId: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.userName)
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.avatarUrl)
      ..writeByte(5)
      ..write(obj.targetLanguage)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CachedProfileAdapter extends TypeAdapter<CachedProfile> {
  @override
  final typeId = 1;

  @override
  CachedProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedProfile(
      id: fields[0] as String,
      userName: fields[1] as String,
      avatarUrl: fields[2] as String?,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CachedProfile obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.avatarUrl)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeckAdapter extends TypeAdapter<Deck> {
  @override
  final typeId = 2;

  @override
  Deck read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Deck(
      id: fields[0] as String,
      authorId: fields[1] as String,
      title: fields[2] as String,
      shortDescription: fields[3] == null ? '' : fields[3] as String,
      longDescription: fields[4] == null ? '' : fields[4] as String,
      targetLanguage: fields[5] as String,
      tags: fields[6] == null ? const [] : (fields[6] as List).cast<String>(),
      isPremade: fields[7] == null ? false : fields[7] as bool,
      isPublic: fields[8] as bool,
      isEditable: fields[10] == null ? true : fields[10] as bool,
      cardCount: (fields[11] as num).toInt(),
      version: fields[12] == null ? '1.0.0' : fields[12] as String,
      buildNumber: fields[13] == null ? 1 : (fields[13] as num).toInt(),
      createdAt: fields[14] as DateTime,
      updatedAt: fields[15] as DateTime,
      sourceDeckId: fields[16] as String?,
      sourceAuthorId: fields[17] as String?,
      isPublished: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Deck obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.authorId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.shortDescription)
      ..writeByte(4)
      ..write(obj.longDescription)
      ..writeByte(5)
      ..write(obj.targetLanguage)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.isPremade)
      ..writeByte(8)
      ..write(obj.isPublic)
      ..writeByte(9)
      ..write(obj.isPublished)
      ..writeByte(10)
      ..write(obj.isEditable)
      ..writeByte(11)
      ..write(obj.cardCount)
      ..writeByte(12)
      ..write(obj.version)
      ..writeByte(13)
      ..write(obj.buildNumber)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt)
      ..writeByte(16)
      ..write(obj.sourceDeckId)
      ..writeByte(17)
      ..write(obj.sourceAuthorId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MultipleChoiceOptionAdapter extends TypeAdapter<MultipleChoiceOption> {
  @override
  final typeId = 3;

  @override
  MultipleChoiceOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MultipleChoiceOption(
      id: fields[0] as String,
      templateId: fields[5] as String,
      optionText: fields[2] as String,
      isCorrect: fields[3] as bool,
      displayOrder: (fields[4] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, MultipleChoiceOption obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.optionText)
      ..writeByte(3)
      ..write(obj.isCorrect)
      ..writeByte(4)
      ..write(obj.displayOrder)
      ..writeByte(5)
      ..write(obj.templateId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultipleChoiceOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReviewCardAdapter extends TypeAdapter<ReviewCard> {
  @override
  final typeId = 5;

  @override
  ReviewCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewCard(
      id: fields[0] as String,
      templateId: fields[1] as String,
      isReversed: fields[2] == null ? false : fields[2] as bool,
      deckId: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ReviewCard obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.templateId)
      ..writeByte(2)
      ..write(obj.isReversed)
      ..writeByte(3)
      ..write(obj.deckId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FillInTheBlankSegmentAdapter extends TypeAdapter<FillInTheBlankSegment> {
  @override
  final typeId = 6;

  @override
  FillInTheBlankSegment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FillInTheBlankSegment(
      id: fields[0] as String,
      cardId: fields[1] as String,
      fullText: fields[2] as String,
      blankStart: (fields[3] as num).toInt(),
      blankEnd: (fields[4] as num).toInt(),
      correctAnswer: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FillInTheBlankSegment obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cardId)
      ..writeByte(2)
      ..write(obj.fullText)
      ..writeByte(3)
      ..write(obj.blankStart)
      ..writeByte(4)
      ..write(obj.blankEnd)
      ..writeByte(5)
      ..write(obj.correctAnswer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FillInTheBlankSegmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MatchMadnessPairAdapter extends TypeAdapter<MatchMadnessPair> {
  @override
  final typeId = 7;

  @override
  MatchMadnessPair read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MatchMadnessPair(
      id: fields[0] as String,
      templateId: fields[7] as String,
      sourceTemplateId: fields[8] as String?,
      term: fields[3] as String,
      match: fields[4] as String,
      isAutoPicked: fields[5] == null ? false : fields[5] as bool,
      displayOrder: fields[6] == null ? 0 : (fields[6] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, MatchMadnessPair obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.term)
      ..writeByte(4)
      ..write(obj.match)
      ..writeByte(5)
      ..write(obj.isAutoPicked)
      ..writeByte(6)
      ..write(obj.displayOrder)
      ..writeByte(7)
      ..write(obj.templateId)
      ..writeByte(8)
      ..write(obj.sourceTemplateId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchMadnessPairAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserDeckProgressAdapter extends TypeAdapter<UserDeckProgress> {
  @override
  final typeId = 8;

  @override
  UserDeckProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDeckProgress(
      id: fields[0] as String,
      userId: fields[1] as String,
      deckId: fields[2] as String,
      newCardsCount: fields[3] == null ? 0 : (fields[3] as num).toInt(),
      learningCardsCount: fields[4] == null ? 0 : (fields[4] as num).toInt(),
      reviewCardsCount: fields[5] == null ? 0 : (fields[5] as num).toInt(),
      totalQuizzed: fields[6] == null ? 0 : (fields[6] as num).toInt(),
      lastStudiedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserDeckProgress obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.deckId)
      ..writeByte(3)
      ..write(obj.newCardsCount)
      ..writeByte(4)
      ..write(obj.learningCardsCount)
      ..writeByte(5)
      ..write(obj.reviewCardsCount)
      ..writeByte(6)
      ..write(obj.totalQuizzed)
      ..writeByte(7)
      ..write(obj.lastStudiedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDeckProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuizSessionAdapter extends TypeAdapter<QuizSession> {
  @override
  final typeId = 9;

  @override
  QuizSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizSession(
      id: fields[0] as String,
      userId: fields[1] as String,
      deckId: fields[2] as String,
      previewed: fields[3] as bool,
      totalQuestions: (fields[4] as num).toInt(),
      correctCount: (fields[5] as num).toInt(),
      startedAt: fields[6] as DateTime,
      completedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, QuizSession obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.deckId)
      ..writeByte(3)
      ..write(obj.previewed)
      ..writeByte(4)
      ..write(obj.totalQuestions)
      ..writeByte(5)
      ..write(obj.correctCount)
      ..writeByte(6)
      ..write(obj.startedAt)
      ..writeByte(7)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CardAdapter extends TypeAdapter<Card> {
  @override
  final typeId = 10;

  @override
  Card read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Card(
      cardId: (fields[0] as num).toInt(),
      state: fields[1] == null ? State.learning : fields[1] as State,
      step: (fields[2] as num?)?.toInt(),
      stability: (fields[3] as num?)?.toDouble(),
      difficulty: (fields[4] as num?)?.toDouble(),
      due: fields[5] as DateTime?,
      lastReview: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Card obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.cardId)
      ..writeByte(1)
      ..write(obj.state)
      ..writeByte(2)
      ..write(obj.step)
      ..writeByte(3)
      ..write(obj.stability)
      ..writeByte(4)
      ..write(obj.difficulty)
      ..writeByte(5)
      ..write(obj.due)
      ..writeByte(6)
      ..write(obj.lastReview);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReviewLogAdapter extends TypeAdapter<ReviewLog> {
  @override
  final typeId = 11;

  @override
  ReviewLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewLog(
      cardId: (fields[0] as num).toInt(),
      rating: fields[1] as Rating,
      reviewDateTime: fields[2] as DateTime,
      reviewDuration: (fields[3] as num?)?.toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ReviewLog obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.cardId)
      ..writeByte(1)
      ..write(obj.rating)
      ..writeByte(2)
      ..write(obj.reviewDateTime)
      ..writeByte(3)
      ..write(obj.reviewDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StreakAdapter extends TypeAdapter<Streak> {
  @override
  final typeId = 12;

  @override
  Streak read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Streak(
      id: fields[0] as String,
      userId: fields[1] as String,
      currentStreak: (fields[2] as num).toInt(),
      longestStreak: (fields[3] as num).toInt(),
      lastActivityDate: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Streak obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.currentStreak)
      ..writeByte(3)
      ..write(obj.longestStreak)
      ..writeByte(4)
      ..write(obj.lastActivityDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreakAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CardTypeAdapter extends TypeAdapter<CardType> {
  @override
  final typeId = 13;

  @override
  CardType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CardType.normal;
      case 1:
        return CardType.reversed;
      case 2:
        return CardType.both;
      default:
        return CardType.normal;
    }
  }

  @override
  void write(BinaryWriter writer, CardType obj) {
    switch (obj) {
      case CardType.normal:
        writer.writeByte(0);
      case CardType.reversed:
        writer.writeByte(1);
      case CardType.both:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestionTypeAdapter extends TypeAdapter<QuestionType> {
  @override
  final typeId = 14;

  @override
  QuestionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuestionType.flashcard;
      case 1:
        return QuestionType.identification;
      case 2:
        return QuestionType.multipleChoice;
      case 3:
        return QuestionType.fillInTheBlanks;
      case 4:
        return QuestionType.wordScramble;
      case 5:
        return QuestionType.matchMadness;
      default:
        return QuestionType.flashcard;
    }
  }

  @override
  void write(BinaryWriter writer, QuestionType obj) {
    switch (obj) {
      case QuestionType.flashcard:
        writer.writeByte(0);
      case QuestionType.identification:
        writer.writeByte(1);
      case QuestionType.multipleChoice:
        writer.writeByte(2);
      case QuestionType.fillInTheBlanks:
        writer.writeByte(3);
      case QuestionType.wordScramble:
        writer.writeByte(4);
      case QuestionType.matchMadness:
        writer.writeByte(5);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FillInTheBlanksTemplateAdapter
    extends TypeAdapter<FillInTheBlanksTemplate> {
  @override
  final typeId = 15;

  @override
  FillInTheBlanksTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FillInTheBlanksTemplate(
      id: fields[1] as String,
      deckId: fields[2] as String,
      sortOrder: (fields[3] as num).toInt(),
      createdAt: fields[4] as DateTime,
      sourceTemplateId: fields[5] as String?,
      segments: (fields[0] as List).cast<FillInTheBlankSegment>(),
    );
  }

  @override
  void write(BinaryWriter writer, FillInTheBlanksTemplate obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.segments)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.deckId)
      ..writeByte(3)
      ..write(obj.sortOrder)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.sourceTemplateId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FillInTheBlanksTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MultipleChoiceTemplateAdapter
    extends TypeAdapter<MultipleChoiceTemplate> {
  @override
  final typeId = 16;

  @override
  MultipleChoiceTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MultipleChoiceTemplate(
      id: fields[4] as String,
      deckId: fields[5] as String,
      sortOrder: (fields[6] as num).toInt(),
      createdAt: fields[7] as DateTime,
      sourceTemplateId: fields[8] as String?,
      questionPrompt: fields[0] as String,
      options: (fields[1] as List).cast<MultipleChoiceOption>(),
      imageUrl: fields[2] as String?,
      audioUrl: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MultipleChoiceTemplate obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.questionPrompt)
      ..writeByte(1)
      ..write(obj.options)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.audioUrl)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.deckId)
      ..writeByte(6)
      ..write(obj.sortOrder)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.sourceTemplateId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultipleChoiceTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FlashcardTemplateAdapter extends TypeAdapter<FlashcardTemplate> {
  @override
  final typeId = 17;

  @override
  FlashcardTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlashcardTemplate(
      id: fields[6] as String,
      deckId: fields[7] as String,
      sortOrder: (fields[8] as num).toInt(),
      createdAt: fields[9] as DateTime,
      sourceTemplateId: fields[10] as String?,
      frontText: fields[0] as String,
      backText: fields[1] as String,
      frontImageUrl: fields[2] as String?,
      backImageUrl: fields[3] as String?,
      frontAudioUrl: fields[4] as String?,
      backAudioUrl: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FlashcardTemplate obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.frontText)
      ..writeByte(1)
      ..write(obj.backText)
      ..writeByte(2)
      ..write(obj.frontImageUrl)
      ..writeByte(3)
      ..write(obj.backImageUrl)
      ..writeByte(4)
      ..write(obj.frontAudioUrl)
      ..writeByte(5)
      ..write(obj.backAudioUrl)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.deckId)
      ..writeByte(8)
      ..write(obj.sortOrder)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.sourceTemplateId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MatchMadnessTemplateAdapter extends TypeAdapter<MatchMadnessTemplate> {
  @override
  final typeId = 18;

  @override
  MatchMadnessTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MatchMadnessTemplate(
      id: fields[1] as String,
      deckId: fields[2] as String,
      sortOrder: (fields[3] as num).toInt(),
      createdAt: fields[4] as DateTime,
      sourceTemplateId: fields[5] as String?,
      pairs: (fields[0] as List).cast<MatchMadnessPair>(),
    );
  }

  @override
  void write(BinaryWriter writer, MatchMadnessTemplate obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.pairs)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.deckId)
      ..writeByte(3)
      ..write(obj.sortOrder)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.sourceTemplateId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchMadnessTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IdentificationTemplateAdapter
    extends TypeAdapter<IdentificationTemplate> {
  @override
  final typeId = 19;

  @override
  IdentificationTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IdentificationTemplate(
      id: fields[4] as String,
      deckId: fields[5] as String,
      sortOrder: (fields[6] as num).toInt(),
      createdAt: fields[7] as DateTime,
      sourceTemplateId: fields[8] as String?,
      promptText: fields[0] as String,
      acceptedAnswers: fields[1] as String,
      imageUrl: fields[2] as String?,
      audioUrl: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IdentificationTemplate obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.promptText)
      ..writeByte(1)
      ..write(obj.acceptedAnswers)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.audioUrl)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.deckId)
      ..writeByte(6)
      ..write(obj.sortOrder)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.sourceTemplateId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdentificationTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuizAnswerAdapter extends TypeAdapter<QuizAnswer> {
  @override
  final typeId = 20;

  @override
  QuizAnswer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizAnswer(
      id: fields[0] as String,
      sessionId: fields[1] as String,
      cardId: fields[2] as String,
      userAnswer: fields[3] as String,
      type: fields[4] as QuizAnswerType,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, QuizAnswer obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sessionId)
      ..writeByte(2)
      ..write(obj.cardId)
      ..writeByte(3)
      ..write(obj.userAnswer)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizAnswerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuizAnswerTypeAdapter extends TypeAdapter<QuizAnswerType> {
  @override
  final typeId = 21;

  @override
  QuizAnswerType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuizAnswerType.incorrect;
      case 1:
        return QuizAnswerType.again;
      case 2:
        return QuizAnswerType.easy;
      case 3:
        return QuizAnswerType.good;
      case 4:
        return QuizAnswerType.hard;
      default:
        return QuizAnswerType.incorrect;
    }
  }

  @override
  void write(BinaryWriter writer, QuizAnswerType obj) {
    switch (obj) {
      case QuizAnswerType.incorrect:
        writer.writeByte(0);
      case QuizAnswerType.again:
        writer.writeByte(1);
      case QuizAnswerType.easy:
        writer.writeByte(2);
      case QuizAnswerType.good:
        writer.writeByte(3);
      case QuizAnswerType.hard:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizAnswerTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FsrsCardAdapter extends TypeAdapter<FsrsCard> {
  @override
  final typeId = 22;

  @override
  FsrsCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FsrsCard(
      id: fields[0] as String,
      userId: fields[1] as String,
      reviewCardId: fields[2] as String,
      state: fields[3] as Card,
    );
  }

  @override
  void write(BinaryWriter writer, FsrsCard obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.reviewCardId)
      ..writeByte(3)
      ..write(obj.state);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FsrsCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FsrsReviewLogAdapter extends TypeAdapter<FsrsReviewLog> {
  @override
  final typeId = 23;

  @override
  FsrsReviewLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FsrsReviewLog(
      id: fields[0] as String,
      cardId: fields[1] as String,
      log: fields[2] as ReviewLog,
    );
  }

  @override
  void write(BinaryWriter writer, FsrsReviewLog obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cardId)
      ..writeByte(2)
      ..write(obj.log);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FsrsReviewLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StateAdapter extends TypeAdapter<State> {
  @override
  final typeId = 24;

  @override
  State read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return State.learning;
      case 1:
        return State.review;
      case 2:
        return State.relearning;
      default:
        return State.learning;
    }
  }

  @override
  void write(BinaryWriter writer, State obj) {
    switch (obj) {
      case State.learning:
        writer.writeByte(0);
      case State.review:
        writer.writeByte(1);
      case State.relearning:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RatingAdapter extends TypeAdapter<Rating> {
  @override
  final typeId = 25;

  @override
  Rating read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Rating.again;
      case 1:
        return Rating.hard;
      case 2:
        return Rating.good;
      case 3:
        return Rating.easy;
      default:
        return Rating.again;
    }
  }

  @override
  void write(BinaryWriter writer, Rating obj) {
    switch (obj) {
      case Rating.again:
        writer.writeByte(0);
      case Rating.hard:
        writer.writeByte(1);
      case Rating.good:
        writer.writeByte(2);
      case Rating.easy:
        writer.writeByte(3);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RatingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class ProfileAdapter extends TypeAdapter<Profile> {
  @override
  final typeId = 0;

  @override
  Profile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Profile(
      id: fields[0] as String,
      username: fields[2] as String,
      role: fields[3] as String?,
      avatarUrl: fields[4] as String?,
      createdAt: fields[6] as DateTime,
      userId: fields[1] as String,
      updatedAt: fields[7] as DateTime,
      isAnonymous: fields[8] == null ? true : fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.avatarUrl)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.isAnonymous);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileAdapter &&
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
      username: fields[1] as String,
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
      ..write(obj.username)
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
      id: fields[19] as String,
      userId: fields[18] as String,
      title: fields[2] as String,
      shortDescription: fields[3] == null ? '' : fields[3] as String,
      longDescription: fields[4] == null ? '' : fields[4] as String,
      coverImageUrl: fields[28] as String?,
      sourceDeckId: fields[16] as String?,
      isPremade: fields[7] == null ? false : fields[7] as bool,
      visibilityState: fields[22] as VisibilityState,
      isPublished: fields[9] as bool,
      isEditable: fields[10] == null ? true : fields[10] as bool,
      cardCount: (fields[11] as num).toInt(),
      version: fields[12] == null ? '1.0.0' : fields[12] as String,
      buildNumber: fields[13] == null ? 1 : (fields[13] as num).toInt(),
      createdAt: fields[21] as DateTime,
      updatedAt: fields[20] as DateTime,
      tags: fields[6] == null ? const [] : (fields[6] as List).cast<Tag>(),
      userProfile: fields[32] as CachedProfile?,
      listing: fields[30] as DeckListing?,
    );
  }

  @override
  void write(BinaryWriter writer, Deck obj) {
    writer
      ..writeByte(19)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.shortDescription)
      ..writeByte(4)
      ..write(obj.longDescription)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.isPremade)
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
      ..writeByte(16)
      ..write(obj.sourceDeckId)
      ..writeByte(18)
      ..write(obj.userId)
      ..writeByte(19)
      ..write(obj.id)
      ..writeByte(20)
      ..write(obj.updatedAt)
      ..writeByte(21)
      ..write(obj.createdAt)
      ..writeByte(22)
      ..write(obj.visibilityState)
      ..writeByte(28)
      ..write(obj.coverImageUrl)
      ..writeByte(30)
      ..write(obj.listing)
      ..writeByte(32)
      ..write(obj.userProfile);
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
      personalTags: fields[4] == null
          ? const []
          : (fields[4] as List).cast<Tag>(),
      template: fields[5] as CardTemplate?,
      deck: fields[6] as Deck?,
    );
  }

  @override
  void write(BinaryWriter writer, ReviewCard obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.templateId)
      ..writeByte(2)
      ..write(obj.isReversed)
      ..writeByte(3)
      ..write(obj.deckId)
      ..writeByte(4)
      ..write(obj.personalTags)
      ..writeByte(5)
      ..write(obj.template)
      ..writeByte(6)
      ..write(obj.deck);
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

class DrillSessionAdapter extends TypeAdapter<DrillSession> {
  @override
  final typeId = 9;

  @override
  DrillSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DrillSession(
      id: fields[8] as String,
      userId: fields[9] as String,
      deckId: fields[10] as String?,
      startedAt: fields[11] as DateTime,
      completedAt: fields[12] as DateTime?,
      userProfile: fields[13] as CachedProfile?,
      deck: fields[14] as Deck?,
      previewed: fields[3] == null ? false : fields[3] as bool,
      totalQuestions: (fields[4] as num).toInt(),
      correctCount: fields[5] == null ? 0 : (fields[5] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, DrillSession obj) {
    writer
      ..writeByte(10)
      ..writeByte(3)
      ..write(obj.previewed)
      ..writeByte(4)
      ..write(obj.totalQuestions)
      ..writeByte(5)
      ..write(obj.correctCount)
      ..writeByte(8)
      ..write(obj.id)
      ..writeByte(9)
      ..write(obj.userId)
      ..writeByte(10)
      ..write(obj.deckId)
      ..writeByte(11)
      ..write(obj.startedAt)
      ..writeByte(12)
      ..write(obj.completedAt)
      ..writeByte(13)
      ..write(obj.userProfile)
      ..writeByte(14)
      ..write(obj.deck);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrillSessionAdapter &&
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
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      userId: fields[1] as String,
      currentStreak: (fields[2] as num).toInt(),
      longestStreak: (fields[3] as num).toInt(),
      lastActivityDate: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Streak obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.currentStreak)
      ..writeByte(3)
      ..write(obj.longestStreak)
      ..writeByte(4)
      ..write(obj.lastActivityDate)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
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
      updatedAt: fields[6] as DateTime,
      sourceTemplateId: fields[5] as String?,
      tags: fields[7] == null ? const [] : (fields[7] as List).cast<Tag>(),
      segments: (fields[0] as List).cast<FillInTheBlankSegment>(),
    );
  }

  @override
  void write(BinaryWriter writer, FillInTheBlanksTemplate obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.sourceTemplateId)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.tags);
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
      updatedAt: fields[9] as DateTime,
      sourceTemplateId: fields[8] as String?,
      tags: fields[10] == null ? const [] : (fields[10] as List).cast<Tag>(),
      questionPrompt: fields[0] as String,
      options: (fields[1] as List).cast<MultipleChoiceOption>(),
      imageUrl: fields[2] as String?,
      audioUrl: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MultipleChoiceTemplate obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.sourceTemplateId)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.tags);
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
      updatedAt: fields[12] as DateTime,
      sourceTemplateId: fields[10] as String?,
      tags: fields[13] == null ? const [] : (fields[13] as List).cast<Tag>(),
      frontText: fields[0] as String,
      backText: fields[1] as String,
      frontImageUrl: fields[2] as String?,
      backImageUrl: fields[3] as String?,
      frontAudioUrl: fields[4] as String?,
      backAudioUrl: fields[5] as String?,
      cardType: fields[11] == null ? CardType.normal : fields[11] as CardType,
    );
  }

  @override
  void write(BinaryWriter writer, FlashcardTemplate obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.sourceTemplateId)
      ..writeByte(11)
      ..write(obj.cardType)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.tags);
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
      updatedAt: fields[6] as DateTime,
      sourceTemplateId: fields[5] as String?,
      tags: fields[7] == null ? const [] : (fields[7] as List).cast<Tag>(),
      pairs: (fields[0] as List).cast<MatchMadnessPair>(),
    );
  }

  @override
  void write(BinaryWriter writer, MatchMadnessTemplate obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.sourceTemplateId)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.tags);
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
      updatedAt: fields[9] as DateTime,
      sourceTemplateId: fields[8] as String?,
      tags: fields[10] == null ? const [] : (fields[10] as List).cast<Tag>(),
      promptText: fields[0] as String,
      acceptedAnswers: fields[1] as String,
      imageUrl: fields[2] as String?,
      audioUrl: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IdentificationTemplate obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.sourceTemplateId)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.tags);
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

class DrillAnswerAdapter extends TypeAdapter<DrillAnswer> {
  @override
  final typeId = 20;

  @override
  DrillAnswer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DrillAnswer(
      id: fields[0] as String,
      sessionId: fields[1] as String,
      cardId: fields[2] as String,
      userAnswer: fields[3] as String,
      type: fields[4] as StudyRating,
      createdAt: fields[5] as DateTime,
      session: fields[6] as DrillSession?,
      cardTemplate: fields[7] as CardTemplate?,
    );
  }

  @override
  void write(BinaryWriter writer, DrillAnswer obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.session)
      ..writeByte(7)
      ..write(obj.cardTemplate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrillAnswerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StudyRatingAdapter extends TypeAdapter<StudyRating> {
  @override
  final typeId = 21;

  @override
  StudyRating read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StudyRating.incorrect;
      case 1:
        return StudyRating.again;
      case 2:
        return StudyRating.easy;
      case 3:
        return StudyRating.good;
      case 4:
        return StudyRating.hard;
      default:
        return StudyRating.incorrect;
    }
  }

  @override
  void write(BinaryWriter writer, StudyRating obj) {
    switch (obj) {
      case StudyRating.incorrect:
        writer.writeByte(0);
      case StudyRating.again:
        writer.writeByte(1);
      case StudyRating.easy:
        writer.writeByte(2);
      case StudyRating.good:
        writer.writeByte(3);
      case StudyRating.hard:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyRatingAdapter &&
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
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      userId: fields[1] as String,
      reviewCardId: fields[2] as String,
      state: fields[3] as Card,
      reviewCard: fields[6] as ReviewCard?,
    );
  }

  @override
  void write(BinaryWriter writer, FsrsCard obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.reviewCardId)
      ..writeByte(3)
      ..write(obj.state)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.reviewCard);
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
      createdAt: fields[4] as DateTime,
      fsrsCardId: fields[3] as String,
      log: fields[2] as ReviewLog,
    );
  }

  @override
  void write(BinaryWriter writer, FsrsReviewLog obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.log)
      ..writeByte(3)
      ..write(obj.fsrsCardId)
      ..writeByte(4)
      ..write(obj.createdAt);
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

class WordScrambleTemplateAdapter extends TypeAdapter<WordScrambleTemplate> {
  @override
  final typeId = 26;

  @override
  WordScrambleTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordScrambleTemplate(
      id: fields[3] as String,
      deckId: fields[4] as String,
      sortOrder: (fields[5] as num).toInt(),
      createdAt: fields[6] as DateTime,
      updatedAt: fields[8] as DateTime,
      sourceTemplateId: fields[7] as String?,
      tags: fields[9] == null ? const [] : (fields[9] as List).cast<Tag>(),
      sentenceToScramble: fields[0] as String,
      imageUrl: fields[1] as String?,
      audioUrl: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WordScrambleTemplate obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.sentenceToScramble)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.audioUrl)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.deckId)
      ..writeByte(5)
      ..write(obj.sortOrder)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.sourceTemplateId)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordScrambleTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 27;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      appMetadata: (fields[1] as Map).cast<String, dynamic>(),
      userMetadata: (fields[2] as Map?)?.cast<String, dynamic>(),
      aud: fields[3] as String,
      confirmationSentAt: fields[4] as String?,
      recoverySentAt: fields[5] as String?,
      emailChangeSentAt: fields[6] as String?,
      newEmail: fields[7] as String?,
      invitedAt: fields[8] as String?,
      actionLink: fields[9] as String?,
      email: fields[10] as String?,
      phone: fields[11] as String?,
      createdAt: fields[12] as String,
      confirmedAt: fields[13] as String?,
      emailConfirmedAt: fields[14] as String?,
      phoneConfirmedAt: fields[15] as String?,
      lastSignInAt: fields[16] as String?,
      role: fields[17] as String?,
      updatedAt: fields[18] as String?,
      identities: (fields[19] as List?)?.cast<UserIdentity>(),
      factors: (fields[20] as List?)?.cast<Factor>(),
      isAnonymous: fields[21] == null ? false : fields[21] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.appMetadata)
      ..writeByte(2)
      ..write(obj.userMetadata)
      ..writeByte(3)
      ..write(obj.aud)
      ..writeByte(4)
      ..write(obj.confirmationSentAt)
      ..writeByte(5)
      ..write(obj.recoverySentAt)
      ..writeByte(6)
      ..write(obj.emailChangeSentAt)
      ..writeByte(7)
      ..write(obj.newEmail)
      ..writeByte(8)
      ..write(obj.invitedAt)
      ..writeByte(9)
      ..write(obj.actionLink)
      ..writeByte(10)
      ..write(obj.email)
      ..writeByte(11)
      ..write(obj.phone)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.confirmedAt)
      ..writeByte(14)
      ..write(obj.emailConfirmedAt)
      ..writeByte(15)
      ..write(obj.phoneConfirmedAt)
      ..writeByte(16)
      ..write(obj.lastSignInAt)
      ..writeByte(17)
      ..write(obj.role)
      ..writeByte(18)
      ..write(obj.updatedAt)
      ..writeByte(19)
      ..write(obj.identities)
      ..writeByte(20)
      ..write(obj.factors)
      ..writeByte(21)
      ..write(obj.isAnonymous);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReviewSessionAdapter extends TypeAdapter<ReviewSession> {
  @override
  final typeId = 28;

  @override
  ReviewSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewSession(
      id: fields[2] as String,
      userId: fields[3] as String,
      deckId: fields[4] as String?,
      startedAt: fields[5] as DateTime,
      completedAt: fields[6] as DateTime?,
      userProfile: fields[7] as CachedProfile?,
      deck: fields[8] as Deck?,
      totalCards: (fields[0] as num).toInt(),
      cardsReviewed: fields[1] == null ? 0 : (fields[1] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ReviewSession obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.totalCards)
      ..writeByte(1)
      ..write(obj.cardsReviewed)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.deckId)
      ..writeByte(5)
      ..write(obj.startedAt)
      ..writeByte(6)
      ..write(obj.completedAt)
      ..writeByte(7)
      ..write(obj.userProfile)
      ..writeByte(8)
      ..write(obj.deck);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VisibilityStateAdapter extends TypeAdapter<VisibilityState> {
  @override
  final typeId = 29;

  @override
  VisibilityState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VisibilityState.public;
      case 1:
        return VisibilityState.private;
      case 2:
        return VisibilityState.unlisted;
      default:
        return VisibilityState.public;
    }
  }

  @override
  void write(BinaryWriter writer, VisibilityState obj) {
    switch (obj) {
      case VisibilityState.public:
        writer.writeByte(0);
      case VisibilityState.private:
        writer.writeByte(1);
      case VisibilityState.unlisted:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisibilityStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TagAdapter extends TypeAdapter<Tag> {
  @override
  final typeId = 30;

  @override
  Tag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tag(
      id: fields[0] as String,
      userId: fields[1] as String?,
      name: fields[2] as String,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Tag obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeckListingAdapter extends TypeAdapter<DeckListing> {
  @override
  final typeId = 31;

  @override
  DeckListing read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeckListing(
      upvotesCount: fields[1] == null ? 0 : (fields[1] as num).toInt(),
      downvotesCount: fields[2] == null ? 0 : (fields[2] as num).toInt(),
      downloadsCount: fields[3] == null ? 0 : (fields[3] as num).toInt(),
      favoritesCount: fields[4] == null ? 0 : (fields[4] as num).toInt(),
      forksCount: fields[5] == null ? 0 : (fields[5] as num).toInt(),
      commentsCount: fields[6] == null ? 0 : (fields[6] as num).toInt(),
      reviewsCount: fields[13] == null ? 0 : (fields[13] as num).toInt(),
      reportsCount: fields[7] == null ? 0 : (fields[7] as num).toInt(),
      featuredCards: fields[8] == null
          ? const []
          : (fields[8] as List)
                .map((e) => (e as Map).cast<String, dynamic>())
                .toList(),
      featuredImages: fields[9] == null
          ? const []
          : (fields[9] as List).cast<String>(),
      updatedAt: fields[11] as DateTime,
      createdAt: fields[12] as DateTime,
      deckId: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DeckListing obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.deckId)
      ..writeByte(1)
      ..write(obj.upvotesCount)
      ..writeByte(2)
      ..write(obj.downvotesCount)
      ..writeByte(3)
      ..write(obj.downloadsCount)
      ..writeByte(4)
      ..write(obj.favoritesCount)
      ..writeByte(5)
      ..write(obj.forksCount)
      ..writeByte(6)
      ..write(obj.commentsCount)
      ..writeByte(7)
      ..write(obj.reportsCount)
      ..writeByte(8)
      ..write(obj.featuredCards)
      ..writeByte(9)
      ..write(obj.featuredImages)
      ..writeByte(11)
      ..write(obj.updatedAt)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.reviewsCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckListingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeckTagAdapter extends TypeAdapter<DeckTag> {
  @override
  final typeId = 32;

  @override
  DeckTag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeckTag(deckId: fields[0] as String, tagId: fields[1] as String);
  }

  @override
  void write(BinaryWriter writer, DeckTag obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.deckId)
      ..writeByte(1)
      ..write(obj.tagId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckTagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CardTemplateTagAdapter extends TypeAdapter<CardTemplateTag> {
  @override
  final typeId = 33;

  @override
  CardTemplateTag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardTemplateTag(
      templateId: fields[0] as String,
      tagId: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CardTemplateTag obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.templateId)
      ..writeByte(1)
      ..write(obj.tagId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardTemplateTagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserReviewCardTagAdapter extends TypeAdapter<UserReviewCardTag> {
  @override
  final typeId = 34;

  @override
  UserReviewCardTag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserReviewCardTag(
      userId: fields[0] as String,
      reviewCardId: fields[1] as String,
      tagId: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserReviewCardTag obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.reviewCardId)
      ..writeByte(2)
      ..write(obj.tagId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserReviewCardTagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

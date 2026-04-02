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
      userName: fields[1] as String,
      role: fields[2] as String,
      avatarUrl: fields[3] as String?,
      targetLanguage: fields[4] as String?,
      createdAt: fields[5] as DateTime,
      userId: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.avatarUrl)
      ..writeByte(4)
      ..write(obj.targetLanguage)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.userId);
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

class DeckAdapter extends TypeAdapter<Deck> {
  @override
  final typeId = 1;

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
      isEditable: fields[19] == null ? true : fields[19] as bool,
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
      ..write(obj.sourceAuthorId)
      ..writeByte(19)
      ..write(obj.isEditable);
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

class DeckCardAdapter extends TypeAdapter<DeckCard> {
  @override
  final typeId = 2;

  @override
  DeckCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeckCard(
      id: fields[0] as String,
      deckId: fields[1] as String,
      cardType: fields[2] == null ? CardType.normal : fields[2] as CardType,
      questionType: fields[3] == null
          ? QuestionType.flashcard
          : fields[3] as QuestionType,
      sortOrder: (fields[4] as num).toInt(),
      createdAt: fields[5] as DateTime,
      sourceCardId: fields[6] as String?,
      identificationAnswer: fields[7] == null ? '' : fields[7] as String,
      notes: fields[8] == null ? const [] : (fields[8] as List).cast<Note>(),
      options: fields[9] == null
          ? const []
          : (fields[9] as List).cast<MultipleChoiceOption>(),
      segments: fields[10] == null
          ? const []
          : (fields[10] as List).cast<FillInTheBlankSegment>(),
      pairs: fields[11] == null
          ? const []
          : (fields[11] as List).cast<MatchMadnessPair>(),
    );
  }

  @override
  void write(BinaryWriter writer, DeckCard obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.deckId)
      ..writeByte(2)
      ..write(obj.cardType)
      ..writeByte(3)
      ..write(obj.questionType)
      ..writeByte(4)
      ..write(obj.sortOrder)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.sourceCardId)
      ..writeByte(7)
      ..write(obj.identificationAnswer)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.options)
      ..writeByte(10)
      ..write(obj.segments)
      ..writeByte(11)
      ..write(obj.pairs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final typeId = 3;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      id: fields[0] as String,
      cardId: fields[1] as String,
      frontText: fields[2] as String,
      backText: fields[3] as String,
      frontAudioUrl: fields[4] as String?,
      backAudioUrl: fields[5] as String?,
      frontImageUrl: fields[6] as String?,
      backImageUrl: fields[7] as String?,
      isReverse: fields[8] as bool,
      createdAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cardId)
      ..writeByte(2)
      ..write(obj.frontText)
      ..writeByte(3)
      ..write(obj.backText)
      ..writeByte(4)
      ..write(obj.frontAudioUrl)
      ..writeByte(5)
      ..write(obj.backAudioUrl)
      ..writeByte(6)
      ..write(obj.frontImageUrl)
      ..writeByte(7)
      ..write(obj.backImageUrl)
      ..writeByte(8)
      ..write(obj.isReverse)
      ..writeByte(9)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MultipleChoiceOptionAdapter extends TypeAdapter<MultipleChoiceOption> {
  @override
  final typeId = 4;

  @override
  MultipleChoiceOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MultipleChoiceOption(
      id: fields[0] as String,
      cardId: fields[1] as String,
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
      ..writeByte(1)
      ..write(obj.cardId)
      ..writeByte(2)
      ..write(obj.optionText)
      ..writeByte(3)
      ..write(obj.isCorrect)
      ..writeByte(4)
      ..write(obj.displayOrder);
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

class FillInTheBlankSegmentAdapter extends TypeAdapter<FillInTheBlankSegment> {
  @override
  final typeId = 5;

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
  final typeId = 6;

  @override
  MatchMadnessPair read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MatchMadnessPair(
      id: fields[0] as String,
      cardId: fields[1] as String,
      sourceCardId: fields[2] as String?,
      term: fields[3] as String,
      match: fields[4] as String,
      isAutoPicked: fields[5] as bool,
      displayOrder: (fields[6] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, MatchMadnessPair obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cardId)
      ..writeByte(2)
      ..write(obj.sourceCardId)
      ..writeByte(3)
      ..write(obj.term)
      ..writeByte(4)
      ..write(obj.match)
      ..writeByte(5)
      ..write(obj.isAutoPicked)
      ..writeByte(6)
      ..write(obj.displayOrder);
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

class CardAdapter extends TypeAdapter<Card> {
  @override
  final typeId = 7;

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
  final typeId = 8;

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
  final typeId = 9;

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
  final typeId = 10;

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
  final typeId = 11;

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

class CachedProfileAdapter extends TypeAdapter<CachedProfile> {
  @override
  final typeId = 12;

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

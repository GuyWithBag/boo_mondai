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
      email: fields[1] as String,
      displayName: fields[2] as String,
      role: fields[3] as String,
      avatarUrl: fields[4] as String?,
      targetLanguage: fields[5] as String?,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.displayName)
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
      creatorId: fields[1] as String,
      title: fields[2] as String,
      shortDescription: fields[3] == null ? '' : fields[3] as String,
      longDescription: fields[10] == null ? '' : fields[10] as String,
      targetLanguage: fields[4] as String,
      tags: fields[14] == null ? const [] : (fields[14] as List).cast<String>(),
      isPremade: fields[5] as bool,
      isPublic: fields[6] as bool,
      isUneditable: fields[11] == null ? false : fields[11] as bool,
      cardCount: (fields[7] as num).toInt(),
      version: fields[12] == null ? '1.0.0' : fields[12] as String,
      buildNumber: fields[13] == null ? 1 : (fields[13] as num).toInt(),
      createdAt: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime,
      sourceDeckId: fields[16] as String?,
      sourceDeckCreatorId: fields[15] as String?,
      hiddenInBrowser: fields[18] == null ? false : fields[18] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Deck obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.creatorId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.shortDescription)
      ..writeByte(4)
      ..write(obj.targetLanguage)
      ..writeByte(5)
      ..write(obj.isPremade)
      ..writeByte(6)
      ..write(obj.isPublic)
      ..writeByte(7)
      ..write(obj.cardCount)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.longDescription)
      ..writeByte(11)
      ..write(obj.isUneditable)
      ..writeByte(12)
      ..write(obj.version)
      ..writeByte(13)
      ..write(obj.buildNumber)
      ..writeByte(14)
      ..write(obj.tags)
      ..writeByte(15)
      ..write(obj.sourceDeckCreatorId)
      ..writeByte(16)
      ..write(obj.sourceDeckId)
      ..writeByte(18)
      ..write(obj.hiddenInBrowser);
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
      cardType: fields[8] == null ? CardType.normal : fields[8] as CardType,
      questionType: fields[9] == null
          ? QuestionType.flashcard
          : fields[9] as QuestionType,
      sortOrder: (fields[6] as num).toInt(),
      createdAt: fields[7] as DateTime,
      sourceCardId: fields[14] as String?,
      identificationAnswer: fields[15] == null ? '' : fields[15] as String,
      notes: fields[16] == null ? const [] : (fields[16] as List).cast<Note>(),
      options: fields[17] == null
          ? const []
          : (fields[17] as List).cast<MultipleChoiceOption>(),
      segments: fields[18] == null
          ? const []
          : (fields[18] as List).cast<FillInTheBlankSegment>(),
      pairs: fields[19] == null
          ? const []
          : (fields[19] as List).cast<MatchMadnessPair>(),
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
      ..writeByte(6)
      ..write(obj.sortOrder)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.cardType)
      ..writeByte(9)
      ..write(obj.questionType)
      ..writeByte(14)
      ..write(obj.sourceCardId)
      ..writeByte(15)
      ..write(obj.identificationAnswer)
      ..writeByte(16)
      ..write(obj.notes)
      ..writeByte(17)
      ..write(obj.options)
      ..writeByte(18)
      ..write(obj.segments)
      ..writeByte(19)
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

class FsrsCardStateAdapter extends TypeAdapter<FsrsCardState> {
  @override
  final typeId = 3;

  @override
  FsrsCardState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FsrsCardState(
      id: fields[0] as String,
      userId: fields[1] as String,
      cardId: fields[2] as String,
      due: fields[3] as DateTime,
      stability: (fields[4] as num).toDouble(),
      difficulty: (fields[5] as num).toDouble(),
      elapsedDays: (fields[6] as num).toInt(),
      scheduledDays: (fields[7] as num).toInt(),
      reps: (fields[8] as num).toInt(),
      lapses: (fields[9] as num).toInt(),
      state: (fields[10] as num).toInt(),
      lastReview: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, FsrsCardState obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.cardId)
      ..writeByte(3)
      ..write(obj.due)
      ..writeByte(4)
      ..write(obj.stability)
      ..writeByte(5)
      ..write(obj.difficulty)
      ..writeByte(6)
      ..write(obj.elapsedDays)
      ..writeByte(7)
      ..write(obj.scheduledDays)
      ..writeByte(8)
      ..write(obj.reps)
      ..writeByte(9)
      ..write(obj.lapses)
      ..writeByte(10)
      ..write(obj.state)
      ..writeByte(11)
      ..write(obj.lastReview);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FsrsCardStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReviewLogEntryAdapter extends TypeAdapter<ReviewLogEntry> {
  @override
  final typeId = 4;

  @override
  ReviewLogEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewLogEntry(
      id: fields[0] as String,
      userId: fields[1] as String,
      cardId: fields[2] as String,
      rating: (fields[3] as num).toInt(),
      scheduledDays: (fields[4] as num).toInt(),
      elapsedDays: (fields[5] as num).toInt(),
      review: fields[6] as DateTime,
      state: (fields[7] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ReviewLogEntry obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.cardId)
      ..writeByte(3)
      ..write(obj.rating)
      ..writeByte(4)
      ..write(obj.scheduledDays)
      ..writeByte(5)
      ..write(obj.elapsedDays)
      ..writeByte(6)
      ..write(obj.review)
      ..writeByte(7)
      ..write(obj.state);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewLogEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StreakAdapter extends TypeAdapter<Streak> {
  @override
  final typeId = 5;

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

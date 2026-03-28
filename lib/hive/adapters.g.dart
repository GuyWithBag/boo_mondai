// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: depend_on_referenced_packages

part of 'adapters.dart';

// ignore: directives_ordering
import 'dart:convert';

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
      shortDescription: fields[3] as String? ?? '',
      targetLanguage: fields[4] as String,
      isPremade: fields[5] as bool,
      isPublic: fields[6] as bool,
      cardCount: (fields[7] as num).toInt(),
      createdAt: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime,
      longDescription: fields[10] as String? ?? '',
      isUneditable: fields[11] as bool? ?? false,
      version: fields[12] as String? ?? '1.0.0',
      buildNumber: (fields[13] as num?)?.toInt() ?? 1,
      tags: (fields[14] as List?)?.cast<String>() ?? const [],
      // index 15: sourceDeckCreatorId (was creatorName — same String? type)
      sourceDeckCreatorId: fields[15] as String?,
      sourceDeckId: fields[16] as String?,
      // index 17: legacy (was sourceDeckCreatorName) — no longer written/used
      hiddenInBrowser: fields[18] as bool? ?? false,
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
      ..writeByte(15) // sourceDeckCreatorId (was creatorName — same String? type)
      ..write(obj.sourceDeckCreatorId)
      ..writeByte(16)
      ..write(obj.sourceDeckId)
      // index 17 no longer written (was sourceDeckCreatorName)
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

    List<T> _decodeList<T>(int index, T Function(Map<String, dynamic>) fromJson) {
      final raw = fields[index] as String?;
      if (raw == null || raw.isEmpty) return [];
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return DeckCard(
      id: fields[0] as String,
      deckId: fields[1] as String,
      // indices 2–5 were old question/answer/image fields — skipped
      sortOrder: (fields[6] as num).toInt(),
      createdAt: fields[7] as DateTime,
      cardType: CardType.fromString(fields[8] as String?),
      questionType: QuestionType.fromString(fields[9] as String?),
      notes: _decodeList(10, Note.fromJson),
      options: _decodeList(11, MultipleChoiceOption.fromJson),
      segments: _decodeList(12, FillInTheBlankSegment.fromJson),
      pairs: _decodeList(13, MatchMadnessPair.fromJson),
    );
  }

  @override
  void write(BinaryWriter writer, DeckCard obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.deckId)
      ..writeByte(6)
      ..write(obj.sortOrder)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.cardType.toJson())
      ..writeByte(9)
      ..write(obj.questionType.toJson())
      ..writeByte(10)
      ..write(jsonEncode(obj.notes.map((n) => n.toJson()).toList()))
      ..writeByte(11)
      ..write(jsonEncode(obj.options.map((o) => o.toJson()).toList()))
      ..writeByte(12)
      ..write(jsonEncode(obj.segments.map((s) => s.toJson()).toList()))
      ..writeByte(13)
      ..write(jsonEncode(obj.pairs.map((p) => p.toJson()).toList()));
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

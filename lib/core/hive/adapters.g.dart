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
      displayName: fields[3] as String,
      role: fields[4] == null
          ? ProfileRole.user
          : fields[4] is ProfileRole
          ? fields[4] as ProfileRole
          : ProfileRole.fromString(fields[4] as String?),
      avatarUrl: fields[5] as String?,
      createdAt: fields[6] as DateTime,
      userId: fields[1] as String,
      updatedAt: fields[7] as DateTime,
      deletedAt: fields[8] as DateTime?,
      purgeAfter: fields[9] as DateTime?,
      isAnonymous: fields[10] == null ? true : fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.displayName)
      ..writeByte(4)
      ..write(obj.role)
      ..writeByte(5)
      ..write(obj.avatarUrl)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.deletedAt)
      ..writeByte(9)
      ..write(obj.purgeAfter)
      ..writeByte(10)
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
      profileId: fields[1] as String,
      title: fields[6] as String,
      shortDescription: fields[7] == null ? '' : fields[7] as String,
      longDescription: fields[8] == null ? '' : fields[8] as String,
      coverImageUrl: fields[9] as String?,
      sourceDeckId: fields[10] as String?,
      isPremade: fields[11] == null ? false : fields[11] as bool,
      visibilityState: fields[12] == null
          ? VisibilityState.private
          : fields[12] as VisibilityState,
      isPublished: fields[13] == null ? false : fields[13] as bool,
      isEditable: fields[14] == null ? true : fields[14] as bool,
      cardTemplatesCount: fields[15] == null ? 0 : (fields[15] as num).toInt(),
      version: fields[16] == null ? '0.1.0+1' : fields[16] as String,
      buildNumber: fields[17] == null ? 1 : (fields[17] as num).toInt(),
      tags: fields[18] == null ? const [] : (fields[18] as List).cast<Tag>(),
      updatedAt: fields[2] as DateTime,
      createdAt: fields[3] as DateTime,
      deletedAt: fields[4] as DateTime?,
      purgeAfter: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Deck obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.profileId)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.deletedAt)
      ..writeByte(5)
      ..write(obj.purgeAfter)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.shortDescription)
      ..writeByte(8)
      ..write(obj.longDescription)
      ..writeByte(9)
      ..write(obj.coverImageUrl)
      ..writeByte(10)
      ..write(obj.sourceDeckId)
      ..writeByte(11)
      ..write(obj.isPremade)
      ..writeByte(12)
      ..write(obj.visibilityState)
      ..writeByte(13)
      ..write(obj.isPublished)
      ..writeByte(14)
      ..write(obj.isEditable)
      ..writeByte(15)
      ..write(obj.cardTemplatesCount)
      ..writeByte(16)
      ..write(obj.version)
      ..writeByte(17)
      ..write(obj.buildNumber)
      ..writeByte(18)
      ..write(obj.tags);
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
  final typeId = 2;

  @override
  MultipleChoiceOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MultipleChoiceOption(
      id: fields[0] as String,
      templateId: fields[1] as String,
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
      ..write(obj.templateId)
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

class FillInTheBlanksTemplateAdapter
    extends TypeAdapter<FillInTheBlanksTemplate> {
  @override
  final typeId = 3;

  @override
  FillInTheBlanksTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FillInTheBlanksTemplate(
      id: fields[2] as String,
      deckId: fields[7] as String,
      sortOrder: (fields[8] as num).toInt(),
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
      deletedAt: fields[5] as DateTime?,
      purgeAfter: fields[6] as DateTime?,
      sourceTemplateId: fields[9] as String?,
      tags: fields[10] == null ? const [] : (fields[10] as List).cast<Tag>(),
      verticallyCentered: fields[11] == null ? true : fields[11] as bool,
      promptText: fields[0] as String,
      answerKeys: (fields[1] as List).cast<FillInTheBlankAnswerKey>(),
    );
  }

  @override
  void write(BinaryWriter writer, FillInTheBlanksTemplate obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.promptText)
      ..writeByte(1)
      ..write(obj.answerKeys)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.deletedAt)
      ..writeByte(6)
      ..write(obj.purgeAfter)
      ..writeByte(7)
      ..write(obj.deckId)
      ..writeByte(8)
      ..write(obj.sortOrder)
      ..writeByte(9)
      ..write(obj.sourceTemplateId)
      ..writeByte(10)
      ..write(obj.tags)
      ..writeByte(11)
      ..write(obj.verticallyCentered);
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
  final typeId = 4;

  @override
  MultipleChoiceTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MultipleChoiceTemplate(
      id: fields[4] as String,
      deckId: fields[9] as String,
      sortOrder: (fields[10] as num).toInt(),
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      deletedAt: fields[7] as DateTime?,
      purgeAfter: fields[8] as DateTime?,
      sourceTemplateId: fields[11] as String?,
      tags: fields[12] == null ? const [] : (fields[12] as List).cast<Tag>(),
      verticallyCentered: fields[13] == null ? true : fields[13] as bool,
      questionPrompt: fields[0] as String,
      options: (fields[1] as List).cast<MultipleChoiceOption>(),
      multipleAnswers: fields[2] == null ? false : fields[2] as bool,
      randomizedOptionsOrdering: fields[3] == null ? false : fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MultipleChoiceTemplate obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.questionPrompt)
      ..writeByte(1)
      ..write(obj.options)
      ..writeByte(2)
      ..write(obj.multipleAnswers)
      ..writeByte(3)
      ..write(obj.randomizedOptionsOrdering)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.deletedAt)
      ..writeByte(8)
      ..write(obj.purgeAfter)
      ..writeByte(9)
      ..write(obj.deckId)
      ..writeByte(10)
      ..write(obj.sortOrder)
      ..writeByte(11)
      ..write(obj.sourceTemplateId)
      ..writeByte(12)
      ..write(obj.tags)
      ..writeByte(13)
      ..write(obj.verticallyCentered);
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
  final typeId = 5;

  @override
  FlashcardTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlashcardTemplate(
      id: fields[3] as String,
      deckId: fields[8] as String,
      sortOrder: (fields[9] as num).toInt(),
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      deletedAt: fields[6] as DateTime?,
      purgeAfter: fields[7] as DateTime?,
      sourceTemplateId: fields[10] as String?,
      tags: fields[11] == null ? const [] : (fields[11] as List).cast<Tag>(),
      verticallyCentered: fields[12] == null ? true : fields[12] as bool,
      frontText: fields[0] as String,
      backText: fields[1] as String,
      direction: fields[2] == null
          ? CardTemplateDirection.normal
          : fields[2] as CardTemplateDirection,
    );
  }

  @override
  void write(BinaryWriter writer, FlashcardTemplate obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.frontText)
      ..writeByte(1)
      ..write(obj.backText)
      ..writeByte(2)
      ..write(obj.direction)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.deletedAt)
      ..writeByte(7)
      ..write(obj.purgeAfter)
      ..writeByte(8)
      ..write(obj.deckId)
      ..writeByte(9)
      ..write(obj.sortOrder)
      ..writeByte(10)
      ..write(obj.sourceTemplateId)
      ..writeByte(11)
      ..write(obj.tags)
      ..writeByte(12)
      ..write(obj.verticallyCentered);
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

class MatchingTypeTemplateAdapter extends TypeAdapter<MatchingTypeTemplate> {
  @override
  final typeId = 6;

  @override
  MatchingTypeTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MatchingTypeTemplate(
      id: fields[2] as String,
      deckId: fields[7] as String,
      sortOrder: (fields[8] as num).toInt(),
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
      deletedAt: fields[5] as DateTime?,
      purgeAfter: fields[6] as DateTime?,
      sourceTemplateId: fields[9] as String?,
      tags: fields[10] == null ? const [] : (fields[10] as List).cast<Tag>(),
      verticallyCentered: fields[11] == null ? true : fields[11] as bool,
      values: (fields[0] as List).cast<MatchingTypeValue>(),
      maxIncorrectAnswers: fields[12] == null
          ? -1
          : (fields[12] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, MatchingTypeTemplate obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.values)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.deletedAt)
      ..writeByte(6)
      ..write(obj.purgeAfter)
      ..writeByte(7)
      ..write(obj.deckId)
      ..writeByte(8)
      ..write(obj.sortOrder)
      ..writeByte(9)
      ..write(obj.sourceTemplateId)
      ..writeByte(10)
      ..write(obj.tags)
      ..writeByte(11)
      ..write(obj.verticallyCentered)
      ..writeByte(12)
      ..write(obj.maxIncorrectAnswers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchingTypeTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IdentificationAnswerKeyAdapter
    extends TypeAdapter<IdentificationAnswerKey> {
  @override
  final typeId = 7;

  @override
  IdentificationAnswerKey read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IdentificationAnswerKey(
      id: fields[0] as String,
      templateId: fields[1] as String,
      displayOrder: (fields[2] as num).toInt(),
      value: fields[3] as String,
      casingType: fields[4] == null ? CasingType.any : fields[4] as CasingType,
    );
  }

  @override
  void write(BinaryWriter writer, IdentificationAnswerKey obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.templateId)
      ..writeByte(2)
      ..write(obj.displayOrder)
      ..writeByte(3)
      ..write(obj.value)
      ..writeByte(4)
      ..write(obj.casingType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdentificationAnswerKeyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IdentificationTemplateAdapter
    extends TypeAdapter<IdentificationTemplate> {
  @override
  final typeId = 8;

  @override
  IdentificationTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IdentificationTemplate(
      id: fields[2] as String,
      deckId: fields[7] as String,
      sortOrder: (fields[8] as num).toInt(),
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
      deletedAt: fields[5] as DateTime?,
      purgeAfter: fields[6] as DateTime?,
      sourceTemplateId: fields[9] as String?,
      tags: fields[10] == null ? const [] : (fields[10] as List).cast<Tag>(),
      verticallyCentered: fields[11] == null ? true : fields[11] as bool,
      promptText: fields[0] as String,
      answers: (fields[1] as List).cast<IdentificationAnswerKey>(),
    );
  }

  @override
  void write(BinaryWriter writer, IdentificationTemplate obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.promptText)
      ..writeByte(1)
      ..write(obj.answers)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.deletedAt)
      ..writeByte(6)
      ..write(obj.purgeAfter)
      ..writeByte(7)
      ..write(obj.deckId)
      ..writeByte(8)
      ..write(obj.sortOrder)
      ..writeByte(9)
      ..write(obj.sourceTemplateId)
      ..writeByte(10)
      ..write(obj.tags)
      ..writeByte(11)
      ..write(obj.verticallyCentered);
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

class StudyCardAdapter extends TypeAdapter<StudyCard> {
  @override
  final typeId = 9;

  @override
  StudyCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudyCard(
      id: fields[0] as String,
      createdAt: fields[1] as DateTime,
      updatedAt: fields[2] as DateTime,
      deletedAt: fields[3] as DateTime?,
      purgeAfter: fields[4] as DateTime?,
      templateId: fields[5] as String,
      isReversed: fields[6] == null ? false : fields[6] as bool,
      deckId: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StudyCard obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.deletedAt)
      ..writeByte(4)
      ..write(obj.purgeAfter)
      ..writeByte(5)
      ..write(obj.templateId)
      ..writeByte(6)
      ..write(obj.isReversed)
      ..writeByte(7)
      ..write(obj.deckId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FillInTheBlankAnswerKeyAdapter
    extends TypeAdapter<FillInTheBlankAnswerKey> {
  @override
  final typeId = 10;

  @override
  FillInTheBlankAnswerKey read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FillInTheBlankAnswerKey(
      casingType: fields[0] as CasingType,
      value: fields[1] as String,
      order: (fields[2] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, FillInTheBlankAnswerKey obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.casingType)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FillInTheBlankAnswerKeyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WordScrambleTemplateAdapter extends TypeAdapter<WordScrambleTemplate> {
  @override
  final typeId = 11;

  @override
  WordScrambleTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordScrambleTemplate(
      id: fields[1] as String,
      deckId: fields[6] as String,
      sortOrder: (fields[7] as num).toInt(),
      createdAt: fields[2] as DateTime,
      updatedAt: fields[3] as DateTime,
      deletedAt: fields[4] as DateTime?,
      purgeAfter: fields[5] as DateTime?,
      sourceTemplateId: fields[8] as String?,
      tags: fields[9] == null ? const [] : (fields[9] as List).cast<Tag>(),
      verticallyCentered: fields[10] == null ? true : fields[10] as bool,
      sentenceToScramble: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WordScrambleTemplate obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.sentenceToScramble)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.deletedAt)
      ..writeByte(5)
      ..write(obj.purgeAfter)
      ..writeByte(6)
      ..write(obj.deckId)
      ..writeByte(7)
      ..write(obj.sortOrder)
      ..writeByte(8)
      ..write(obj.sourceTemplateId)
      ..writeByte(9)
      ..write(obj.tags)
      ..writeByte(10)
      ..write(obj.verticallyCentered);
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

class MatchingTypeValueAdapter extends TypeAdapter<MatchingTypeValue> {
  @override
  final typeId = 12;

  @override
  MatchingTypeValue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MatchingTypeValue(
      text: fields[0] as String,
      matchPosition: fields[1] as Vector2Hive,
      position: fields[2] as Vector2Hive,
    );
  }

  @override
  void write(BinaryWriter writer, MatchingTypeValue obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.matchPosition)
      ..writeByte(2)
      ..write(obj.position);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchingTypeValueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StudyRatingAdapter extends TypeAdapter<StudyRating> {
  @override
  final typeId = 13;

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

class CardAdapter extends TypeAdapter<Card> {
  @override
  final typeId = 14;

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

class FsrsCardAdapter extends TypeAdapter<FsrsCard> {
  @override
  final typeId = 15;

  @override
  FsrsCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FsrsCard(
      id: fields[0] as String,
      createdAt: fields[1] as DateTime,
      updatedAt: fields[2] as DateTime,
      deletedAt: fields[3] as DateTime?,
      purgeAfter: fields[4] as DateTime?,
      profileId: fields[5] as String,
      studyCardId: fields[6] as String,
      state: fields[7] as Card,
    );
  }

  @override
  void write(BinaryWriter writer, FsrsCard obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.deletedAt)
      ..writeByte(4)
      ..write(obj.purgeAfter)
      ..writeByte(5)
      ..write(obj.profileId)
      ..writeByte(6)
      ..write(obj.studyCardId)
      ..writeByte(7)
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

class ReviewLogAdapter extends TypeAdapter<ReviewLog> {
  @override
  final typeId = 16;

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

class ReviewSessionAdapter extends TypeAdapter<ReviewSession> {
  @override
  final typeId = 17;

  @override
  ReviewSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewSession(
      id: fields[0] as String,
      profileId: fields[1] as String,
      deckId: fields[2] as String?,
      startedAt: fields[3] as DateTime,
      completedAt: fields[4] as DateTime?,
      deck: fields[5] as Deck?,
      totalCards: (fields[6] as num).toInt(),
      cardsReviewed: fields[7] == null ? 0 : (fields[7] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ReviewSession obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.profileId)
      ..writeByte(2)
      ..write(obj.deckId)
      ..writeByte(3)
      ..write(obj.startedAt)
      ..writeByte(4)
      ..write(obj.completedAt)
      ..writeByte(5)
      ..write(obj.deck)
      ..writeByte(6)
      ..write(obj.totalCards)
      ..writeByte(7)
      ..write(obj.cardsReviewed);
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

class StudySessionCardStepAdapter extends TypeAdapter<StudySessionCardStep> {
  @override
  final typeId = 18;

  @override
  StudySessionCardStep read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudySessionCardStep(
      id: fields[2] as String,
      studyCardId: fields[0] as String,
      attemptNumber: fields[1] == null ? 1 : (fields[1] as num).toInt(),
      insertedByRuleId: fields[3] as String?,
      insertionReason: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudySessionCardStep obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.studyCardId)
      ..writeByte(1)
      ..write(obj.attemptNumber)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.insertedByRuleId)
      ..writeByte(4)
      ..write(obj.insertionReason);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudySessionCardStepAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StudySessionMessageStepAdapter
    extends TypeAdapter<StudySessionMessageStep> {
  @override
  final typeId = 19;

  @override
  StudySessionMessageStep read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudySessionMessageStep(
      id: fields[3] as String,
      messageDefinitionId: fields[0] as String,
      title: fields[1] as String,
      message: fields[2] as String,
      insertedByRuleId: fields[4] as String?,
      insertionReason: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudySessionMessageStep obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.messageDefinitionId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.insertedByRuleId)
      ..writeByte(5)
      ..write(obj.insertionReason);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudySessionMessageStepAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StudySessionAnswerAdapter extends TypeAdapter<StudySessionAnswer> {
  @override
  final typeId = 20;

  @override
  StudySessionAnswer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudySessionAnswer(
      value: fields[0] as String,
      id: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudySessionAnswer obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudySessionAnswerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StudySessionSnapshotAdapter extends TypeAdapter<StudySessionSnapshot> {
  @override
  final typeId = 21;

  @override
  StudySessionSnapshot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudySessionSnapshot(
      sessionId: fields[0] as String,
      sequenceNumber: (fields[1] as num).toInt(),
      step: fields[2] as StudySessionStep,
      completedAt: fields[10] as DateTime,
      studyCard: fields[3] as StudyCard?,
      cardTemplate: fields[4] as CardTemplate?,
      fsrsCardBefore: fields[5] as FsrsCard?,
      fsrsCardAfter: fields[6] as FsrsCard?,
      fsrsReviewLog: fields[7] as FsrsReviewLog?,
      answer: fields[8] as StudySessionAnswer?,
      rating: fields[9] as StudyRating?,
    );
  }

  @override
  void write(BinaryWriter writer, StudySessionSnapshot obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.sessionId)
      ..writeByte(1)
      ..write(obj.sequenceNumber)
      ..writeByte(2)
      ..write(obj.step)
      ..writeByte(3)
      ..write(obj.studyCard)
      ..writeByte(4)
      ..write(obj.cardTemplate)
      ..writeByte(5)
      ..write(obj.fsrsCardBefore)
      ..writeByte(6)
      ..write(obj.fsrsCardAfter)
      ..writeByte(7)
      ..write(obj.fsrsReviewLog)
      ..writeByte(8)
      ..write(obj.answer)
      ..writeByte(9)
      ..write(obj.rating)
      ..writeByte(10)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudySessionSnapshotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FsrsReviewLogAdapter extends TypeAdapter<FsrsReviewLog> {
  @override
  final typeId = 22;

  @override
  FsrsReviewLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FsrsReviewLog(
      id: fields[0] as String,
      createdAt: fields[1] as DateTime,
      fsrsCardId: fields[2] as String,
      log: fields[3] as ReviewLog,
    );
  }

  @override
  void write(BinaryWriter writer, FsrsReviewLog obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.fsrsCardId)
      ..writeByte(3)
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
  final typeId = 23;

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

class StreakAdapter extends TypeAdapter<Streak> {
  @override
  final typeId = 24;

  @override
  Streak read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Streak(
      id: fields[0] as String,
      createdAt: fields[1] as DateTime,
      updatedAt: fields[2] as DateTime,
      deletedAt: fields[3] as DateTime?,
      purgeAfter: fields[4] as DateTime?,
      profileId: fields[5] as String,
      currentStreak: (fields[6] as num).toInt(),
      longestStreak: (fields[7] as num).toInt(),
      lastActivityDate: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Streak obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.deletedAt)
      ..writeByte(4)
      ..write(obj.purgeAfter)
      ..writeByte(5)
      ..write(obj.profileId)
      ..writeByte(6)
      ..write(obj.currentStreak)
      ..writeByte(7)
      ..write(obj.longestStreak)
      ..writeByte(8)
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

class CardTemplateDirectionAdapter extends TypeAdapter<CardTemplateDirection> {
  @override
  final typeId = 26;

  @override
  CardTemplateDirection read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CardTemplateDirection.normal;
      case 1:
        return CardTemplateDirection.reversed;
      case 2:
        return CardTemplateDirection.both;
      default:
        return CardTemplateDirection.normal;
    }
  }

  @override
  void write(BinaryWriter writer, CardTemplateDirection obj) {
    switch (obj) {
      case CardTemplateDirection.normal:
        writer.writeByte(0);
      case CardTemplateDirection.reversed:
        writer.writeByte(1);
      case CardTemplateDirection.both:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardTemplateDirectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CasingTypeAdapter extends TypeAdapter<CasingType> {
  @override
  final typeId = 27;

  @override
  CasingType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CasingType.any;
      case 1:
        return CasingType.exact;
      case 2:
        return CasingType.camel;
      case 3:
        return CasingType.pascal;
      case 4:
        return CasingType.snake;
      case 5:
        return CasingType.kebab;
      case 6:
        return CasingType.title;
      default:
        return CasingType.any;
    }
  }

  @override
  void write(BinaryWriter writer, CasingType obj) {
    switch (obj) {
      case CasingType.any:
        writer.writeByte(0);
      case CasingType.exact:
        writer.writeByte(1);
      case CasingType.camel:
        writer.writeByte(2);
      case CasingType.pascal:
        writer.writeByte(3);
      case CasingType.snake:
        writer.writeByte(4);
      case CasingType.kebab:
        writer.writeByte(5);
      case CasingType.title:
        writer.writeByte(6);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CasingTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CardTemplateTypeAdapter extends TypeAdapter<CardTemplateType> {
  @override
  final typeId = 28;

  @override
  CardTemplateType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CardTemplateType.flashcard;
      case 1:
        return CardTemplateType.identification;
      case 2:
        return CardTemplateType.multipleChoice;
      case 3:
        return CardTemplateType.fillInTheBlanks;
      case 4:
        return CardTemplateType.wordScramble;
      case 5:
        return CardTemplateType.matchMadness;
      default:
        return CardTemplateType.flashcard;
    }
  }

  @override
  void write(BinaryWriter writer, CardTemplateType obj) {
    switch (obj) {
      case CardTemplateType.flashcard:
        writer.writeByte(0);
      case CardTemplateType.identification:
        writer.writeByte(1);
      case CardTemplateType.multipleChoice:
        writer.writeByte(2);
      case CardTemplateType.fillInTheBlanks:
        writer.writeByte(3);
      case CardTemplateType.wordScramble:
        writer.writeByte(4);
      case CardTemplateType.matchMadness:
        writer.writeByte(5);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardTemplateTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 29;

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

class VisibilityStateAdapter extends TypeAdapter<VisibilityState> {
  @override
  final typeId = 30;

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
  final typeId = 31;

  @override
  Tag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tag(
      id: fields[0] as String,
      profileId: fields[1] as String?,
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
      ..write(obj.profileId)
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
  final typeId = 32;

  @override
  DeckListing read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeckListing(
      upvotesCount: fields[2] == null ? 0 : (fields[2] as num).toInt(),
      downvotesCount: fields[3] == null ? 0 : (fields[3] as num).toInt(),
      downloadsCount: fields[4] == null ? 0 : (fields[4] as num).toInt(),
      favoritesCount: fields[5] == null ? 0 : (fields[5] as num).toInt(),
      forksCount: fields[6] == null ? 0 : (fields[6] as num).toInt(),
      commentsCount: fields[7] == null ? 0 : (fields[7] as num).toInt(),
      reviewsCount: fields[8] == null ? 0 : (fields[8] as num).toInt(),
      reportsCount: fields[9] == null ? 0 : (fields[9] as num).toInt(),
      featuredCards: fields[10] == null
          ? const []
          : (fields[10] as List).cast<CardTemplate>(),
      featuredImages: fields[11] == null
          ? const []
          : (fields[11] as List).cast<String>(),
      deletedAt: fields[12] as DateTime?,
      purgeAfter: fields[13] as DateTime?,
      deckId: fields[0] as String,
      contentId: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DeckListing obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.deckId)
      ..writeByte(1)
      ..write(obj.contentId)
      ..writeByte(2)
      ..write(obj.upvotesCount)
      ..writeByte(3)
      ..write(obj.downvotesCount)
      ..writeByte(4)
      ..write(obj.downloadsCount)
      ..writeByte(5)
      ..write(obj.favoritesCount)
      ..writeByte(6)
      ..write(obj.forksCount)
      ..writeByte(7)
      ..write(obj.commentsCount)
      ..writeByte(8)
      ..write(obj.reviewsCount)
      ..writeByte(9)
      ..write(obj.reportsCount)
      ..writeByte(10)
      ..write(obj.featuredCards)
      ..writeByte(11)
      ..write(obj.featuredImages)
      ..writeByte(12)
      ..write(obj.deletedAt)
      ..writeByte(13)
      ..write(obj.purgeAfter);
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
  final typeId = 33;

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
  final typeId = 34;

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

class UserStudyCardTagAdapter extends TypeAdapter<UserStudyCardTag> {
  @override
  final typeId = 35;

  @override
  UserStudyCardTag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStudyCardTag(
      profileId: fields[0] as String,
      studyCardId: fields[1] as String,
      tagId: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserStudyCardTag obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.profileId)
      ..writeByte(1)
      ..write(obj.studyCardId)
      ..writeByte(2)
      ..write(obj.tagId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStudyCardTagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserSettingsAdapter extends TypeAdapter<UserSettings> {
  @override
  final typeId = 36;

  @override
  UserSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettings(
      id: fields[0] as String,
      profileId: fields[1] as String,
      preferences: (fields[4] as Map).cast<String, dynamic>(),
      createdAt: fields[2] as DateTime,
      updatedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.profileId)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.preferences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProgressCheckpointAdapter extends TypeAdapter<ProgressCheckpoint> {
  @override
  final typeId = 37;

  @override
  ProgressCheckpoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgressCheckpoint(
      id: fields[0] as String,
      type: fields[1] as ProgressCheckpointType,
      targetId: fields[2] as String,
      operationDescription: fields[3] as String,
      totalItems: (fields[4] as num).toInt(),
      completedTargetItemIds: (fields[5] as List).cast<String>(),
      status: fields[6] as ProgressCheckpointStatus,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ProgressCheckpoint obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.targetId)
      ..writeByte(3)
      ..write(obj.operationDescription)
      ..writeByte(4)
      ..write(obj.totalItems)
      ..writeByte(5)
      ..write(obj.completedTargetItemIds)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressCheckpointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProgressCheckpointTypeAdapter
    extends TypeAdapter<ProgressCheckpointType> {
  @override
  final typeId = 38;

  @override
  ProgressCheckpointType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProgressCheckpointType.deckDownloadFetch;
      case 1:
        return ProgressCheckpointType.syncFetch;
      case 2:
        return ProgressCheckpointType.syncApply;
      default:
        return ProgressCheckpointType.deckDownloadFetch;
    }
  }

  @override
  void write(BinaryWriter writer, ProgressCheckpointType obj) {
    switch (obj) {
      case ProgressCheckpointType.deckDownloadFetch:
        writer.writeByte(0);
      case ProgressCheckpointType.syncFetch:
        writer.writeByte(1);
      case ProgressCheckpointType.syncApply:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressCheckpointTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProgressCheckpointStatusAdapter
    extends TypeAdapter<ProgressCheckpointStatus> {
  @override
  final typeId = 39;

  @override
  ProgressCheckpointStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProgressCheckpointStatus.started;
      case 1:
        return ProgressCheckpointStatus.paused;
      case 2:
        return ProgressCheckpointStatus.completed;
      case 3:
        return ProgressCheckpointStatus.failed;
      case 4:
        return ProgressCheckpointStatus.cancelled;
      default:
        return ProgressCheckpointStatus.started;
    }
  }

  @override
  void write(BinaryWriter writer, ProgressCheckpointStatus obj) {
    switch (obj) {
      case ProgressCheckpointStatus.started:
        writer.writeByte(0);
      case ProgressCheckpointStatus.paused:
        writer.writeByte(1);
      case ProgressCheckpointStatus.completed:
        writer.writeByte(2);
      case ProgressCheckpointStatus.failed:
        writer.writeByte(3);
      case ProgressCheckpointStatus.cancelled:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressCheckpointStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncDeletionAdapter extends TypeAdapter<SyncDeletion> {
  @override
  final typeId = 40;

  @override
  SyncDeletion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncDeletion(
      id: fields[0] as String,
      entityType: fields[1] as String,
      entityId: fields[2] as String,
      profileId: fields[5] as String,
      deletedAt: fields[6] as DateTime,
      createdAt: fields[7] as DateTime,
      scopeType: fields[3] as String?,
      scopeId: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SyncDeletion obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.entityType)
      ..writeByte(2)
      ..write(obj.entityId)
      ..writeByte(3)
      ..write(obj.scopeType)
      ..writeByte(4)
      ..write(obj.scopeId)
      ..writeByte(5)
      ..write(obj.profileId)
      ..writeByte(6)
      ..write(obj.deletedAt)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncDeletionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncClientAdapter extends TypeAdapter<SyncClient> {
  @override
  final typeId = 41;

  @override
  SyncClient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncClient(
      id: fields[0] as String,
      profileId: fields[1] as String,
      createdAt: fields[3] as DateTime,
      lastSeenAt: fields[4] as DateTime,
      lastSyncedAt: fields[5] as DateTime?,
      deviceName: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SyncClient obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.profileId)
      ..writeByte(2)
      ..write(obj.deviceName)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.lastSeenAt)
      ..writeByte(5)
      ..write(obj.lastSyncedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncClientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CachedMediaAdapter extends TypeAdapter<CachedMedia> {
  @override
  final typeId = 42;

  @override
  CachedMedia read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedMedia(
      bytes: fields[0] as Uint8List,
      filePath: fields[1] as String,
      profileId: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CachedMedia obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.bytes)
      ..writeByte(1)
      ..write(obj.filePath)
      ..writeByte(2)
      ..write(obj.profileId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedMediaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContentAdapter extends TypeAdapter<Content> {
  @override
  final typeId = 43;

  @override
  Content read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Content(
      id: fields[0] as String,
      profileId: fields[1] as String,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      hasVotes: fields[6] == null ? true : fields[6] as bool,
      parentContentId: fields[2] as String?,
      type: fields[3] as ContentType,
      deletedAt: fields[7] as DateTime?,
      purgeAfter: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Content obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.profileId)
      ..writeByte(2)
      ..write(obj.parentContentId)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.hasVotes)
      ..writeByte(7)
      ..write(obj.deletedAt)
      ..writeByte(8)
      ..write(obj.purgeAfter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContentTypeAdapter extends TypeAdapter<ContentType> {
  @override
  final typeId = 44;

  @override
  ContentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ContentType.deckListing;
      case 1:
        return ContentType.review;
      case 2:
        return ContentType.comment;
      case 3:
        return ContentType.deck;
      default:
        return ContentType.deckListing;
    }
  }

  @override
  void write(BinaryWriter writer, ContentType obj) {
    switch (obj) {
      case ContentType.deckListing:
        writer.writeByte(0);
      case ContentType.review:
        writer.writeByte(1);
      case ContentType.comment:
        writer.writeByte(2);
      case ContentType.deck:
        writer.writeByte(3);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SurveyResponseAdapter extends TypeAdapter<SurveyResponse> {
  @override
  final typeId = 45;

  @override
  SurveyResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SurveyResponse(
      id: fields[0] as String,
      surveyId: fields[1] as String,
      profileId: fields[2] as String,
      assignmentId: fields[3] as String?,
      answers: (fields[4] as Map).cast<String, dynamic>(),
      submittedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SurveyResponse obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.surveyId)
      ..writeByte(2)
      ..write(obj.profileId)
      ..writeByte(3)
      ..write(obj.assignmentId)
      ..writeByte(4)
      ..write(obj.answers)
      ..writeByte(5)
      ..write(obj.submittedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurveyResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class Vector2HiveAdapter extends TypeAdapter<Vector2Hive> {
  @override
  final typeId = 46;

  @override
  Vector2Hive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vector2Hive(
      (fields[0] as num).toDouble(),
      (fields[1] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Vector2Hive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.x)
      ..writeByte(1)
      ..write(obj.y);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vector2HiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationIntentAdapter extends TypeAdapter<NotificationIntent> {
  @override
  final typeId = 47;

  @override
  NotificationIntent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationIntent(
      id: (fields[0] as num).toInt(),
      profileId: fields[12] as String,
      type: fields[1] as NotificationIntentType,
      title: fields[2] as String,
      body: fields[3] as String,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime,
      purgeAt: fields[10] as DateTime,
      route: fields[4] as String?,
      ifRouteNullPushToView: fields[14] == null ? false : fields[14] as bool,
      persistInInbox: fields[5] == null ? false : fields[5] as bool,
      showSystemNotification: fields[6] == null ? true : fields[6] as bool,
      readAt: fields[13] as DateTime?,
      deletedAt: fields[9] as DateTime?,
      purgeAfterDays: fields[11] == null ? 30 : (fields[11] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, NotificationIntent obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.body)
      ..writeByte(4)
      ..write(obj.route)
      ..writeByte(5)
      ..write(obj.persistInInbox)
      ..writeByte(6)
      ..write(obj.showSystemNotification)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.deletedAt)
      ..writeByte(10)
      ..write(obj.purgeAt)
      ..writeByte(11)
      ..write(obj.purgeAfterDays)
      ..writeByte(12)
      ..write(obj.profileId)
      ..writeByte(13)
      ..write(obj.readAt)
      ..writeByte(14)
      ..write(obj.ifRouteNullPushToView);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationIntentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationIntentTypeAdapter
    extends TypeAdapter<NotificationIntentType> {
  @override
  final typeId = 48;

  @override
  NotificationIntentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationIntentType.reviewReminder;
      case 1:
        return NotificationIntentType.streakReminder;
      case 2:
        return NotificationIntentType.downloadComplete;
      case 3:
        return NotificationIntentType.syncComplete;
      case 4:
        return NotificationIntentType.firstDrillSurvey;
      case 5:
        return NotificationIntentType.studyDeckReview;
      default:
        return NotificationIntentType.reviewReminder;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationIntentType obj) {
    switch (obj) {
      case NotificationIntentType.reviewReminder:
        writer.writeByte(0);
      case NotificationIntentType.streakReminder:
        writer.writeByte(1);
      case NotificationIntentType.downloadComplete:
        writer.writeByte(2);
      case NotificationIntentType.syncComplete:
        writer.writeByte(3);
      case NotificationIntentType.firstDrillSurvey:
        writer.writeByte(4);
      case NotificationIntentType.studyDeckReview:
        writer.writeByte(5);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationIntentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StudySessionCompletedResultsAdapter
    extends TypeAdapter<StudySessionCompletedResults> {
  @override
  final typeId = 49;

  @override
  StudySessionCompletedResults read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudySessionCompletedResults(
      profileId: fields[0] as String,
      sessionId: fields[1] as String,
      deckId: fields[2] as String?,
      mode: fields[3] as SessionMode,
      startedAt: fields[4] as DateTime,
      snapshots: (fields[5] as List).cast<StudySessionSnapshot>(),
      fsrsCards: (fields[6] as List).cast<FsrsCard>(),
      fsrsLogs: (fields[7] as List).cast<FsrsReviewLog>(),
      correctCount: (fields[8] as num).toInt(),
      cardCount: (fields[9] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, StudySessionCompletedResults obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.profileId)
      ..writeByte(1)
      ..write(obj.sessionId)
      ..writeByte(2)
      ..write(obj.deckId)
      ..writeByte(3)
      ..write(obj.mode)
      ..writeByte(4)
      ..write(obj.startedAt)
      ..writeByte(5)
      ..write(obj.snapshots)
      ..writeByte(6)
      ..write(obj.fsrsCards)
      ..writeByte(7)
      ..write(obj.fsrsLogs)
      ..writeByte(8)
      ..write(obj.correctCount)
      ..writeByte(9)
      ..write(obj.cardCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudySessionCompletedResultsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionModeAdapter extends TypeAdapter<SessionMode> {
  @override
  final typeId = 50;

  @override
  SessionMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SessionMode.drill;
      case 1:
        return SessionMode.review;
      default:
        return SessionMode.drill;
    }
  }

  @override
  void write(BinaryWriter writer, SessionMode obj) {
    switch (obj) {
      case SessionMode.drill:
        writer.writeByte(0);
      case SessionMode.review:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfileRoleAdapter extends TypeAdapter<ProfileRole> {
  @override
  final typeId = 51;

  @override
  ProfileRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProfileRole.user;
      case 1:
        return ProfileRole.researcher;
      case 2:
        return ProfileRole.admin;
      case 3:
        return ProfileRole.participantA;
      case 4:
        return ProfileRole.participantB;
      default:
        return ProfileRole.user;
    }
  }

  @override
  void write(BinaryWriter writer, ProfileRole obj) {
    switch (obj) {
      case ProfileRole.user:
        writer.writeByte(0);
      case ProfileRole.researcher:
        writer.writeByte(1);
      case ProfileRole.admin:
        writer.writeByte(2);
      case ProfileRole.participantA:
        writer.writeByte(3);
      case ProfileRole.participantB:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

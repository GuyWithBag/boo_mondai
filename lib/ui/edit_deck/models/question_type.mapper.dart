// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'question_type.dart';

class CardTemplateTypeMapper extends EnumMapper<CardTemplateType> {
  CardTemplateTypeMapper._();

  static CardTemplateTypeMapper? _instance;
  static CardTemplateTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CardTemplateTypeMapper._());
    }
    return _instance!;
  }

  static CardTemplateType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  CardTemplateType decode(dynamic value) {
    switch (value) {
      case r'flashcard':
        return CardTemplateType.flashcard;
      case r'identification':
        return CardTemplateType.identification;
      case r'multiple_choice':
        return CardTemplateType.multipleChoice;
      case r'fill_in_the_blanks':
        return CardTemplateType.fillInTheBlanks;
      case r'word_scramble':
        return CardTemplateType.wordScramble;
      case r'match_madness':
        return CardTemplateType.matchMadness;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(CardTemplateType self) {
    switch (self) {
      case CardTemplateType.flashcard:
        return r'flashcard';
      case CardTemplateType.identification:
        return r'identification';
      case CardTemplateType.multipleChoice:
        return r'multiple_choice';
      case CardTemplateType.fillInTheBlanks:
        return r'fill_in_the_blanks';
      case CardTemplateType.wordScramble:
        return r'word_scramble';
      case CardTemplateType.matchMadness:
        return r'match_madness';
    }
  }
}

extension CardTemplateTypeMapperExtension on CardTemplateType {
  String toValue() {
    CardTemplateTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<CardTemplateType>(this) as String;
  }
}

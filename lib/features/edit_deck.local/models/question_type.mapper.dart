// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'question_type.dart';

class QuestionTypeMapper extends EnumMapper<QuestionType> {
  QuestionTypeMapper._();

  static QuestionTypeMapper? _instance;
  static QuestionTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = QuestionTypeMapper._());
    }
    return _instance!;
  }

  static QuestionType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  QuestionType decode(dynamic value) {
    switch (value) {
      case r'flashcard':
        return QuestionType.flashcard;
      case r'identification':
        return QuestionType.identification;
      case r'multiple_choice':
        return QuestionType.multipleChoice;
      case r'fill_in_the_blanks':
        return QuestionType.fillInTheBlanks;
      case r'word_scramble':
        return QuestionType.wordScramble;
      case r'match_madness':
        return QuestionType.matchMadness;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(QuestionType self) {
    switch (self) {
      case QuestionType.flashcard:
        return r'flashcard';
      case QuestionType.identification:
        return r'identification';
      case QuestionType.multipleChoice:
        return r'multiple_choice';
      case QuestionType.fillInTheBlanks:
        return r'fill_in_the_blanks';
      case QuestionType.wordScramble:
        return r'word_scramble';
      case QuestionType.matchMadness:
        return r'match_madness';
    }
  }
}

extension QuestionTypeMapperExtension on QuestionType {
  String toValue() {
    QuestionTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<QuestionType>(this) as String;
  }
}

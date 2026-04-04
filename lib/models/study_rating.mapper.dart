// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'study_rating.dart';

class StudyRatingMapper extends EnumMapper<StudyRating> {
  StudyRatingMapper._();

  static StudyRatingMapper? _instance;
  static StudyRatingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StudyRatingMapper._());
    }
    return _instance!;
  }

  static StudyRating fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  StudyRating decode(dynamic value) {
    switch (value) {
      case r'incorrect':
        return StudyRating.incorrect;
      case r'again':
        return StudyRating.again;
      case r'easy':
        return StudyRating.easy;
      case r'good':
        return StudyRating.good;
      case r'hard':
        return StudyRating.hard;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(StudyRating self) {
    switch (self) {
      case StudyRating.incorrect:
        return r'incorrect';
      case StudyRating.again:
        return r'again';
      case StudyRating.easy:
        return r'easy';
      case StudyRating.good:
        return r'good';
      case StudyRating.hard:
        return r'hard';
    }
  }
}

extension StudyRatingMapperExtension on StudyRating {
  String toValue() {
    StudyRatingMapper.ensureInitialized();
    return MapperContainer.globals.toValue<StudyRating>(this) as String;
  }
}

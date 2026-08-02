// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey.status.dart';

class SurveyStatusMapper extends EnumMapper<SurveyStatus> {
  SurveyStatusMapper._();

  static SurveyStatusMapper? _instance;
  static SurveyStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SurveyStatusMapper._());
    }
    return _instance!;
  }

  static SurveyStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  SurveyStatus decode(dynamic value) {
    switch (value) {
      case r'draft':
        return SurveyStatus.draft;
      case r'published':
        return SurveyStatus.published;
      case r'archived':
        return SurveyStatus.archived;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(SurveyStatus self) {
    switch (self) {
      case SurveyStatus.draft:
        return r'draft';
      case SurveyStatus.published:
        return r'published';
      case SurveyStatus.archived:
        return r'archived';
    }
  }
}

extension SurveyStatusMapperExtension on SurveyStatus {
  String toValue() {
    SurveyStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<SurveyStatus>(this) as String;
  }
}

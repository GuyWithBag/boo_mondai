// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_assignment.status.dart';

class SurveyAssignmentStatusMapper extends EnumMapper<SurveyAssignmentStatus> {
  SurveyAssignmentStatusMapper._();

  static SurveyAssignmentStatusMapper? _instance;
  static SurveyAssignmentStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SurveyAssignmentStatusMapper._());
    }
    return _instance!;
  }

  static SurveyAssignmentStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  SurveyAssignmentStatus decode(dynamic value) {
    switch (value) {
      case r'pending':
        return SurveyAssignmentStatus.pending;
      case r'completed':
        return SurveyAssignmentStatus.completed;
      case r'expired':
        return SurveyAssignmentStatus.expired;
      case r'cancelled':
        return SurveyAssignmentStatus.cancelled;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(SurveyAssignmentStatus self) {
    switch (self) {
      case SurveyAssignmentStatus.pending:
        return r'pending';
      case SurveyAssignmentStatus.completed:
        return r'completed';
      case SurveyAssignmentStatus.expired:
        return r'expired';
      case SurveyAssignmentStatus.cancelled:
        return r'cancelled';
    }
  }
}

extension SurveyAssignmentStatusMapperExtension on SurveyAssignmentStatus {
  String toValue() {
    SurveyAssignmentStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<SurveyAssignmentStatus>(this)
        as String;
  }
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'notification.intent.type.dart';

class NotificationIntentTypeMapper extends EnumMapper<NotificationIntentType> {
  NotificationIntentTypeMapper._();

  static NotificationIntentTypeMapper? _instance;
  static NotificationIntentTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotificationIntentTypeMapper._());
    }
    return _instance!;
  }

  static NotificationIntentType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  NotificationIntentType decode(dynamic value) {
    switch (value) {
      case r'review_reminder':
        return NotificationIntentType.reviewReminder;
      case r'streak_reminder':
        return NotificationIntentType.streakReminder;
      case r'download_complete':
        return NotificationIntentType.downloadComplete;
      case r'sync_complete':
        return NotificationIntentType.syncComplete;
      case r'first_drill_survey':
        return NotificationIntentType.firstDrillSurvey;
      case r'study_deck_review':
        return NotificationIntentType.studyDeckReview;
      case r'researcher_study_session_complete':
        return NotificationIntentType.researcherStudySessionComplete;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(NotificationIntentType self) {
    switch (self) {
      case NotificationIntentType.reviewReminder:
        return r'review_reminder';
      case NotificationIntentType.streakReminder:
        return r'streak_reminder';
      case NotificationIntentType.downloadComplete:
        return r'download_complete';
      case NotificationIntentType.syncComplete:
        return r'sync_complete';
      case NotificationIntentType.firstDrillSurvey:
        return r'first_drill_survey';
      case NotificationIntentType.studyDeckReview:
        return r'study_deck_review';
      case NotificationIntentType.researcherStudySessionComplete:
        return r'researcher_study_session_complete';
    }
  }
}

extension NotificationIntentTypeMapperExtension on NotificationIntentType {
  String toValue() {
    NotificationIntentTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<NotificationIntentType>(this)
        as String;
  }
}


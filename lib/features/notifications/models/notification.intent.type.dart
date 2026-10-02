import 'package:dart_mappable/dart_mappable.dart';

part 'notification.intent.type.mapper.dart';

@MappableEnum()
enum NotificationIntentType {
  reviewReminder,
  streakReminder,
  downloadComplete,
  syncComplete,
  firstDrillSurvey,
  studyDeckReview,
}

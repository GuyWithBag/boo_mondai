import 'package:dart_mappable/dart_mappable.dart';

part 'notification.intent.mapper.dart';

@MappableClass()
class NotificationIntent with NotificationIntentMappable {
  const NotificationIntent({
    required this.id,
    required this.profileId,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    required this.purgeAt,
    this.route,
    this.persistInInbox = false,
    this.showSystemNotification = true,
    this.readAt,
    this.deletedAt,
    this.purgeAfterDays = 30,
  });

  factory NotificationIntent.create({
    required int id,
    required String profileId,
    required NotificationIntentType type,
    required String title,
    required String body,
    String? route,
    bool persistInInbox = false,
    bool showSystemNotification = true,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? readAt,
    DateTime? deletedAt,
    DateTime? purgeAt,
    int purgeAfterDays = 30,
  }) {
    final now = DateTime.now();
    final resolvedCreatedAt = createdAt ?? now;
    return NotificationIntent(
      id: id,
      profileId: profileId,
      type: type,
      title: title,
      body: body,
      route: route,
      persistInInbox: persistInInbox,
      showSystemNotification: showSystemNotification,
      createdAt: resolvedCreatedAt,
      updatedAt: updatedAt ?? now,
      readAt: readAt,
      deletedAt: deletedAt,
      purgeAfterDays: purgeAfterDays,
      purgeAt: purgeAt ?? resolvedCreatedAt.add(Duration(days: purgeAfterDays)),
    );
  }

  final int id;
  final String profileId;
  final NotificationIntentType type;
  final String title;
  final String body;
  final String? route;
  final bool persistInInbox;
  final bool showSystemNotification;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? readAt;
  final DateTime? deletedAt;
  final DateTime purgeAt;
  final int purgeAfterDays;
}

@MappableEnum()
enum NotificationIntentType {
  reviewReminder,
  streakReminder,
  downloadComplete,
  syncComplete,
  firstDrillSurvey,
  studyDeckReview,
}

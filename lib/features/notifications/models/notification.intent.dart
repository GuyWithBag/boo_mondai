class NotificationIntent {
  final int id;
  final NotificationIntentType type;
  final String title;
  final String body;
  final String? route;
  final bool persistInInbox;
  final bool showSystemNotification;

  const NotificationIntent({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.route,
    this.persistInInbox = false,
    this.showSystemNotification = true,
  });
}

enum NotificationIntentType {
  reviewReminder,
  streakReminder,
  downloadComplete,
  syncComplete,
  firstDrillSurvey,
  studyDeckReview,
}

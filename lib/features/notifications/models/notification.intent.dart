import 'notification.recurrence.dart';

class NotificationIntent {
  final int id;
  final String type;
  final String title;
  final String body;
  final String? route;
  final bool persistInInbox;
  final bool showSystemNotification;
  final NotificationRecurrence? recurrence;

  const NotificationIntent({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.route,
    this.persistInInbox = false,
    this.showSystemNotification = true,
    this.recurrence,
  });
}

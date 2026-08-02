import 'notification.recurrence_type.dart';

class NotificationRecurrence {
  final NotificationRecurrenceType type;
  final int hour;
  final int minute;

  const NotificationRecurrence.daily({required this.hour, required this.minute})
    : type = NotificationRecurrenceType.daily;
}

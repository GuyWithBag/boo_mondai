// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/notification_service.dart
// PURPOSE: Schedules local notifications for FSRS review reminders
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:boo_mondai/services/app_exception.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const linuxSettings =
          LinuxInitializationSettings(defaultActionName: 'Open');
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
        linux: linuxSettings,
      );
      await _plugin.initialize(settings: initSettings);
    } catch (e) {
      throw AppException('Failed to initialize notifications: $e');
    }
  }

  Future<void> scheduleReviewReminder(
      DateTime scheduledDate, int dueCount) async {
    try {
      await _plugin.show(
        id: 0,
        title: 'BooMondai Review',
        body: '$dueCount card${dueCount == 1 ? '' : 's'} due for review!',
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'review_reminders',
            'Review Reminders',
            channelDescription: 'FSRS review due notifications',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
        ),
      );
    } catch (e) {
      throw AppException('Failed to schedule notification: $e');
    }
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}

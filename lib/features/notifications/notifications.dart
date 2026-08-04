import 'models/notification.ids.dart';
import 'models/notification.intent.dart';
import 'models/notification.recurrence.dart';

abstract final class Notifications {
  static NotificationIntent reviewReminder({
    NotificationRecurrence? recurrence,
  }) {
    return NotificationIntent(
      id: NotificationIds.reviewReminder,
      type: 'review_reminder',
      title: 'Time to review 🗂️',
      body: 'Your cards are waiting. Keep your streak going!',
      route: '/reviews',
      recurrence: recurrence,
    );
  }

  static NotificationIntent streakReminder({
    NotificationRecurrence? recurrence,
  }) {
    return NotificationIntent(
      id: NotificationIds.streakReminder,
      type: 'streak_reminder',
      title: "Don't break your streak 🔥",
      body: 'A quick review is all it takes to keep it alive.',
      route: '/reviews',
      recurrence: recurrence,
    );
  }

  static NotificationIntent downloadComplete({
    required String deckTitle,
    String? route,
  }) {
    return NotificationIntent(
      id: NotificationIds.downloadComplete,
      type: 'download_complete',
      title: 'Download complete',
      body: deckTitle,
      route: route,
    );
  }

  static NotificationIntent syncComplete() {
    return const NotificationIntent(
      id: NotificationIds.syncComplete,
      type: 'sync_complete',
      title: 'Sync complete',
      body: 'Your decks are up to date.',
    );
  }

  static NotificationIntent firstDrillSurvey({required String surveyId}) {
    return NotificationIntent(
      id: NotificationIds.firstDrillSurvey,
      type: 'first_drill_survey',
      title: 'Quick question',
      body: 'Tell us how your first drill felt.',
      route: '/view-survey/$surveyId',
      persistInInbox: true,
    );
  }
}

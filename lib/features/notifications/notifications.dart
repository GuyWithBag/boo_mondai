import 'models/notification.ids.dart';
import 'models/notification.intent.dart';

abstract final class Notifications {
  static NotificationIntent reviewReminder() {
    return const NotificationIntent(
      id: NotificationIds.reviewReminder,
      type: NotificationIntentType.reviewReminder,
      title: 'Time to review 🗂️',
      body: 'Your cards are waiting. Keep your streak going!',
      route: '/reviews',
    );
  }

  static NotificationIntent streakReminder() {
    return const NotificationIntent(
      id: NotificationIds.streakReminder,
      type: NotificationIntentType.streakReminder,
      title: "Don't break your streak 🔥",
      body: 'A quick review is all it takes to keep it alive.',
      route: '/reviews',
    );
  }

  static NotificationIntent downloadComplete({
    required String deckTitle,
    String? route,
  }) {
    return NotificationIntent(
      id: NotificationIds.downloadComplete,
      type: NotificationIntentType.downloadComplete,
      title: 'Download complete',
      body: deckTitle,
      route: route,
    );
  }

  static NotificationIntent syncComplete() {
    return const NotificationIntent(
      id: NotificationIds.syncComplete,
      type: NotificationIntentType.syncComplete,
      title: 'Sync complete',
      body: 'Your decks are up to date.',
    );
  }

  static NotificationIntent firstDrillSurvey({required String surveyId}) {
    return NotificationIntent(
      id: NotificationIds.firstDrillSurvey,
      type: NotificationIntentType.firstDrillSurvey,
      title: 'Quick question',
      body: 'Tell us how your first drill felt.',
      route: '/view-survey/$surveyId',
      persistInInbox: true,
    );
  }

  static NotificationIntent studyDeckReview({
    required int id,
    required String deckTitle,
    required String body,
  }) {
    return NotificationIntent(
      id: id,
      type: NotificationIntentType.studyDeckReview,
      title: deckTitle,
      body: body,
      route: '/reviews',
    );
  }
}

import 'models/notification.ids.dart';
import 'models/notification.intent.dart';
import 'package:boo_mondai/lib.barrel.dart' show LocalDB;

abstract final class Notifications {
  static String get currentProfileId => LocalDB.currentProfile.getOrCreate().id;

  static NotificationIntent reviewReminder() {
    return NotificationIntent.create(
      id: NotificationIds.reviewReminder,
      profileId: currentProfileId,
      type: NotificationIntentType.reviewReminder,
      title: 'Time to review 🗂️',
      body: 'Your cards are waiting. Keep your streak going!',
      route: '/reviews',
    );
  }

  static NotificationIntent streakReminder() {
    return NotificationIntent.create(
      id: NotificationIds.streakReminder,
      profileId: currentProfileId,
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
    return NotificationIntent.create(
      id: NotificationIds.downloadComplete,
      profileId: currentProfileId,
      type: NotificationIntentType.downloadComplete,
      title: 'Download complete',
      body: deckTitle,
      route: route,
    );
  }

  static NotificationIntent syncComplete() {
    return NotificationIntent.create(
      id: NotificationIds.syncComplete,
      profileId: currentProfileId,
      type: NotificationIntentType.syncComplete,
      title: 'Sync complete',
      body: 'Your decks are up to date.',
    );
  }

  static NotificationIntent firstDrillSurvey({required String surveyId}) {
    return NotificationIntent.create(
      id: NotificationIds.firstDrillSurvey,
      profileId: currentProfileId,
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
    return NotificationIntent.create(
      id: id,
      profileId: currentProfileId,
      type: NotificationIntentType.studyDeckReview,
      title: deckTitle,
      body: body,
      route: '/reviews',
    );
  }
}

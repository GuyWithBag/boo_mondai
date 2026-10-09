import 'models/notification.ids.dart';
import 'models/notification.intent.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show LocalDB, NotificationIntentType;

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

  static NotificationIntent firstDrillSurvey() {
    return NotificationIntent.create(
      id: NotificationIds.firstDrillSurvey,
      profileId: currentProfileId,
      type: NotificationIntentType.firstDrillSurvey,
      title: 'Quick question',
      body: 'Tell us how your first drill felt.',
      ifRouteNullPushToView: true,
      persistInInbox: true,
      showSystemNotification: true,
    );
  }

  static NotificationIntent firstDrillReviewNow() {
    return NotificationIntent.create(
      id: NotificationIds.firstDrillReviewNow,
      profileId: currentProfileId,
      type: NotificationIntentType.firstDrillReviewNow,
      title: 'Review this deck now',
      body:
          'After a drill, press Review Now to start spaced repetition for the cards you just practiced.',
      ifRouteNullPushToView: true,
      persistInInbox: true,
      showAsBubble: true,
      showSystemNotification: false,
    );
  }

  static NotificationIntent firstReviewFsrsScheduling() {
    return NotificationIntent.create(
      id: NotificationIds.firstReviewFsrsScheduling,
      profileId: currentProfileId,
      type: NotificationIntentType.firstReviewFsrsScheduling,
      title: 'Your review schedule is working',
      body:
          'BooMondai uses FSRS to choose when each card should return. Your ratings help it schedule reviews when they are most useful for memory.',
      ifRouteNullPushToView: true,
      persistInInbox: true,
      showAsBubble: true,
      showSystemNotification: false,
    );
  }

  static NotificationIntent drillDeckComplete({
    required int id,
    required String deckTitle,
  }) {
    return NotificationIntent.create(
      id: id,
      profileId: currentProfileId,
      type: NotificationIntentType.drillDeckComplete,
      title: 'Deck drill complete',
      body:
          'You have drilled every new card in $deckTitle. Future cards will appear under Review.',
      ifRouteNullPushToView: true,
      persistInInbox: true,
      showAsBubble: true,
      showSystemNotification: false,
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

  static NotificationIntent researcherStudySessionComplete() {
    return NotificationIntent.create(
      id: NotificationIds.researcherStudySessionComplete,
      profileId: currentProfileId,
      type: NotificationIntentType.researcherStudySessionComplete,
      title: 'Research session complete',
      body: 'A research deck study session was completed.',
      showAsBubble: true,
      persistInInbox: true,
    );
  }
}

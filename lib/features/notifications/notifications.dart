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
      shortDescription: 'Your cards are waiting.',
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
      shortDescription: 'A quick review keeps your streak alive.',
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
      shortDescription: deckTitle,
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
      shortDescription: 'Your decks are up to date.',
      body: 'Your decks are up to date.',
    );
  }

  static NotificationIntent finalDrillBatchSurvey() {
    return NotificationIntent.create(
      id: NotificationIds.finalDrillBatchSurvey,
      profileId: currentProfileId,
      type: NotificationIntentType.finalDrillBatchSurvey,
      title: '[Answer this Immediately] Post Session Survey',
      shortDescription: 'Post Session Survey.',
      body: '''
## Tell us how your drill batches felt.

**Answer this** [Google Form](https://forms.gle/NC9wyM5rSeAkDGxC7). 
This serves as your *first survey (post session)*.

### After completing the form above,
**Answer** your corresponding *pre-test* based on your *language and set*.

- [Japanese Set A](https://forms.gle/5UNnqtHMwUEUMuUB6)
- [Japanese Set B](https://forms.gle/59DnQ1U6NNnjdSph8)
- [Chinese Set A](https://forms.gle/itvFM5tpqxLEP1di7)
- [Chinese Set B](https://forms.gle/14M8aYJS378voR6o9)
''',
      ifRouteNullPushToView: true,
      persistInInbox: true,
      showAsBubble: true,
      showSystemNotification: true,
    );
  }

  static NotificationIntent finalDrillBatchReviewNow() {
    return NotificationIntent.create(
      id: NotificationIds.finalDrillBatchReviewNow,
      profileId: currentProfileId,
      type: NotificationIntentType.finalDrillBatchReviewNow,
      title: 'Review this deck now',
      shortDescription: 'All drill batches are done. Start review next.',
      body:
          'Now that every drill batch is done, press Review Now to start spaced repetition for the cards you just practiced.',
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
      shortDescription: 'FSRS is scheduling cards based on your ratings.',
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
      shortDescription: 'Every new card in $deckTitle has been drilled.',
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
      shortDescription: body,
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
      shortDescription: 'A research deck study session was completed.',
      body: 'A research deck study session was completed.',
      showAsBubble: true,
      persistInInbox: true,
    );
  }
}

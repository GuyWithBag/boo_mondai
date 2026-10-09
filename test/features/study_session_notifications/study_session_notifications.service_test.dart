import 'dart:io';

import 'package:boo_mondai/core/hive/hive_registrar.g.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        FsrsCard,
        LocalDB,
        NotificationIds,
        NotificationIntentType,
        SessionMode,
        StudyCard,
        StudySession,
        StudySessionCardStep,
        StudySessionNotificationsService;
import 'package:flutter_test/flutter_test.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:hive_ce/hive_ce.dart';

void main() {
  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp(
      'boo_mondai_study_session_notifications_test_',
    );
    Hive.init(hiveDirectory.path);
    Hive.registerAdapters();
    await LocalDB.init();
  });

  setUp(() async {
    await LocalDB.clearAll();
    await LocalDB.studyCard.clear();
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  group('StudySessionNotificationsService.showDrillCompletionNotifications', () {
    test(
      'creates final drill batch survey, review, and deck complete notifications',
      () async {
        final profile = LocalDB.currentProfile.getOrCreate();
        final now = DateTime.utc(2026);
        await LocalDB.deck.upsert(
          Deck.createDummy(
            id: 'deck-1',
            profileId: profile.id,
            title: 'Kana Basics',
          ),
        );
        await LocalDB.studyCard.upsert(
          StudyCard(
            id: 'study-1',
            createdAt: now,
            updatedAt: now,
            templateId: 'template-1',
            deckId: 'deck-1',
          ),
        );
        await LocalDB.fsrsCard.upsert(
          FsrsCard(
            id: 'fsrs-1',
            createdAt: now,
            updatedAt: now,
            profileId: profile.id,
            studyCardId: 'study-1',
            state: fsrs.Card(cardId: 1),
          ),
        );

        await StudySessionNotificationsService.showDrillCompletionNotifications(
          StudySession(
            id: 'session-1',
            profileId: profile.id,
            deckId: 'deck-1',
            mode: SessionMode.drill,
            startedAt: now,
            steps: const [
              StudySessionCardStep(id: 'step-1', studyCardId: 'study-1'),
            ],
          ),
        );

        final surveyNotification = LocalDB.notifications.selectByPk({
          'id': NotificationIds.finalDrillBatchSurvey,
        });
        final reviewNotification = LocalDB.notifications.selectByPk({
          'id': NotificationIds.finalDrillBatchReviewNow,
        });
        final deckCompleteNotification = LocalDB.notifications.selectByPk({
          'id': NotificationIds.drillDeckComplete(deckId: 'deck-1'),
        });

        expect(
          surveyNotification?.type,
          NotificationIntentType.finalDrillBatchSurvey,
        );
        expect(surveyNotification?.persistInInbox, isTrue);
        expect(surveyNotification?.ifRouteNullPushToView, isTrue);
        expect(
          reviewNotification?.type,
          NotificationIntentType.finalDrillBatchReviewNow,
        );
        expect(reviewNotification?.persistInInbox, isTrue);
        expect(reviewNotification?.showAsBubble, isTrue);
        expect(reviewNotification?.showSystemNotification, isFalse);
        expect(reviewNotification?.ifRouteNullPushToView, isTrue);
        expect(
          deckCompleteNotification?.type,
          NotificationIntentType.drillDeckComplete,
        );
        expect(deckCompleteNotification?.persistInInbox, isTrue);
        expect(deckCompleteNotification?.showAsBubble, isTrue);
        expect(deckCompleteNotification?.showSystemNotification, isFalse);
        expect(deckCompleteNotification?.ifRouteNullPushToView, isTrue);
      },
    );

    test(
      'does not create final batch notifications while cards remain',
      () async {
        final profile = LocalDB.currentProfile.getOrCreate();
        final now = DateTime.utc(2026);
        await LocalDB.deck.upsert(
          Deck.createDummy(
            id: 'deck-1',
            profileId: profile.id,
            title: 'Kana Basics',
          ),
        );
        await LocalDB.studyCard.upsertMany([
          StudyCard(
            id: 'study-1',
            createdAt: now,
            updatedAt: now,
            templateId: 'template-1',
            deckId: 'deck-1',
          ),
          StudyCard(
            id: 'study-2',
            createdAt: now,
            updatedAt: now,
            templateId: 'template-2',
            deckId: 'deck-1',
          ),
        ]);
        await LocalDB.fsrsCard.upsert(
          FsrsCard(
            id: 'fsrs-1',
            createdAt: now,
            updatedAt: now,
            profileId: profile.id,
            studyCardId: 'study-1',
            state: fsrs.Card(cardId: 1),
          ),
        );

        await StudySessionNotificationsService.showDrillCompletionNotifications(
          StudySession(
            id: 'session-1',
            profileId: profile.id,
            deckId: 'deck-1',
            mode: SessionMode.drill,
            startedAt: now,
            steps: const [
              StudySessionCardStep(id: 'step-1', studyCardId: 'study-1'),
            ],
          ),
        );

        expect(
          LocalDB.notifications.selectByPk({
            'id': NotificationIds.finalDrillBatchSurvey,
          }),
          isNull,
        );
        expect(
          LocalDB.notifications.selectByPk({
            'id': NotificationIds.finalDrillBatchReviewNow,
          }),
          isNull,
        );
        expect(
          LocalDB.notifications.selectByPk({
            'id': NotificationIds.drillDeckComplete(deckId: 'deck-1'),
          }),
          isNull,
        );
      },
    );

    test('does not recreate deleted one-shot notifications', () async {
      final profile = LocalDB.currentProfile.getOrCreate();
      final now = DateTime.utc(2026);
      final deletedAt = DateTime.utc(2026, 2);
      await LocalDB.deck.upsert(
        Deck.createDummy(
          id: 'deck-1',
          profileId: profile.id,
          title: 'Kana Basics',
        ),
      );
      await LocalDB.studyCard.upsert(
        StudyCard(
          id: 'study-1',
          createdAt: now,
          updatedAt: now,
          templateId: 'template-1',
          deckId: 'deck-1',
        ),
      );
      await LocalDB.fsrsCard.upsert(
        FsrsCard(
          id: 'fsrs-1',
          createdAt: now,
          updatedAt: now,
          profileId: profile.id,
          studyCardId: 'study-1',
          state: fsrs.Card(cardId: 1),
        ),
      );
      final session = StudySession(
        id: 'session-1',
        profileId: profile.id,
        deckId: 'deck-1',
        mode: SessionMode.drill,
        startedAt: now,
        steps: const [
          StudySessionCardStep(id: 'step-1', studyCardId: 'study-1'),
        ],
      );

      await StudySessionNotificationsService.showDrillCompletionNotifications(
        session,
      );
      final surveyNotification = LocalDB.notifications.selectByPk({
        'id': NotificationIds.finalDrillBatchSurvey,
      })!;
      final reviewNotification = LocalDB.notifications.selectByPk({
        'id': NotificationIds.finalDrillBatchReviewNow,
      })!;
      final deckCompleteNotification = LocalDB.notifications.selectByPk({
        'id': NotificationIds.drillDeckComplete(deckId: 'deck-1'),
      })!;
      await LocalDB.notifications.upsert(
        surveyNotification.copyWith(deletedAt: deletedAt),
      );
      await LocalDB.notifications.upsert(
        reviewNotification.copyWith(deletedAt: deletedAt),
      );
      await LocalDB.notifications.upsert(
        deckCompleteNotification.copyWith(deletedAt: deletedAt),
      );

      await StudySessionNotificationsService.showDrillCompletionNotifications(
        session,
      );

      expect(
        LocalDB.notifications.selectByPk({
          'id': NotificationIds.finalDrillBatchSurvey,
        }, includeDeleted: true)?.deletedAt,
        deletedAt,
      );
      expect(
        LocalDB.notifications.selectByPk({
          'id': NotificationIds.finalDrillBatchReviewNow,
        }, includeDeleted: true)?.deletedAt,
        deletedAt,
      );
      expect(
        LocalDB.notifications.selectByPk({
          'id': NotificationIds.drillDeckComplete(deckId: 'deck-1'),
        }, includeDeleted: true)?.deletedAt,
        deletedAt,
      );
    });
  });

  group('StudySessionNotificationsService.showReviewCompletionNotifications', () {
    test(
      'creates first review FSRS scheduling inbox bubble notification',
      () async {
        final profile = LocalDB.currentProfile.getOrCreate();
        final now = DateTime.utc(2026);

        await StudySessionNotificationsService.showReviewCompletionNotifications(
          StudySession(
            id: 'session-1',
            profileId: profile.id,
            deckId: 'deck-1',
            mode: SessionMode.review,
            startedAt: now,
            steps: const [
              StudySessionCardStep(id: 'step-1', studyCardId: 'study-1'),
            ],
          ),
        );

        final notification = LocalDB.notifications.selectByPk({
          'id': NotificationIds.firstReviewFsrsScheduling,
        });

        expect(
          notification?.type,
          NotificationIntentType.firstReviewFsrsScheduling,
        );
        expect(notification?.persistInInbox, isTrue);
        expect(notification?.showAsBubble, isTrue);
        expect(notification?.showSystemNotification, isFalse);
        expect(notification?.ifRouteNullPushToView, isTrue);
      },
    );

    test('does not recreate deleted review FSRS notification', () async {
      final profile = LocalDB.currentProfile.getOrCreate();
      final now = DateTime.utc(2026);
      final deletedAt = DateTime.utc(2026, 2);
      final session = StudySession(
        id: 'session-1',
        profileId: profile.id,
        deckId: 'deck-1',
        mode: SessionMode.review,
        startedAt: now,
        steps: const [
          StudySessionCardStep(id: 'step-1', studyCardId: 'study-1'),
        ],
      );

      await StudySessionNotificationsService.showReviewCompletionNotifications(
        session,
      );
      final notification = LocalDB.notifications.selectByPk({
        'id': NotificationIds.firstReviewFsrsScheduling,
      })!;
      await LocalDB.notifications.upsert(
        notification.copyWith(deletedAt: deletedAt),
      );

      await StudySessionNotificationsService.showReviewCompletionNotifications(
        session,
      );

      expect(
        LocalDB.notifications.selectByPk({
          'id': NotificationIds.firstReviewFsrsScheduling,
        }, includeDeleted: true)?.deletedAt,
        deletedAt,
      );
    });
  });
}

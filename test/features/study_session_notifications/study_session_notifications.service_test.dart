import 'dart:io';

import 'package:boo_mondai/core/hive/hive_registrar.g.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        FsrsCard,
        LocalDB,
        NotificationIds,
        NotificationIntentType,
        SettingPath,
        SettingsStore,
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
    await SettingsStore.instance.init();
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
        expect(
          SettingsStore.instance.get<bool>(
            SettingPath.finalDrillBatchSurveyShown,
          ),
          isTrue,
        );
        expect(
          SettingsStore.instance.get<bool>(
            SettingPath.finalDrillBatchReviewNowShown,
          ),
          isTrue,
        );
        expect(
          SettingsStore.instance.get<bool>(SettingPath.drillDeckCompleteShown),
          isTrue,
        );
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

    test(
      'does not recreate one-shot notifications when settings are enabled',
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
        await LocalDB.notifications.clear();

        await StudySessionNotificationsService.showDrillCompletionNotifications(
          session,
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
  });

  group('StudySessionNotificationsService.showReviewStartNotifications', () {
    test('creates first review warning notification', () async {
      await StudySessionNotificationsService.showReviewStartNotifications(
        mode: SessionMode.review,
      );

      final notification = LocalDB.notifications.selectByPk({
        'id': NotificationIds.reviewFsrsWarning,
      });

      expect(notification?.type, NotificationIntentType.reviewFsrsWarning);
      expect(notification?.persistInInbox, isTrue);
      expect(notification?.showAsBubble, isTrue);
      expect(notification?.showSystemNotification, isFalse);
      expect(notification?.ifRouteNullPushToView, isTrue);
      expect(
        SettingsStore.instance.get<bool>(SettingPath.reviewFsrsWarningShown),
        isTrue,
      );
    });

    test('does not recreate review warning when setting is enabled', () async {
      await StudySessionNotificationsService.showReviewStartNotifications(
        mode: SessionMode.review,
      );
      await LocalDB.notifications.clear();

      await StudySessionNotificationsService.showReviewStartNotifications(
        mode: SessionMode.review,
      );

      expect(
        LocalDB.notifications.selectByPk({
          'id': NotificationIds.reviewFsrsWarning,
        }),
        isNull,
      );
    });

    test('recreates review warning after setting is turned off', () async {
      await StudySessionNotificationsService.showReviewStartNotifications(
        mode: SessionMode.review,
      );
      await LocalDB.notifications.clear();
      await SettingsStore.instance.set<bool>(
        SettingPath.reviewFsrsWarningShown,
        false,
      );

      await StudySessionNotificationsService.showReviewStartNotifications(
        mode: SessionMode.review,
      );

      expect(
        LocalDB.notifications.selectByPk({
          'id': NotificationIds.reviewFsrsWarning,
        })?.type,
        NotificationIntentType.reviewFsrsWarning,
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
        expect(
          SettingsStore.instance.get<bool>(
            SettingPath.firstReviewFsrsSchedulingShown,
          ),
          isTrue,
        );
      },
    );

    test(
      'does not recreate review FSRS notification when setting is enabled',
      () async {
        final profile = LocalDB.currentProfile.getOrCreate();
        final now = DateTime.utc(2026);
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
        await LocalDB.notifications.clear();

        await StudySessionNotificationsService.showReviewCompletionNotifications(
          session,
        );

        expect(
          LocalDB.notifications.selectByPk({
            'id': NotificationIds.firstReviewFsrsScheduling,
          }),
          isNull,
        );
      },
    );
  });
}

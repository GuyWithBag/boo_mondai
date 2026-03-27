// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/services/hive_service_test.dart
// PURPOSE: Unit tests for HiveService using a temp directory for Hive storage
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/services/services.dart';

void main() {
  late HiveService hiveService;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);
    hiveService = HiveService();
    await hiveService.init();
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('Profile', () {
    test('save and get profile round-trip preserves all fields', () async {
      final profile = UserProfile(
        id: 'user-1',
        email: 'alice@test.com',
        displayName: 'Alice',
        role: 'group_a_participant',
        avatarUrl: null,
        targetLanguage: 'japanese',
        createdAt: DateTime(2026, 1, 1),
      );

      await hiveService.saveProfile(profile);
      final retrieved = hiveService.getProfile();

      expect(retrieved, isNotNull);
      expect(retrieved!.id, profile.id);
      expect(retrieved.email, profile.email);
      expect(retrieved.displayName, profile.displayName);
      expect(retrieved.role, profile.role);
      expect(retrieved.avatarUrl, profile.avatarUrl);
      expect(retrieved.targetLanguage, profile.targetLanguage);
      expect(retrieved.createdAt, profile.createdAt);
    });

    test('getProfile returns null when no profile saved', () {
      final result = hiveService.getProfile();
      expect(result, isNull);
    });

    test('save profile overwrites previous profile', () async {
      final profileA = UserProfile(
        id: 'user-1',
        email: 'alice@test.com',
        displayName: 'Alice',
        role: 'group_a_participant',
        createdAt: DateTime(2026, 1, 1),
      );
      final profileB = UserProfile(
        id: 'user-2',
        email: 'bob@test.com',
        displayName: 'Bob',
        role: 'group_a_participant',
        createdAt: DateTime(2026, 1, 2),
      );

      await hiveService.saveProfile(profileA);
      await hiveService.saveProfile(profileB);

      final retrieved = hiveService.getProfile();
      expect(retrieved!.id, 'user-2');
      expect(retrieved.displayName, 'Bob');
    });
  });

  group('Decks', () {
    test('save and get decks round-trip preserves all fields', () async {
      final decks = [
        Deck(
          id: 'deck-1',
          creatorId: 'user-1',
          title: 'JLPT N5',
          description: 'Basic vocab',
          targetLanguage: 'japanese',
          isPremade: true,
          isPublic: true,
          cardCount: 5,
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
        Deck(
          id: 'deck-2',
          creatorId: 'user-2',
          title: 'My Vocab',
          description: 'Custom deck',
          targetLanguage: 'japanese',
          isPremade: false,
          isPublic: true,
          cardCount: 2,
          createdAt: DateTime(2026, 1, 2),
          updatedAt: DateTime(2026, 1, 2),
        ),
      ];

      await hiveService.saveDecks(decks);
      final retrieved = hiveService.getDecks();

      expect(retrieved.length, 2);
      expect(retrieved.any((d) => d.id == 'deck-1'), true);
      expect(retrieved.any((d) => d.id == 'deck-2'), true);
    });

    test('saveDecks clears previous data before saving', () async {
      final firstBatch = [
        Deck(
          id: 'deck-1',
          creatorId: 'user-1',
          title: 'First',
          description: '',
          targetLanguage: 'japanese',
          isPremade: false,
          isPublic: true,
          cardCount: 0,
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
      ];
      final secondBatch = [
        Deck(
          id: 'deck-2',
          creatorId: 'user-1',
          title: 'Second',
          description: '',
          targetLanguage: 'japanese',
          isPremade: false,
          isPublic: true,
          cardCount: 0,
          createdAt: DateTime(2026, 1, 2),
          updatedAt: DateTime(2026, 1, 2),
        ),
      ];

      await hiveService.saveDecks(firstBatch);
      await hiveService.saveDecks(secondBatch);

      final retrieved = hiveService.getDecks();
      expect(retrieved.length, 1);
      expect(retrieved.first.id, 'deck-2');
    });

    test('getDecks returns empty list when no decks saved', () {
      final result = hiveService.getDecks();
      expect(result, isEmpty);
    });
  });

  group('Cards', () {
    test('save and get cards round-trip for a specific deck', () async {
      final cards = [
        DeckCard(
          id: 'card-1',
          deckId: 'deck-1',
          question: '犬',
          answer: 'dog, いぬ, inu',
          sortOrder: 0,
          createdAt: DateTime(2026, 1, 1),
        ),
        DeckCard(
          id: 'card-2',
          deckId: 'deck-1',
          question: '猫',
          answer: 'cat, ねこ, neko',
          sortOrder: 1,
          createdAt: DateTime(2026, 1, 1),
        ),
      ];

      await hiveService.saveCards('deck-1', cards);
      final retrieved = hiveService.getCards('deck-1');

      expect(retrieved.length, 2);
      expect(retrieved[0].sortOrder, lessThanOrEqualTo(retrieved[1].sortOrder));
    });

    test('getCards filters by deckId', () async {
      final cardsA = [
        DeckCard(
          id: 'card-a1',
          deckId: 'deck-a',
          question: 'Q1',
          answer: 'A1',
          sortOrder: 0,
          createdAt: DateTime(2026, 1, 1),
        ),
      ];
      final cardsB = [
        DeckCard(
          id: 'card-b1',
          deckId: 'deck-b',
          question: 'Q2',
          answer: 'A2',
          sortOrder: 0,
          createdAt: DateTime(2026, 1, 1),
        ),
      ];

      await hiveService.saveCards('deck-a', cardsA);
      await hiveService.saveCards('deck-b', cardsB);

      final retrievedA = hiveService.getCards('deck-a');
      final retrievedB = hiveService.getCards('deck-b');

      expect(retrievedA.length, 1);
      expect(retrievedA.first.id, 'card-a1');
      expect(retrievedB.length, 1);
      expect(retrievedB.first.id, 'card-b1');
    });

    test('getCards returns sorted by sortOrder', () async {
      final cards = [
        DeckCard(
          id: 'card-3',
          deckId: 'deck-1',
          question: 'Q3',
          answer: 'A3',
          sortOrder: 2,
          createdAt: DateTime(2026, 1, 1),
        ),
        DeckCard(
          id: 'card-1',
          deckId: 'deck-1',
          question: 'Q1',
          answer: 'A1',
          sortOrder: 0,
          createdAt: DateTime(2026, 1, 1),
        ),
        DeckCard(
          id: 'card-2',
          deckId: 'deck-1',
          question: 'Q2',
          answer: 'A2',
          sortOrder: 1,
          createdAt: DateTime(2026, 1, 1),
        ),
      ];

      await hiveService.saveCards('deck-1', cards);
      final retrieved = hiveService.getCards('deck-1');

      expect(retrieved[0].id, 'card-1');
      expect(retrieved[1].id, 'card-2');
      expect(retrieved[2].id, 'card-3');
    });
  });

  group('FSRS Cards', () {
    test('save and get FsrsCardState round-trip', () async {
      final state = FsrsCardState(
        id: 'user-1_card-1',
        userId: 'user-1',
        cardId: 'card-1',
        due: DateTime(2026, 3, 26),
        stability: 1.5,
        difficulty: 5.0,
        elapsedDays: 0,
        scheduledDays: 1,
        reps: 1,
        lapses: 0,
        state: 1,
        lastReview: DateTime(2026, 3, 25),
      );

      await hiveService.saveFsrsCard(state);
      final retrieved = hiveService.getFsrsCard('user-1_card-1');

      expect(retrieved, isNotNull);
      expect(retrieved!.userId, 'user-1');
      expect(retrieved.cardId, 'card-1');
      expect(retrieved.stability, 1.5);
      expect(retrieved.difficulty, 5.0);
      expect(retrieved.reps, 1);
    });

    test('getFsrsCard returns null for non-existent key', () {
      final result = hiveService.getFsrsCard('nonexistent');
      expect(result, isNull);
    });

    test('getDueCards filters by userId and due date', () async {
      final now = DateTime(2026, 3, 26, 12, 0);
      final past = DateTime(2026, 3, 25);
      final future = DateTime(2026, 3, 27);

      // Due card (past due)
      await hiveService.saveFsrsCard(FsrsCardState(
        id: 'user-1_card-1',
        userId: 'user-1',
        cardId: 'card-1',
        due: past,
        stability: 1.0,
        difficulty: 5.0,
        elapsedDays: 0,
        scheduledDays: 1,
        reps: 1,
        lapses: 0,
        state: 1,
      ));

      // Due card (exactly now)
      await hiveService.saveFsrsCard(FsrsCardState(
        id: 'user-1_card-2',
        userId: 'user-1',
        cardId: 'card-2',
        due: now,
        stability: 1.0,
        difficulty: 5.0,
        elapsedDays: 0,
        scheduledDays: 1,
        reps: 1,
        lapses: 0,
        state: 1,
      ));

      // Not due yet (future)
      await hiveService.saveFsrsCard(FsrsCardState(
        id: 'user-1_card-3',
        userId: 'user-1',
        cardId: 'card-3',
        due: future,
        stability: 1.0,
        difficulty: 5.0,
        elapsedDays: 0,
        scheduledDays: 1,
        reps: 1,
        lapses: 0,
        state: 1,
      ));

      // Different user (due but wrong userId)
      await hiveService.saveFsrsCard(FsrsCardState(
        id: 'user-2_card-4',
        userId: 'user-2',
        cardId: 'card-4',
        due: past,
        stability: 1.0,
        difficulty: 5.0,
        elapsedDays: 0,
        scheduledDays: 1,
        reps: 1,
        lapses: 0,
        state: 1,
      ));

      final dueCards = hiveService.getDueCards('user-1', now);

      expect(dueCards.length, 2);
      expect(dueCards.any((c) => c.cardId == 'card-1'), true);
      expect(dueCards.any((c) => c.cardId == 'card-2'), true);
      expect(dueCards.any((c) => c.cardId == 'card-3'), false);
      expect(dueCards.any((c) => c.cardId == 'card-4'), false);
    });

    test('getAllFsrsCards filters by userId', () async {
      await hiveService.saveFsrsCard(FsrsCardState(
        id: 'user-1_card-1',
        userId: 'user-1',
        cardId: 'card-1',
        due: DateTime(2026, 3, 26),
        stability: 1.0,
        difficulty: 5.0,
        elapsedDays: 0,
        scheduledDays: 1,
        reps: 1,
        lapses: 0,
        state: 1,
      ));
      await hiveService.saveFsrsCard(FsrsCardState(
        id: 'user-2_card-2',
        userId: 'user-2',
        cardId: 'card-2',
        due: DateTime(2026, 3, 26),
        stability: 1.0,
        difficulty: 5.0,
        elapsedDays: 0,
        scheduledDays: 1,
        reps: 1,
        lapses: 0,
        state: 1,
      ));

      final user1Cards = hiveService.getAllFsrsCards('user-1');
      expect(user1Cards.length, 1);
      expect(user1Cards.first.userId, 'user-1');
    });
  });

  group('Review Logs', () {
    test('saveReviewLog stores a review log entry', () async {
      final log = ReviewLogEntry(
        id: 'log-1',
        userId: 'user-1',
        cardId: 'card-1',
        rating: 3,
        scheduledDays: 1,
        elapsedDays: 0,
        review: DateTime(2026, 3, 26),
        state: 1,
      );

      // Should not throw
      await hiveService.saveReviewLog(log);
    });
  });

  group('Streaks', () {
    test('save and get streak round-trip', () async {
      final streak = Streak(
        id: 'streak-1',
        userId: 'user-1',
        currentStreak: 5,
        longestStreak: 12,
        lastActivityDate: DateTime(2026, 3, 25),
      );

      await hiveService.saveStreak(streak);
      final retrieved = hiveService.getStreak('user-1');

      expect(retrieved, isNotNull);
      expect(retrieved!.currentStreak, 5);
      expect(retrieved.longestStreak, 12);
      expect(retrieved.userId, 'user-1');
    });

    test('getStreak returns null for non-existent userId', () {
      final result = hiveService.getStreak('nonexistent');
      expect(result, isNull);
    });
  });

  group('Settings', () {
    test('getNotificationHour returns default 9 when not set', () {
      final hour = hiveService.getNotificationHour();
      expect(hour, 9);
    });

    test('setNotificationHour and getNotificationHour round-trip', () async {
      await hiveService.setNotificationHour(14);
      final hour = hiveService.getNotificationHour();
      expect(hour, 14);
    });

    test('setNotificationHour overwrites previous value', () async {
      await hiveService.setNotificationHour(7);
      await hiveService.setNotificationHour(20);
      expect(hiveService.getNotificationHour(), 20);
    });
  });

  group('clearAll', () {
    test('empties all boxes', () async {
      // Populate some data
      await hiveService.saveProfile(UserProfile(
        id: 'user-1',
        email: 'test@test.com',
        displayName: 'Test',
        role: 'group_a_participant',
        createdAt: DateTime(2026, 1, 1),
      ));
      await hiveService.saveDecks([
        Deck(
          id: 'deck-1',
          creatorId: 'user-1',
          title: 'Test',
          description: '',
          targetLanguage: 'japanese',
          isPremade: false,
          isPublic: true,
          cardCount: 0,
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
      ]);
      await hiveService.saveFsrsCard(FsrsCardState(
        id: 'user-1_card-1',
        userId: 'user-1',
        cardId: 'card-1',
        due: DateTime(2026, 3, 26),
        stability: 1.0,
        difficulty: 5.0,
        elapsedDays: 0,
        scheduledDays: 1,
        reps: 1,
        lapses: 0,
        state: 1,
      ));
      await hiveService.saveStreak(Streak(
        id: 'streak-1',
        userId: 'user-1',
        currentStreak: 3,
        longestStreak: 5,
      ));
      await hiveService.setNotificationHour(15);

      // Clear
      await hiveService.clearAll();

      // Verify everything is empty
      expect(hiveService.getProfile(), isNull);
      expect(hiveService.getDecks(), isEmpty);
      expect(hiveService.getFsrsCard('user-1_card-1'), isNull);
      expect(hiveService.getAllFsrsCards('user-1'), isEmpty);
      expect(hiveService.getStreak('user-1'), isNull);
      expect(hiveService.getNotificationHour(), 9); // back to default
    });
  });
}

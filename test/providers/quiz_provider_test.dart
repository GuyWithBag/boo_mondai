// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/providers/quiz_provider_test.dart
// PURPOSE: Unit tests for QuizProvider — session lifecycle, answer checking, self-rating, FSRS enrollment
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/mock_supabase_service.mocks.dart';
import '../helpers/mock_hive_service.mocks.dart';
import '../helpers/mock_fsrs_service.mocks.dart';
import '../helpers/fake_deck_card.dart';
import '../helpers/fake_fsrs_card_state.dart';
import 'package:boo_mondai/controllers/controllers.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/services/services.dart';

void main() {
  late QuizProvider provider;
  late MockSupabaseService mockSupabase;
  late MockHiveService mockHive;
  late MockFsrsService mockFsrs;
  late QuizQueueController queueController;

  const userId = '00000000-0000-0000-0000-000000000002';
  const deckId = '00000000-0000-0000-0000-000000000010';

  setUp(() {
    mockSupabase = MockSupabaseService();
    mockHive = MockHiveService();
    mockFsrs = MockFsrsService();
    queueController = QuizQueueController();
    provider = QuizProvider(
      supabaseService: mockSupabase,
      hiveService: mockHive,
      fsrsService: mockFsrs,
      queueController: queueController,
    );
  });

  group('initial state', () {
    test('has no session and is not complete', () {
      expect(provider.session, isNull);
      expect(provider.currentCard, isNull);
      expect(provider.answers, isEmpty);
      expect(provider.isComplete, false);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
      expect(provider.awaitingRating, false);
    });
  });

  group('startSession', () {
    test('creates session and sets currentCard', () async {
      final cards = fakeDeckCardList(count: 3);
      final sessionJson = {
        'id': 'session-1',
        'user_id': userId,
        'deck_id': deckId,
        'previewed': true,
        'total_questions': 3,
        'correct_count': 0,
        'started_at': DateTime.now().toIso8601String(),
      };

      when(mockSupabase.insertQuizSession(any))
          .thenAnswer((_) async => sessionJson);

      await provider.startSession(deckId, userId, cards, true);

      expect(provider.session, isNotNull);
      expect(provider.session!.id, 'session-1');
      expect(provider.currentCard, isNotNull);
      expect(provider.isLoading, false);
      expect(provider.queueLength, 2); // 3 - 1 dequeued
    });

    test('failure sets error', () async {
      when(mockSupabase.insertQuizSession(any))
          .thenThrow(const AppException('Insert failed'));

      await provider.startSession(deckId, userId, fakeDeckCardList(), true);

      expect(provider.error, 'Insert failed');
      expect(provider.session, isNull);
    });
  });

  group('submitAnswer', () {
    Future<void> startWithCards() async {
      final cards = [
        fakeDeckCard(id: 'c1', question: '犬', answer: 'dog, いぬ, inu'),
        fakeDeckCard(id: 'c2', question: '猫', answer: 'cat, ねこ, neko'),
      ];
      final sessionJson = {
        'id': 'session-1',
        'user_id': userId,
        'deck_id': deckId,
        'previewed': false,
        'total_questions': 2,
        'correct_count': 0,
        'started_at': DateTime.now().toIso8601String(),
      };
      when(mockSupabase.insertQuizSession(any))
          .thenAnswer((_) async => sessionJson);
      await provider.startSession(deckId, userId, cards, false);
    }

    test('incorrect answer requeues card and advances to next', () async {
      await startWithCards();
      final cardBeforeAnswer = provider.currentCard;

      provider.submitAnswer('wrong answer');

      // Card should change (dequeued next one), and the wrong card is requeued
      expect(provider.awaitingRating, false);
      expect(provider.currentCard, isNotNull);
      expect(provider.currentCard!.id, isNot(cardBeforeAnswer!.id));
    });

    test('correct answer sets awaitingRating to true', () async {
      await startWithCards();

      // The first card is c1 with answer 'dog, いぬ, inu'
      provider.submitAnswer('dog');

      expect(provider.awaitingRating, true);
    });

    test('answer matching is case-insensitive', () async {
      await startWithCards();

      provider.submitAnswer('DOG');

      expect(provider.awaitingRating, true);
    });

    test('answer matching trims whitespace', () async {
      await startWithCards();

      provider.submitAnswer('  dog  ');

      expect(provider.awaitingRating, true);
    });

    test('accepts any comma-separated alternative', () async {
      await startWithCards();

      provider.submitAnswer('いぬ');

      expect(provider.awaitingRating, true);
    });
  });

  group('submitSelfRating', () {
    Future<void> startAndAnswerCorrectly() async {
      final cards = [
        fakeDeckCard(id: 'c1', question: '犬', answer: 'dog'),
        fakeDeckCard(id: 'c2', question: '猫', answer: 'cat'),
      ];
      final sessionJson = {
        'id': 'session-1',
        'user_id': userId,
        'deck_id': deckId,
        'previewed': false,
        'total_questions': 2,
        'correct_count': 0,
        'started_at': DateTime.now().toIso8601String(),
      };
      when(mockSupabase.insertQuizSession(any))
          .thenAnswer((_) async => sessionJson);
      when(mockSupabase.insertQuizAnswer(any))
          .thenAnswer((_) async {});
      when(mockSupabase.updateQuizSession(any, any))
          .thenAnswer((_) async {});
      when(mockFsrs.enrollCard(any, any, any))
          .thenReturn(fakeFsrsCardState());
      when(mockHive.saveFsrsCard(any)).thenAnswer((_) async {});
      when(mockSupabase.upsertFsrsCard(any)).thenAnswer((_) async {});

      await provider.startSession(deckId, userId, cards, false);
      provider.submitAnswer('dog');
    }

    test('Again (1) requeues card', () async {
      await startAndAnswerCorrectly();
      expect(provider.awaitingRating, true);

      await provider.submitSelfRating(1);

      expect(provider.awaitingRating, false);
      expect(provider.answers, isEmpty); // not saved
      expect(provider.isComplete, false);
    });

    test('Good (3) saves answer and advances queue', () async {
      await startAndAnswerCorrectly();

      await provider.submitSelfRating(3);

      expect(provider.awaitingRating, false);
      expect(provider.answers.length, 1);
      expect(provider.answers.first.selfRating, 3);
      verify(mockSupabase.insertQuizAnswer(any)).called(1);
    });

    test('completes session when queue is empty', () async {
      // Single card session
      final cards = [
        fakeDeckCard(id: 'c1', question: '犬', answer: 'dog'),
      ];
      final sessionJson = {
        'id': 'session-1',
        'user_id': userId,
        'deck_id': deckId,
        'previewed': false,
        'total_questions': 1,
        'correct_count': 0,
        'started_at': DateTime.now().toIso8601String(),
      };
      when(mockSupabase.insertQuizSession(any))
          .thenAnswer((_) async => sessionJson);
      when(mockSupabase.insertQuizAnswer(any))
          .thenAnswer((_) async {});
      when(mockSupabase.updateQuizSession(any, any))
          .thenAnswer((_) async {});
      when(mockFsrs.enrollCard(any, any, any))
          .thenReturn(fakeFsrsCardState());
      when(mockHive.saveFsrsCard(any)).thenAnswer((_) async {});
      when(mockSupabase.upsertFsrsCard(any)).thenAnswer((_) async {});

      await provider.startSession(deckId, userId, cards, false);
      provider.submitAnswer('dog');
      await provider.submitSelfRating(3);

      expect(provider.isComplete, true);
      verify(mockSupabase.updateQuizSession(any, any)).called(1);
    });

    test('FSRS enrollment happens on session completion for rated cards', () async {
      final cards = [
        fakeDeckCard(id: 'c1', question: '犬', answer: 'dog'),
      ];
      final sessionJson = {
        'id': 'session-1',
        'user_id': userId,
        'deck_id': deckId,
        'previewed': false,
        'total_questions': 1,
        'correct_count': 0,
        'started_at': DateTime.now().toIso8601String(),
      };
      when(mockSupabase.insertQuizSession(any))
          .thenAnswer((_) async => sessionJson);
      when(mockSupabase.insertQuizAnswer(any))
          .thenAnswer((_) async {});
      when(mockSupabase.updateQuizSession(any, any))
          .thenAnswer((_) async {});
      when(mockFsrs.enrollCard(any, any, any))
          .thenReturn(fakeFsrsCardState());
      when(mockHive.saveFsrsCard(any)).thenAnswer((_) async {});
      when(mockSupabase.upsertFsrsCard(any)).thenAnswer((_) async {});

      await provider.startSession(deckId, userId, cards, false);
      provider.submitAnswer('dog');
      await provider.submitSelfRating(4); // Easy

      verify(mockFsrs.enrollCard(userId, 'c1', 4)).called(1);
      verify(mockHive.saveFsrsCard(any)).called(1);
      verify(mockSupabase.upsertFsrsCard(any)).called(1);
    });
  });

  group('reset', () {
    test('clears all state', () async {
      final cards = [fakeDeckCard(id: 'c1', answer: 'dog')];
      final sessionJson = {
        'id': 's1',
        'user_id': userId,
        'deck_id': deckId,
        'previewed': false,
        'total_questions': 1,
        'correct_count': 0,
        'started_at': DateTime.now().toIso8601String(),
      };
      when(mockSupabase.insertQuizSession(any))
          .thenAnswer((_) async => sessionJson);
      await provider.startSession(deckId, userId, cards, false);

      provider.reset();

      expect(provider.session, isNull);
      expect(provider.currentCard, isNull);
      expect(provider.answers, isEmpty);
      expect(provider.isComplete, false);
      expect(provider.awaitingRating, false);
      expect(provider.error, isNull);
    });
  });
}

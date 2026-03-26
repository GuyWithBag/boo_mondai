// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/providers/fsrs_provider_test.dart
// PURPOSE: Unit tests for FsrsProvider — due card fetching, review submission, index advancement
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:boo_mondai/providers/fsrs_provider.dart';
import 'package:boo_mondai/services/app_exception.dart';

import '../helpers/mock_supabase_service.mocks.dart';
import '../helpers/mock_hive_service.mocks.dart';
import '../helpers/mock_fsrs_service.mocks.dart';
import '../helpers/fake_fsrs_card_state.dart';
import '../helpers/fake_deck_card.dart';

void main() {
  late FsrsProvider provider;
  late MockFsrsService mockFsrs;
  late MockHiveService mockHive;
  late MockSupabaseService mockSupabase;

  const userId = '00000000-0000-0000-0000-000000000002';

  setUp(() {
    mockFsrs = MockFsrsService();
    mockHive = MockHiveService();
    mockSupabase = MockSupabaseService();
    provider = FsrsProvider(
      fsrsService: mockFsrs,
      hiveService: mockHive,
      supabaseService: mockSupabase,
    );
  });

  group('initial state', () {
    test('has empty due cards and no error', () {
      expect(provider.dueCards, isEmpty);
      expect(provider.dueCount, 0);
      expect(provider.currentReviewCard, isNull);
      expect(provider.currentDeckCard, isNull);
      expect(provider.isReviewComplete, true);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
    });
  });

  group('fetchDueCards', () {
    test('with due cards populates list', () async {
      final dueCard = fakeFsrsCardState(
        cardId: '00000000-0000-0000-0000-000000000020',
        due: DateTime.now().subtract(const Duration(hours: 1)),
      );
      final deckCards = fakeDeckCardList(count: 3);

      when(mockHive.getDueCards(userId, any)).thenReturn([dueCard]);
      when(mockHive.getCards('')).thenReturn(deckCards);

      await provider.fetchDueCards(userId);

      expect(provider.dueCards.length, 1);
      expect(provider.dueCount, 1);
      expect(provider.currentReviewCard, isNotNull);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
    });

    test('with no due cards results in empty list', () async {
      when(mockHive.getDueCards(userId, any)).thenReturn([]);

      await provider.fetchDueCards(userId);

      expect(provider.dueCards, isEmpty);
      expect(provider.dueCount, 0);
      expect(provider.currentReviewCard, isNull);
      expect(provider.isReviewComplete, true);
    });

    test('failure sets error', () async {
      when(mockHive.getDueCards(userId, any))
          .thenThrow(const AppException('Hive error'));

      await provider.fetchDueCards(userId);

      expect(provider.error, 'Hive error');
    });
  });

  group('startReview', () {
    test('resets index to 0', () async {
      final dueCard = fakeFsrsCardState(
        due: DateTime.now().subtract(const Duration(hours: 1)),
      );
      when(mockHive.getDueCards(userId, any)).thenReturn([dueCard]);
      when(mockHive.getCards('')).thenReturn(fakeDeckCardList());
      await provider.fetchDueCards(userId);

      provider.startReview();

      expect(provider.currentReviewCard, isNotNull);
      expect(provider.isReviewComplete, false);
    });
  });

  group('submitReview', () {
    test('updates card, logs review, and advances index', () async {
      final dueCard = fakeFsrsCardState(
        cardId: '00000000-0000-0000-0000-000000000020',
        due: DateTime.now().subtract(const Duration(hours: 1)),
      );
      final updatedState = fakeFsrsCardState(
        cardId: '00000000-0000-0000-0000-000000000020',
        due: DateTime.now().add(const Duration(days: 1)),
      );
      final deckCards = fakeDeckCardList(count: 3);

      when(mockHive.getDueCards(userId, any)).thenReturn([dueCard]);
      when(mockHive.getCards('')).thenReturn(deckCards);
      await provider.fetchDueCards(userId);

      when(mockFsrs.reviewCard(dueCard, 3)).thenReturn(updatedState);
      when(mockHive.saveFsrsCard(any)).thenAnswer((_) async {});
      when(mockHive.saveReviewLog(any)).thenAnswer((_) async {});
      when(mockSupabase.upsertFsrsCard(any)).thenAnswer((_) async {});
      when(mockSupabase.insertReviewLog(any)).thenAnswer((_) async {});

      await provider.submitReview(3);

      verify(mockFsrs.reviewCard(dueCard, 3)).called(1);
      verify(mockHive.saveFsrsCard(updatedState)).called(1);
      verify(mockHive.saveReviewLog(any)).called(1);
      expect(provider.isReviewComplete, true); // only 1 card, now done
    });

    test('continues to next card when more due cards remain', () async {
      final card1 = fakeFsrsCardState(
        cardId: 'c1',
        due: DateTime.now().subtract(const Duration(hours: 1)),
      );
      final card2 = fakeFsrsCardState(
        cardId: 'c2',
        due: DateTime.now().subtract(const Duration(hours: 2)),
      );
      final updatedCard1 = fakeFsrsCardState(
        cardId: 'c1',
        due: DateTime.now().add(const Duration(days: 1)),
      );

      when(mockHive.getDueCards(userId, any)).thenReturn([card1, card2]);
      when(mockHive.getCards('')).thenReturn(fakeDeckCardList());
      await provider.fetchDueCards(userId);

      when(mockFsrs.reviewCard(card1, 3)).thenReturn(updatedCard1);
      when(mockHive.saveFsrsCard(any)).thenAnswer((_) async {});
      when(mockHive.saveReviewLog(any)).thenAnswer((_) async {});
      when(mockSupabase.upsertFsrsCard(any)).thenAnswer((_) async {});
      when(mockSupabase.insertReviewLog(any)).thenAnswer((_) async {});

      await provider.submitReview(3);

      expect(provider.isReviewComplete, false);
      expect(provider.currentReviewCard!.cardId, 'c2');
    });

    test('Supabase sync failure does not set error (offline-tolerant)', () async {
      final dueCard = fakeFsrsCardState(
        due: DateTime.now().subtract(const Duration(hours: 1)),
      );
      final updated = fakeFsrsCardState(
        due: DateTime.now().add(const Duration(days: 1)),
      );

      when(mockHive.getDueCards(userId, any)).thenReturn([dueCard]);
      when(mockHive.getCards('')).thenReturn(fakeDeckCardList());
      await provider.fetchDueCards(userId);

      when(mockFsrs.reviewCard(any, any)).thenReturn(updated);
      when(mockHive.saveFsrsCard(any)).thenAnswer((_) async {});
      when(mockHive.saveReviewLog(any)).thenAnswer((_) async {});
      when(mockSupabase.upsertFsrsCard(any))
          .thenThrow(const AppException('Offline'));
      // The inner try-catch catches AppException silently

      await provider.submitReview(3);

      // Error should still be null because the outer catch only fires
      // if the local operations fail
      expect(provider.error, isNull);
    });

    test('does nothing if no current review card', () async {
      await provider.submitReview(3);

      verifyNever(mockFsrs.reviewCard(any, any));
    });
  });
}

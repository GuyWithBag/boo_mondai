// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/providers/card_provider_test.dart
// PURPOSE: Unit tests for CardProvider — CRUD and reorder operations for deck cards
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:boo_mondai/providers/card_provider.dart';
import 'package:boo_mondai/services/app_exception.dart';

import '../helpers/mock_supabase_service.mocks.dart';
import '../helpers/mock_hive_service.mocks.dart';
import '../helpers/fake_deck_card.dart';

void main() {
  late CardProvider provider;
  late MockSupabaseService mockSupabase;
  late MockHiveService mockHive;

  const deckId = '00000000-0000-0000-0000-000000000010';

  setUp(() {
    mockSupabase = MockSupabaseService();
    mockHive = MockHiveService();
    provider = CardProvider(
      supabaseService: mockSupabase,
      hiveService: mockHive,
    );
  });

  group('initial state', () {
    test('has empty cards and no error', () {
      expect(provider.cards, isEmpty);
      expect(provider.currentDeckId, isNull);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
    });
  });

  group('fetchCards', () {
    test('success populates cards and caches', () async {
      final cardList = fakeDeckCardList(count: 3);
      final jsonList = cardList.map((c) => c.toJson()).toList();

      when(mockSupabase.fetchCards(deckId))
          .thenAnswer((_) async => jsonList);
      when(mockHive.saveCards(deckId, any)).thenAnswer((_) async {});

      await provider.fetchCards(deckId);

      expect(provider.cards.length, 3);
      expect(provider.currentDeckId, deckId);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
      verify(mockHive.saveCards(deckId, any)).called(1);
    });

    test('failure loads from Hive cache and sets error', () async {
      final cached = fakeDeckCardList(count: 2);

      when(mockSupabase.fetchCards(deckId))
          .thenThrow(const AppException('Network error'));
      when(mockHive.getCards(deckId)).thenReturn(cached);

      await provider.fetchCards(deckId);

      expect(provider.error, 'Network error');
      expect(provider.cards.length, 2);
    });
  });

  group('addCard', () {
    test('success appends card to list', () async {
      final card = fakeDeckCard();
      when(mockSupabase.insertCard(any))
          .thenAnswer((_) async => card.toJson());

      final result = await provider.addCard(deckId, '犬', 'dog, いぬ, inu');

      expect(result, isNotNull);
      expect(provider.cards.length, 1);
      expect(provider.cards.first.question, '犬');
      expect(provider.error, isNull);
    });

    test('failure sets error and returns null', () async {
      when(mockSupabase.insertCard(any))
          .thenThrow(const AppException('Insert failed'));

      final result = await provider.addCard(deckId, 'q', 'a');

      expect(result, isNull);
      expect(provider.error, 'Insert failed');
    });
  });

  group('updateCard', () {
    test('success updates card in list', () async {
      // Seed cards
      final card = fakeDeckCard(id: 'card-1');
      when(mockSupabase.fetchCards(deckId))
          .thenAnswer((_) async => [card.toJson()]);
      when(mockHive.saveCards(deckId, any)).thenAnswer((_) async {});
      await provider.fetchCards(deckId);

      final updated = card.copyWith(question: 'Updated Question');
      when(mockSupabase.updateCard('card-1', any))
          .thenAnswer((_) async {});

      await provider.updateCard(updated);

      expect(provider.cards.first.question, 'Updated Question');
      expect(provider.error, isNull);
    });

    test('failure sets error', () async {
      final card = fakeDeckCard();
      when(mockSupabase.updateCard(any, any))
          .thenThrow(const AppException('Update failed'));

      await provider.updateCard(card);

      expect(provider.error, 'Update failed');
    });
  });

  group('deleteCard', () {
    test('success removes card from list', () async {
      final card = fakeDeckCard(id: 'card-1');
      when(mockSupabase.fetchCards(deckId))
          .thenAnswer((_) async => [card.toJson()]);
      when(mockHive.saveCards(deckId, any)).thenAnswer((_) async {});
      await provider.fetchCards(deckId);
      expect(provider.cards.length, 1);

      when(mockSupabase.deleteCard('card-1'))
          .thenAnswer((_) async {});

      await provider.deleteCard('card-1');

      expect(provider.cards, isEmpty);
      expect(provider.error, isNull);
    });

    test('failure sets error', () async {
      when(mockSupabase.deleteCard(any))
          .thenThrow(const AppException('Delete failed'));

      await provider.deleteCard('card-1');

      expect(provider.error, 'Delete failed');
    });
  });

  group('reorderCards', () {
    test('success updates local order and syncs to Supabase', () async {
      final cards = fakeDeckCardList(count: 3);
      when(mockSupabase.fetchCards(deckId))
          .thenAnswer((_) async => cards.map((c) => c.toJson()).toList());
      when(mockHive.saveCards(deckId, any)).thenAnswer((_) async {});
      await provider.fetchCards(deckId);

      // Reverse order
      final reordered = cards.reversed.toList();
      when(mockSupabase.updateCard(any, any))
          .thenAnswer((_) async {});

      await provider.reorderCards(reordered);

      expect(provider.cards.first.id, reordered.first.id);
      expect(provider.cards.last.id, reordered.last.id);
      // One updateCard call per card
      verify(mockSupabase.updateCard(any, any)).called(3);
    });

    test('failure during sync sets error', () async {
      final cards = fakeDeckCardList(count: 2);
      when(mockSupabase.updateCard(any, any))
          .thenThrow(const AppException('Sync failed'));

      await provider.reorderCards(cards);

      expect(provider.error, 'Sync failed');
    });
  });
}

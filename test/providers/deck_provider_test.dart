// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/providers/deck_provider_test.dart
// PURPOSE: Unit tests for DeckProvider — CRUD operations and filtering
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:boo_mondai/providers/deck_provider.dart';
import 'package:boo_mondai/services/app_exception.dart';

import '../helpers/mock_supabase_service.mocks.dart';
import '../helpers/mock_hive_service.mocks.dart';
import '../helpers/fake_deck.dart';

void main() {
  late DeckProvider provider;
  late MockSupabaseService mockSupabase;
  late MockHiveService mockHive;

  setUp(() {
    mockSupabase = MockSupabaseService();
    mockHive = MockHiveService();
    provider = DeckProvider(
      supabaseService: mockSupabase,
      hiveService: mockHive,
    );
  });

  group('initial state', () {
    test('has empty decks and no error', () {
      expect(provider.decks, isEmpty);
      expect(provider.userDecks, isEmpty);
      expect(provider.premadeDecks, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
    });
  });

  group('fetchDecks', () {
    test('success populates decks and caches in Hive', () async {
      final deckList = fakeDeckList(count: 2);
      final jsonList = deckList.map((d) => d.toJson()).toList();

      when(mockSupabase.fetchDecks()).thenAnswer((_) async => jsonList);
      when(mockHive.saveDecks(any)).thenAnswer((_) async {});

      await provider.fetchDecks();

      expect(provider.decks.length, 2);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
      verify(mockHive.saveDecks(any)).called(1);
    });

    test('failure sets error and loads from Hive cache', () async {
      final cachedDecks = fakeDeckList(count: 1);

      when(mockSupabase.fetchDecks())
          .thenThrow(const AppException('Network error'));
      when(mockHive.getDecks()).thenReturn(cachedDecks);

      await provider.fetchDecks();

      expect(provider.error, 'Network error');
      expect(provider.decks.length, 1);
      expect(provider.isLoading, false);
    });
  });

  group('fetchUserDecks', () {
    test('success populates userDecks', () async {
      final deck = fakeDeck();
      when(mockSupabase.fetchUserDecks('user-1'))
          .thenAnswer((_) async => [deck.toJson()]);

      await provider.fetchUserDecks('user-1');

      expect(provider.userDecks.length, 1);
      expect(provider.error, isNull);
    });

    test('failure sets error', () async {
      when(mockSupabase.fetchUserDecks(any))
          .thenThrow(const AppException('fail'));

      await provider.fetchUserDecks('user-1');

      expect(provider.error, 'fail');
    });
  });

  group('createDeck', () {
    test('success adds to both decks and userDecks', () async {
      final deck = fakeDeck();
      when(mockSupabase.insertDeck(any))
          .thenAnswer((_) async => deck.toJson());

      final result = await provider.createDeck(
        'user-1',
        'Test Deck',
        'desc',
        'japanese',
      );

      expect(result, isNotNull);
      expect(provider.userDecks.length, 1);
      expect(provider.decks.length, 1);
      expect(provider.error, isNull);
    });

    test('failure sets error and returns null', () async {
      when(mockSupabase.insertDeck(any))
          .thenThrow(const AppException('Insert failed'));

      final result = await provider.createDeck(
        'user-1',
        'Test',
        'desc',
        'japanese',
      );

      expect(result, isNull);
      expect(provider.error, 'Insert failed');
    });
  });

  group('updateDeck', () {
    test('success updates deck in lists', () async {
      // Seed with initial data
      final deck = fakeDeck(id: 'deck-1');
      when(mockSupabase.fetchDecks())
          .thenAnswer((_) async => [deck.toJson()]);
      when(mockHive.saveDecks(any)).thenAnswer((_) async {});
      await provider.fetchDecks();

      final updated = deck.copyWith(title: 'Updated Title');
      when(mockSupabase.updateDeck('deck-1', any))
          .thenAnswer((_) async {});

      await provider.updateDeck(updated);

      expect(provider.decks.first.title, 'Updated Title');
      expect(provider.error, isNull);
    });

    test('failure sets error', () async {
      final deck = fakeDeck();
      when(mockSupabase.updateDeck(any, any))
          .thenThrow(const AppException('Update failed'));

      await provider.updateDeck(deck);

      expect(provider.error, 'Update failed');
    });
  });

  group('deleteDeck', () {
    test('success removes deck from lists', () async {
      final deck = fakeDeck(id: 'deck-1');
      when(mockSupabase.fetchDecks())
          .thenAnswer((_) async => [deck.toJson()]);
      when(mockHive.saveDecks(any)).thenAnswer((_) async {});
      await provider.fetchDecks();
      expect(provider.decks.length, 1);

      when(mockSupabase.deleteDeck('deck-1'))
          .thenAnswer((_) async {});

      await provider.deleteDeck('deck-1');

      expect(provider.decks, isEmpty);
      expect(provider.error, isNull);
    });

    test('failure sets error', () async {
      when(mockSupabase.deleteDeck(any))
          .thenThrow(const AppException('Delete failed'));

      await provider.deleteDeck('deck-1');

      expect(provider.error, 'Delete failed');
    });
  });

  group('premadeDecks', () {
    test('filters to only premade decks', () async {
      final premade = fakeDeck(id: 'p1', isPremade: true);
      final userMade = fakeDeck(id: 'u1', isPremade: false);

      when(mockSupabase.fetchDecks())
          .thenAnswer((_) async => [premade.toJson(), userMade.toJson()]);
      when(mockHive.saveDecks(any)).thenAnswer((_) async {});

      await provider.fetchDecks();

      expect(provider.premadeDecks.length, 1);
      expect(provider.premadeDecks.first.isPremade, true);
      expect(provider.decks.length, 2);
    });
  });
}

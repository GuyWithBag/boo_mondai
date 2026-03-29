// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/deck_provider.dart
// PURPOSE: CRUD operations for decks
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';

/// Manages deck listing, creation, updates, and deletion.
class DeckProvider extends ChangeNotifier {
  final SupabaseService _supabaseService;
  final HiveService _hiveService;
  static const _uuid = Uuid();

  DeckProvider({
    required SupabaseService supabaseService,
    required HiveService hiveService,
  }) : _supabaseService = supabaseService,
       _hiveService = hiveService;

  List<Deck> _decks = [];
  List<Deck> _userDecks = [];
  bool _isLoading = false;
  String? _error;

  List<Deck> get decks => List.unmodifiable(_decks);
  List<Deck> get userDecks => List.unmodifiable(_userDecks);
  List<Deck> get premadeDecks => _decks.where((d) => d.isPremade).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDecks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _supabaseService.fetchDecks();
      _decks = data.map(Deck.fromJson).toList();
      await _hiveService.saveDecks(_decks);
    } on AppException catch (e) {
      _error = e.message;
      _decks = _hiveService.getDecks();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Loads the user's decks from Hive synchronously.
  ///
  /// Call this on page mount to show cached data immediately without waiting
  /// for the network. Returns the number of decks loaded so callers can
  /// decide whether to trigger a network fetch.
  int loadFromCache(String userId) {
    _userDecks = _hiveService.getUserDecks(userId);
    notifyListeners();
    return _userDecks.length;
  }

  Future<void> fetchUserDecks(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _supabaseService.fetchUserDecks(userId);
      _userDecks = data.map(Deck.fromJson).toList();
      // Cache user decks for offline / cache-first access
      for (final deck in _userDecks) {
        await _hiveService.saveDeck(deck);
      }
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Deck?> createDeck(
    String userId,
    String title,
    String shortDescription,
    String targetLanguage, {
    bool isPublic = true,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final data = {
        'id': _uuid.v4(),
        'creator_id': userId,
        'title': title,
        'short_description': shortDescription,
        'long_description': '',
        'target_language': targetLanguage,
        'is_premade': false,
        'is_public': isPublic,
        'card_count': 0,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };
      final result = await _supabaseService.insertDeck(data);
      final deck = Deck.fromJson(result);
      _userDecks = [deck, ..._userDecks];
      _decks = [deck, ..._decks];
      await _hiveService.saveDeck(deck);
      return deck;
    } on AppException catch (e) {
      _error = e.message;
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDeck(Deck deck) async {
    _error = null;
    try {
      await _supabaseService.updateDeck(deck.id, deck.toJson());
      _decks = [for (final d in _decks) d.id == deck.id ? deck : d];
      _userDecks = [for (final d in _userDecks) d.id == deck.id ? deck : d];
      notifyListeners();
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  /// Deletes [deckId] from Hive and memory immediately, then attempts a
  /// remote delete. If offline the remote delete is silently swallowed —
  /// the sync system will clean it up on the next push.
  Future<void> deleteDeck(String deckId) async {
    _error = null;
    _decks = _decks.where((d) => d.id != deckId).toList();
    _userDecks = _userDecks.where((d) => d.id != deckId).toList();
    await _hiveService.deleteDeck(deckId);
    notifyListeners();

    try {
      await _supabaseService.deleteDeck(deckId);
    } on AppException {
      // Offline — remote will be deleted on next sync
    }
  }

  /// Copies [sourceDeck] into the current user's My Decks.
  ///
  /// - Creates a new deck owned by [userId] with the same metadata.
  /// - Fetches all source cards and inserts copies, each with
  ///   [DeckCard.sourceCardId] pointing to the original.
  Future<Deck?> copyDeck(String userId, Deck sourceDeck) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final newDeckId = _uuid.v4();
      final deckData = {
        'id': newDeckId,
        'creator_id': userId,
        'title': sourceDeck.title,
        'short_description': sourceDeck.shortDescription,
        'long_description': sourceDeck.longDescription,
        'target_language': sourceDeck.targetLanguage,
        'tags': sourceDeck.tags,
        'is_premade': false,
        'is_public': false,
        'card_count': 0,
        'source_deck_id': sourceDeck.id,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };
      final deckResult = await _supabaseService.insertDeck(deckData);
      final newDeck = Deck.fromJson(deckResult);

      // Copy cards with source reference
      final sourceCards = await _supabaseService.fetchCards(sourceDeck.id);
      for (var i = 0; i < sourceCards.length; i++) {
        final src = DeckCard.fromJson(sourceCards[i]);
        final newCardId = _uuid.v4();
        await _supabaseService.insertCard({
          'id': newCardId,
          'deck_id': newDeckId,
          'card_type': src.cardType.toJson(),
          'question_type': src.questionType.toJson(),
          'sort_order': i,
          'source_card_id': src.id,
          'created_at': now.toIso8601String(),
        });

        for (final note in src.notes) {
          await _supabaseService.insertNote({
            'id': _uuid.v4(),
            'card_id': newCardId,
            'front_text': note.frontText,
            'back_text': note.backText,
            'front_image_url': note.frontImageUrl,
            'back_image_url': note.backImageUrl,
            'front_audio_url': note.frontAudioUrl,
            'back_audio_url': note.backAudioUrl,
            'is_reverse': note.isReverse,
            'created_at': now.toIso8601String(),
          });
        }
        for (var j = 0; j < src.options.length; j++) {
          final o = src.options[j];
          await _supabaseService.insertMCOption({
            'id': _uuid.v4(),
            'card_id': newCardId,
            'option_text': o.optionText,
            'is_correct': o.isCorrect,
            'display_order': j,
          });
        }
        for (final seg in src.segments) {
          await _supabaseService.insertFITBSegment({
            'id': _uuid.v4(),
            'card_id': newCardId,
            'full_text': seg.fullText,
            'blank_start': seg.blankStart,
            'blank_end': seg.blankEnd,
            'correct_answer': seg.correctAnswer,
          });
        }
        for (var j = 0; j < src.pairs.length; j++) {
          final p = src.pairs[j];
          await _supabaseService.insertMMPair({
            'id': _uuid.v4(),
            'card_id': newCardId,
            'term': p.term,
            'match': p.match,
            'is_auto_picked': false,
            'display_order': j,
          });
        }
      }

      // Update card_count
      final cardCount = sourceCards.length;
      await _supabaseService.updateDeck(newDeckId, {'card_count': cardCount});
      final updated = newDeck.copyWith(cardCount: cardCount);
      _userDecks = [updated, ..._userDecks];
      return updated;
    } on AppException catch (e) {
      _error = e.message;
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

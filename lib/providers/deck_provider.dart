// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/deck_provider.dart
// PURPOSE: Local-first CRUD for decks — Hive is source of truth; push/pull/sync for Supabase
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';

/// Manages deck listing, creation, updates, and deletion.
///
/// All mutations write to Hive only. Call [push], [pull], or [sync]
/// to exchange data with Supabase.
class DeckProvider extends ChangeNotifier {
  final SupabaseService _supabaseService;
  static const _uuid = Uuid();

  DeckProvider({required SupabaseService supabaseService})
    : _supabaseService = supabaseService;

  List<Deck> _decks = [];
  List<Deck> _userDecks = [];
  bool _isLoading = false;
  bool _isPushing = false;
  bool _isPulling = false;
  bool _isSyncing = false;
  String? _error;

  List<Deck> get decks => List.unmodifiable(_decks);
  List<Deck> get userDecks => List.unmodifiable(_userDecks);
  List<Deck> get premadeDecks => _decks.where((d) => d.isPremade).toList();
  bool get isLoading => _isLoading;
  bool get isPushing => _isPushing;
  bool get isPulling => _isPulling;
  bool get isSyncing => _isSyncing;
  String? get error => _error;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ── Local reads (Hive only) ──────────────────────────────────────

  /// Loads all decks from Hive into memory.
  void loadDecks() {
    _decks = _hiveService.getDecks();
    notifyListeners();
  }

  /// Loads the user's decks from Hive into memory.
  void loadUserDecks(String userId) {
    _userDecks = _hiveService.getUserDecks(userId);
    notifyListeners();
  }

  // ── Local writes (Hive only) ─────────────────────────────────────

  /// Creates a new deck in Hive and adds it to the in-memory lists.
  Future<Deck?> createDeck(
    String userId,
    String title,
    String shortDescription,
    String targetLanguage, {
    bool isPublic = true,
  }) async {
    _error = null;

    try {
      final now = DateTime.now();
      final deck = Deck(
        id: _uuid.v4(),
        creatorId: userId,
        title: title,
        shortDescription: shortDescription,
        targetLanguage: targetLanguage,
        isPremade: false,
        isPublic: isPublic,
        cardCount: 0,
        createdAt: now,
        updatedAt: now,
      );
      _userDecks = [deck, ..._userDecks];
      _decks = [deck, ..._decks];
      notifyListeners();
      return deck;
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  /// Updates a deck in Hive and in-memory lists.
  Future<void> updateDeck(Deck deck) async {
    _error = null;
    try {
      await _hiveService.saveDeck(deck);
      _decks = [for (final d in _decks) d.id == deck.id ? deck : d];
      _userDecks = [for (final d in _userDecks) d.id == deck.id ? deck : d];
      notifyListeners();
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  /// Deletes a deck from Hive and in-memory lists.
  Future<void> deleteDeck(String deckId) async {
    _error = null;
    _decks = _decks.where((d) => d.id != deckId).toList();
    _userDecks = _userDecks.where((d) => d.id != deckId).toList();
    await _hiveService.deleteDeck(deckId);
    notifyListeners();
  }

  // ── Push (Hive → Supabase) ───────────────────────────────────────

  /// Pushes all local user decks to Supabase via upsert.
  Future<void> push(String userId) async {
    _isPushing = true;
    _error = null;
    notifyListeners();

    try {
      final localDecks = _hiveService.getUserDecks(userId);
      for (final deck in localDecks) {
        await _supabaseService.upsertDeck(deck.toJson());
      }
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isPushing = false;
      notifyListeners();
    }
  }

  // ── Pull (Supabase → Hive) ───────────────────────────────────────

  /// Fetches user decks from Supabase. For each remote deck, if the remote
  /// `updatedAt` is newer than the local copy (or no local copy exists),
  /// overwrites the local copy. Reloads in-memory lists from Hive when done.
  Future<void> pull(String userId) async {
    _isPulling = true;
    _error = null;
    notifyListeners();

    try {
      final remoteData = await _supabaseService.fetchUserDecks(userId);
      final remoteDecks = remoteData.map(Deck.fromJson).toList();

      for (final remote in remoteDecks) {
        final localDecks = _hiveService.getDecks();
        final local = localDecks.where((d) => d.id == remote.id).firstOrNull;

        if (local == null || remote.updatedAt.isAfter(local.updatedAt)) {
          await _hiveService.saveDeck(remote);
        }
      }

      _userDecks = _hiveService.getUserDecks(userId);
      _decks = _hiveService.getDecks();
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isPulling = false;
      notifyListeners();
    }
  }

  /// Fetches all public decks from Supabase and merges into Hive by
  /// `updatedAt`. Use this to populate the online browser cache.
  Future<void> pullPublicDecks() async {
    _isPulling = true;
    _error = null;
    notifyListeners();

    try {
      final remoteData = await _supabaseService.fetchDecks();
      final remoteDecks = remoteData.map(Deck.fromJson).toList();

      for (final remote in remoteDecks) {
        final localDecks = _hiveService.getDecks();
        final local = localDecks.where((d) => d.id == remote.id).firstOrNull;

        if (local == null || remote.updatedAt.isAfter(local.updatedAt)) {
          await _hiveService.saveDeck(remote);
        }
      }

      _decks = _hiveService.getDecks();
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isPulling = false;
      notifyListeners();
    }
  }

  // ── Sync (pull then push) ────────────────────────────────────────

  /// Pulls remote decks (newer wins), then pushes all local decks.
  Future<void> sync(String userId) async {
    _isSyncing = true;
    _error = null;
    notifyListeners();

    try {
      await pull(userId);
      if (_error != null) return;
      await push(userId);
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  // ── Copy (remote → Hive) ────────────────────────────────────────

  /// Copies [sourceDeck] into the current user's My Decks.
  ///
  /// Fetches source cards from Supabase, creates a new deck + card copies
  /// in Hive only. Use [push] afterwards to sync to Supabase.
  Future<Deck?> copyDeck(String userId, Deck sourceDeck) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final newDeckId = _uuid.v4();

      // Fetch source cards from Supabase (the source deck may not be local)
      final sourceCards = await _supabaseService.fetchCards(sourceDeck.id);
      final sourceCardModels = sourceCards.map(DeckCard.fromJson).toList();

      // Build new cards with copied data
      final newCards = <DeckCard>[];
      for (var i = 0; i < sourceCardModels.length; i++) {
        final src = sourceCardModels[i];
        final newCardId = _uuid.v4();

        final copiedNotes = [
          for (final note in src.notes)
            note.copyWith(id: _uuid.v4(), cardId: newCardId),
        ];
        final copiedOptions = [
          for (var j = 0; j < src.options.length; j++)
            src.options[j].copyWith(
              id: _uuid.v4(),
              cardId: newCardId,
              displayOrder: j,
            ),
        ];
        final copiedSegments = [
          for (final seg in src.segments)
            seg.copyWith(id: _uuid.v4(), cardId: newCardId),
        ];
        final copiedPairs = [
          for (var j = 0; j < src.pairs.length; j++)
            src.pairs[j].copyWith(
              id: _uuid.v4(),
              cardId: newCardId,
              displayOrder: j,
            ),
        ];

        newCards.add(
          src.copyWith(
            id: newCardId,
            deckId: newDeckId,
            sortOrder: i,
            sourceCardId: src.id,
            createdAt: now,
            notes: copiedNotes,
            options: copiedOptions,
            segments: copiedSegments,
            pairs: copiedPairs,
          ),
        );
      }

      // Create the deck in Hive
      final newDeck = Deck(
        id: newDeckId,
        creatorId: userId,
        title: sourceDeck.title,
        shortDescription: sourceDeck.shortDescription,
        longDescription: sourceDeck.longDescription,
        targetLanguage: sourceDeck.targetLanguage,
        tags: sourceDeck.tags,
        isPremade: false,
        isPublic: false,
        cardCount: newCards.length,
        sourceDeckId: sourceDeck.id,
        sourceDeckCreatorId: sourceDeck.creatorId,
        createdAt: now,
        updatedAt: now,
      );

      await _hiveService.saveDeck(newDeck);
      await _hiveService.replaceCardsForDeck(newDeckId, newCards);

      _userDecks = [newDeck, ..._userDecks];
      notifyListeners();
      return newDeck;
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

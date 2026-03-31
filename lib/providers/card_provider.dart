// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/card_provider.dart
// PURPOSE: Local-first CRUD for cards — Hive is source of truth; pushDeck syncs to Supabase
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';

/// Manages cards within a specific deck.
///
/// All mutations (add / update / delete / reorder) write to Hive only and
/// mark the deck dirty. Call [pushDeck] to batch-sync a deck to Supabase.
class CardProvider extends ChangeNotifier {
  final SupabaseService _supabaseService;
  final HiveService _hiveService;
  static const uuid = Uuid();

  List<DeckCard> _cards = [];
  String? _currentDeckId;
  final Set<String> _dirtyDeckIds = {};
  bool _isLoading = false;
  bool _isPushing = false;
  bool _isSyncing = false;
  bool _cancelSync = false;
  DateTime? _lastSyncedAt;
  String? _error;

  CardProvider({
    required SupabaseService supabaseService,
    required HiveService hiveService,
  }) : _supabaseService = supabaseService,
       _hiveService = hiveService {
    _lastSyncedAt = hiveService.getLastSyncedAt();
  }

  List<DeckCard> get cards => List.unmodifiable(_cards);
  String? get currentDeckId => _currentDeckId;
  bool get isLoading => _isLoading;

  /// True while [pushDeck] is running.
  bool get isPushing => _isPushing;

  /// True while [syncAll] is running.
  bool get isSyncing => _isSyncing;

  /// Timestamp of the last completed [syncAll]. Null until first sync.
  DateTime? get lastSyncedAt => _lastSyncedAt;

  String? get error => _error;

  /// Returns true when [deckId] has local changes not yet pushed to Supabase.
  bool isDirty(String deckId) => _dirtyDeckIds.contains(deckId);

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ── Fetch (network + cache) ──────────────────────────────────────

  /// Fetches all cards for [deckId] from Supabase (with nested joins),
  /// caches them in Hive, and clears the dirty flag.
  Future<void> fetchCards(String deckId) async {
    _isLoading = true;
    _error = null;
    _currentDeckId = deckId;
    notifyListeners();

    try {
      final data = await _supabaseService.fetchCards(deckId);
      _cards = data.map(DeckCard.fromJson).toList();
      await _hiveService.saveCards(deckId, _cards);
      _dirtyDeckIds.remove(deckId);
    } on AppException catch (e) {
      _error = e.message;
      _cards = _hiveService.getCards(deckId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Local writes (Hive only, mark dirty) ────────────────────────

  /// Convenience wrapper for the most common card type.
  Future<DeckCard?> addSimpleCard(
    String deckId, {
    required String frontText,
    required String backText,
    CardType cardType = CardType.normal,
    String? frontImageUrl,
    String? backImageUrl,
    String? frontAudioUrl,
    String? backAudioUrl,
  }) => addCard(
    deckId,
    cardType: cardType,
    questionType: QuestionType.flashcard,
    frontText: frontText,
    backText: backText,
    frontImageUrl: frontImageUrl,
    backImageUrl: backImageUrl,
    frontAudioUrl: frontAudioUrl,
    backAudioUrl: backAudioUrl,
  );

  /// Creates a new card fully in memory, saves it to Hive, and marks the
  /// deck dirty. No Supabase call is made here — use [pushDeck] to sync.
  Future<DeckCard?> addCard(
    String deckId, {
    required CardType cardType,
    required QuestionType questionType,
    String frontText = '',
    String backText = '',
    String? frontImageUrl,
    String? backImageUrl,
    String? frontAudioUrl,
    String? backAudioUrl,
    List<MultipleChoiceOption> options = const [],
    List<FillInTheBlankSegment> segments = const [],
    List<MatchMadnessPair> pairs = const [],
  }) async {
    _error = null;

    try {
      final cardId = uuid.v4();
      final now = DateTime.now();

      final newNote = Note(
        id: uuid.v4(),
        cardId: cardId,
        frontText: frontText,
        backText: backText,
        frontImageUrl: frontImageUrl,
        backImageUrl: backImageUrl,
        frontAudioUrl: frontAudioUrl,
        backAudioUrl: backAudioUrl,
        isReverse: false,
        createdAt: now,
      );
      // Build notes in memory
      final builtNotes = <Note>[];
      if (!questionType.usesPairs) {
        builtNotes.add(newNote);
        if (cardType == CardType.both) {
          builtNotes.add(newNote.reverse());
        }
      }

      // Assign stable UUIDs to children that come in without them.
      // These children are the answer values for each question type. 
      final builtOptions = [
        for (var i = 0; i < options.length; i++)
          options[i].id.isEmpty
              ? options[i].copyWith(
                  id: uuid.v4(),
                  cardId: cardId,
                  displayOrder: i,
                )
              : options[i].copyWith(cardId: cardId, displayOrder: i),
      ];
      final builtSegments = [
        for (final seg in segments)
          seg.id.isEmpty
              ? seg.copyWith(id: uuid.v4(), cardId: cardId)
              : seg.copyWith(cardId: cardId),
      ];
      final builtPairs = [
        for (var i = 0; i < pairs.length; i++)
          pairs[i].id.isEmpty
              ? pairs[i].copyWith(
                  id: uuid.v4(),
                  cardId: cardId,
                  displayOrder: i,
                )
              : pairs[i].copyWith(cardId: cardId, displayOrder: i),
      ];

      final card = DeckCard(
        id: cardId,
        deckId: deckId,
        cardType: cardType,
        questionType: questionType,
        sortOrder: _cards.length,
        createdAt: now,
        notes: builtNotes,
        options: builtOptions,
        segments: builtSegments,
        pairs: builtPairs,
      );

      _cards = [..._cards, card];
      await _hiveService.saveCards(deckId, [card]);
      _dirtyDeckIds.add(deckId);
      notifyListeners();
      return card;
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  /// Updates [card] in memory and Hive. No Supabase call.
  Future<void> updateCard(DeckCard card) async {
    _error = null;
    final normalized = _normalizeChildIds(card);
    _cards = [for (final c in _cards) c.id == normalized.id ? normalized : c];
    await _hiveService.saveCards(normalized.deckId, [normalized]);
    _dirtyDeckIds.add(normalized.deckId);
    notifyListeners();
  }

  /// Removes [cardId] from memory and Hive. No Supabase call.
  Future<void> deleteCard(String cardId) async {
    _error = null;
    final card = _cards.where((c) => c.id == cardId).firstOrNull;
    if (card == null) return;
    _cards = _cards.where((c) => c.id != cardId).toList();
    await _hiveService.deleteCard(cardId);
    _dirtyDeckIds.add(card.deckId);
    notifyListeners();
  }

  /// Updates [sortOrder] for all cards in memory and Hive. No Supabase call.
  Future<void> reorderCards(List<DeckCard> reordered) async {
    _error = null;
    final reindexed = [
      for (var i = 0; i < reordered.length; i++)
        reordered[i].copyWith(sortOrder: i),
    ];
    _cards = reindexed;
    await _hiveService.saveCards(reindexed.first.deckId, reindexed);
    if (reindexed.isNotEmpty) _dirtyDeckIds.add(reindexed.first.deckId);
    notifyListeners();
  }

  // ── Commit (editor draft → Hive) ──────────────────────────────────

  /// Replaces all cards for [deckId] in Hive with [cards] and marks dirty.
  /// Called by the editor page when the user explicitly saves their draft.
  Future<void> commitCards(String deckId, List<DeckCard> cards) async {
    _error = null;
    try {
      final normalized = [for (final c in cards) _normalizeChildIds(c)];
      await _hiveService.replaceCardsForDeck(deckId, normalized);
      _cards = normalized;
      _currentDeckId = deckId;
      _dirtyDeckIds.add(deckId);
      notifyListeners();
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  // ── Push (Hive → Supabase) ────────────────────────────────────────

  /// Syncs all local cards for [deckId] to Supabase.
  ///
  /// For each card: upserts the card row, replaces all child records.
  /// Deletes any remote cards that no longer exist locally.
  Future<void> pushDeck(String deckId) async {
    _isPushing = true;
    _error = null;
    notifyListeners();

    try {
      await _pushDeckBody(deckId);
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isPushing = false;
      notifyListeners();
    }
  }

  /// Pushes all [deckIds] to Supabase in order.
  ///
  /// Returns `true` if all decks were pushed, `false` if cancelled or errored.
  /// Call [cancelSync] to interrupt the loop between deck pushes.
  Future<bool> syncAll(List<String> deckIds) async {
    _isSyncing = true;
    _cancelSync = false;
    _error = null;
    notifyListeners();

    var completed = true;
    try {
      for (final deckId in deckIds) {
        if (_cancelSync) {
          completed = false;
          break;
        }
        await _pushDeckBody(deckId);
      }
      if (completed) {
        _lastSyncedAt = DateTime.now();
        await _hiveService.setLastSyncedAt(_lastSyncedAt!);
      }
    } on AppException catch (e) {
      _error = e.message;
      completed = false;
    } finally {
      _isSyncing = false;
      _cancelSync = false;
      notifyListeners();
    }
    return completed;
  }

  /// Signals [syncAll] to stop after the current deck push completes.
  void cancelSync() {
    _cancelSync = true;
  }

  // ── Private helpers ──────────────────────────────────────────────

  /// Pushes all local cards for [deckId] to Supabase without touching loading flags.
  Future<void> _pushDeckBody(String deckId) async {
    final localCards = _cards.where((c) => c.deckId == deckId).toList();
    final localIds = localCards.map((c) => c.id).toList();

    await _supabaseService.deleteOrphanCards(deckId, localIds);

    for (final card in localCards) {
      await _supabaseService.upsertCardRow(card.toJson());
      await _supabaseService.deleteChildrenByCardId(card.id);
      await Future.wait([
        _supabaseService.batchInsertNotes(
          card.notes.map((n) => n.toJson()).toList(),
        ),
        _supabaseService.batchInsertMCOptions(
          card.options.map((o) => o.toJson()).toList(),
        ),
        _supabaseService.batchInsertFITBSegments(
          card.segments.map((s) => s.toJson()).toList(),
        ),
        _supabaseService.batchInsertMMPairs(
          card.pairs.map((p) => p.toJson()).toList(),
        ),
      ]);
    }

    _dirtyDeckIds.remove(deckId);
  }

  /// Ensures every child record has a non-empty [id] and the correct [cardId].
  DeckCard _normalizeChildIds(DeckCard card) {
    final notes = card.notes
        .map(
          (n) => n.id.isEmpty ? n.copyWith(id: uuid.v4(), cardId: card.id) : n,
        )
        .toList();
    final options = [
      for (var i = 0; i < card.options.length; i++)
        card.options[i].id.isEmpty
            ? card.options[i].copyWith(
                id: uuid.v4(),
                cardId: card.id,
                displayOrder: i,
              )
            : card.options[i],
    ];
    final segments = card.segments
        .map(
          (s) => s.id.isEmpty ? s.copyWith(id: uuid.v4(), cardId: card.id) : s,
        )
        .toList();
    final pairs = [
      for (var i = 0; i < card.pairs.length; i++)
        card.pairs[i].id.isEmpty
            ? card.pairs[i].copyWith(
                id: uuid.v4(),
                cardId: card.id,
                displayOrder: i,
              )
            : card.pairs[i],
    ];
    return card.copyWith(
      notes: notes,
      options: options,
      segments: segments,
      pairs: pairs,
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/deck_editor_page_controller.dart
// PURPOSE: Manages the working copy of a Deck and its DeckCards during editing
// PROVIDERS: DeckEditorPageController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/deck.dart';
import '../models/deck_card.dart';
import '../repositories/deck_repository.dart';
import '../repositories/deck_card_repository.dart';

/// Drives the Deck Editor page — holds a working copy of the [Deck] and its
/// [DeckCard]s, tracks dirtiness, and persists via [save].
class DeckEditorPageController extends ChangeNotifier {
  DeckEditorPageController({
    required DeckRepository deckRepository,
    required DeckCardRepository deckCardRepository,
  })  : _deckRepository = deckRepository,
        _deckCardRepository = deckCardRepository;

  final DeckRepository _deckRepository;
  final DeckCardRepository _deckCardRepository;
  static const _uuid = Uuid();

  // ── private state ────────────────────────────────────────

  Deck? _deck;
  List<DeckCard> _cards = [];
  bool _isDirty = false;
  bool _isLoading = false;
  String? _error;

  // ── public getters ───────────────────────────────────────

  Deck? get deck => _deck;
  List<DeckCard> get cards => List.unmodifiable(_cards);
  bool get isDirty => _isDirty;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ── methods ──────────────────────────────────────────────

  /// Loads an existing deck and its cards from the repositories.
  Future<void> load(String deckId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _deck = _deckRepository.getById(deckId);
      final loaded = _deckCardRepository.getByDeckId(deckId);
      loaded.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      _cards = loaded;
      _isDirty = false;
    } on Exception catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Initialises the controller for a brand-new deck (no persisted data yet).
  void loadNew() {
    final now = DateTime.now();
    _deck = Deck(
      id: _uuid.v4(),
      creatorId: 'local',
      title: '',
      shortDescription: '',
      longDescription: '',
      targetLanguage: '',
      tags: [],
      isPremade: false,
      isPublic: false,
      isUneditable: false,
      hiddenInBrowser: false,
      isPublished: false,
      cardCount: 0,
      version: '1.0.0',
      buildNumber: 1,
      sourceDeckId: null,
      createdAt: now,
      updatedAt: now,
    );
    _cards = [];
    _isDirty = true;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  /// Replaces the working deck with [updated] and marks the controller dirty.
  void updateDeck(Deck updated) {
    _deck = updated;
    _isDirty = true;
    notifyListeners();
  }

  /// Appends [card] to the working card list and marks the controller dirty.
  void addCard(DeckCard card) {
    _cards = [..._cards, card];
    _isDirty = true;
    notifyListeners();
  }

  /// Replaces the card matching [card.id] in the working list with [card].
  void updateCard(DeckCard card) {
    _cards = [
      for (final c in _cards)
        if (c.id == card.id) card else c,
    ];
    _isDirty = true;
    notifyListeners();
  }

  /// Removes the card with the given [cardId] from the working list.
  void removeCard(String cardId) {
    _cards = _cards.where((c) => c.id != cardId).toList();
    _isDirty = true;
    notifyListeners();
  }

  /// Reorders the card at [oldIndex] to [newIndex] and updates [sortOrder] on
  /// every card to reflect the new sequence.
  void reorderCards(int oldIndex, int newIndex) {
    final mutable = List<DeckCard>.from(_cards);
    final item = mutable.removeAt(oldIndex);
    final insertAt = newIndex > oldIndex ? newIndex - 1 : newIndex;
    mutable.insert(insertAt, item);
    _cards = [
      for (int i = 0; i < mutable.length; i++)
        mutable[i].copyWith(sortOrder: i),
    ];
    _isDirty = true;
    notifyListeners();
  }

  /// Persists the working deck and all cards to Hive.
  Future<void> save() async {
    if (_deck == null) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedDeck = _deck!.copyWith(
        cardCount: _cards.length,
        updatedAt: DateTime.now(),
      );
      await _deckRepository.save(updatedDeck);
      await _deckCardRepository.saveAll(_cards);
      _deck = updatedDeck;
      _isDirty = false;
    } on Exception catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Discards all unsaved changes by reloading from the repository (or
  /// resetting to a clean state when no persisted deck exists yet).
  Future<void> discard() async {
    final id = _deck?.id;
    if (id != null && _deckRepository.getById(id) != null) {
      await load(id);
    } else {
      _deck = null;
      _cards = [];
      _isDirty = false;
      notifyListeners();
    }
  }

  /// Clears any active error message and notifies listeners.
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

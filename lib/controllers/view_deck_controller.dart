// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/view_deck_controller.dart
// PURPOSE: Holds the currently viewed deck + its cards as draft state.
//          All edits stay in memory until save() writes to Hive.
//          discard() reloads from Hive, throwing away unsaved changes.
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';

/// Draft layer between UI and Hive for a single deck.
///
/// Load a deck with [loadDeck]. Mutate cards with [updateCard],
/// [addCard], [deleteCard]. Call [save] to persist to Hive,
/// or [discard] to reload the last-saved state.
class ViewDeckController extends ChangeNotifier {
  final HiveService _hiveService;

  Deck? _currentDeck;
  List<DeckCard> _cards = [];
  bool _isDirty = false;

  ViewDeckController({required HiveService hiveService})
      : _hiveService = hiveService;

  Deck? get currentDeck => _currentDeck;
  List<DeckCard> get cards => List.unmodifiable(_cards);
  bool get isDirty => _isDirty;

  /// Loads a deck and its cards from Hive into the draft.
  void loadDeck(String deckId, {required List<Deck> fromDecks}) {
    _currentDeck = fromDecks.where((d) => d.id == deckId).firstOrNull;
    _cards = _hiveService.getCards(deckId);
    _isDirty = false;
    notifyListeners();
  }

  /// Updates a single card in the draft.
  void updateCard(DeckCard card) {
    _cards = [for (final c in _cards) c.id == card.id ? card : c];
    _isDirty = true;
    notifyListeners();
  }

  /// Adds a new card to the draft.
  void addCard(DeckCard card) {
    _cards = [..._cards, card];
    _isDirty = true;
    notifyListeners();
  }

  /// Removes a card from the draft by id.
  void deleteCard(String cardId) {
    _cards = _cards.where((c) => c.id != cardId).toList();
    _isDirty = true;
    notifyListeners();
  }

  /// Persists the current draft to Hive.
  Future<void> save() async {
    final deckId = _currentDeck?.id;
    if (deckId == null) return;
    await _hiveService.replaceCardsForDeck(deckId, _cards);
    _isDirty = false;
    notifyListeners();
  }

  /// Throws away unsaved changes and reloads from Hive.
  void discard() {
    final deckId = _currentDeck?.id;
    if (deckId == null) return;
    _cards = _hiveService.getCards(deckId);
    _isDirty = false;
    notifyListeners();
  }

  /// Clears the current deck (e.g. when navigating away).
  void clear() {
    _currentDeck = null;
    _cards = [];
    _isDirty = false;
    notifyListeners();
  }
}



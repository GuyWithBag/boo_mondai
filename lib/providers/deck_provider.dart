// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/deck_provider.dart
// PURPOSE: CRUD operations for decks
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/services/services.dart';

/// Manages deck listing, creation, updates, and deletion.
class DeckProvider extends ChangeNotifier {
  final SupabaseService _supabaseService;
  final HiveService _hiveService;
  static const _uuid = Uuid();

  DeckProvider({
    required SupabaseService supabaseService,
    required HiveService hiveService,
  })  : _supabaseService = supabaseService,
        _hiveService = hiveService;

  List<Deck> _decks = [];
  List<Deck> _userDecks = [];
  bool _isLoading = false;
  String? _error;

  List<Deck> get decks => List.unmodifiable(_decks);
  List<Deck> get userDecks => List.unmodifiable(_userDecks);
  List<Deck> get premadeDecks =>
      _decks.where((d) => d.isPremade).toList();
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

  Future<void> fetchUserDecks(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _supabaseService.fetchUserDecks(userId);
      _userDecks = data.map(Deck.fromJson).toList();
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
    String description,
    String targetLanguage,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final data = {
        'id': _uuid.v4(),
        'creator_id': userId,
        'title': title,
        'description': description,
        'target_language': targetLanguage,
        'is_premade': false,
        'is_public': true,
        'card_count': 0,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };
      final result = await _supabaseService.insertDeck(data);
      final deck = Deck.fromJson(result);
      _userDecks = [deck, ..._userDecks];
      _decks = [deck, ..._decks];
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

  Future<void> deleteDeck(String deckId) async {
    _error = null;
    try {
      await _supabaseService.deleteDeck(deckId);
      _decks = _decks.where((d) => d.id != deckId).toList();
      _userDecks = _userDecks.where((d) => d.id != deckId).toList();
      notifyListeners();
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }
}

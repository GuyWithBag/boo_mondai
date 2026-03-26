// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/card_provider.dart
// PURPOSE: CRUD operations for cards within a deck
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:boo_mondai/models/deck_card.dart';
import 'package:boo_mondai/services/supabase_service.dart';
import 'package:boo_mondai/services/hive_service.dart';
import 'package:boo_mondai/services/app_exception.dart';

/// Manages cards within a specific deck.
class CardProvider extends ChangeNotifier {
  final SupabaseService _supabaseService;
  final HiveService _hiveService;
  static const _uuid = Uuid();

  CardProvider({
    required SupabaseService supabaseService,
    required HiveService hiveService,
  })  : _supabaseService = supabaseService,
        _hiveService = hiveService;

  List<DeckCard> _cards = [];
  String? _currentDeckId;
  bool _isLoading = false;
  String? _error;

  List<DeckCard> get cards => List.unmodifiable(_cards);
  String? get currentDeckId => _currentDeckId;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCards(String deckId) async {
    _isLoading = true;
    _error = null;
    _currentDeckId = deckId;
    notifyListeners();

    try {
      final data = await _supabaseService.fetchCards(deckId);
      _cards = data.map(DeckCard.fromJson).toList();
      await _hiveService.saveCards(deckId, _cards);
    } on AppException catch (e) {
      _error = e.message;
      _cards = _hiveService.getCards(deckId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<DeckCard?> addCard(
    String deckId,
    String question,
    String answer, {
    String? questionImageUrl,
    String? answerImageUrl,
  }) async {
    _error = null;

    try {
      final data = {
        'id': _uuid.v4(),
        'deck_id': deckId,
        'question': question,
        'answer': answer,
        'question_image_url': questionImageUrl,
        'answer_image_url': answerImageUrl,
        'sort_order': _cards.length,
        'created_at': DateTime.now().toIso8601String(),
      };
      final result = await _supabaseService.insertCard(data);
      final card = DeckCard.fromJson(result);
      _cards = [..._cards, card];
      notifyListeners();
      return card;
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  Future<void> updateCard(DeckCard card) async {
    _error = null;
    try {
      await _supabaseService.updateCard(card.id, card.toJson());
      _cards = [for (final c in _cards) c.id == card.id ? card : c];
      notifyListeners();
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  Future<void> deleteCard(String cardId) async {
    _error = null;
    try {
      await _supabaseService.deleteCard(cardId);
      _cards = _cards.where((c) => c.id != cardId).toList();
      notifyListeners();
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  Future<void> reorderCards(List<DeckCard> reordered) async {
    _error = null;
    _cards = reordered;
    notifyListeners();

    try {
      for (var i = 0; i < reordered.length; i++) {
        await _supabaseService.updateCard(
          reordered[i].id,
          {'sort_order': i},
        );
      }
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }
}

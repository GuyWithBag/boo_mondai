// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/fsrs_provider.dart
// PURPOSE: Manages FSRS card states, due cards, and review sessions
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/services/services.dart';

/// Manages the FSRS review deck — fetches due cards, handles review ratings.
class FsrsProvider extends ChangeNotifier {
  final FsrsService _fsrsService;
  final HiveService _hiveService;
  final SupabaseService _supabaseService;
  static const _uuid = Uuid();

  FsrsProvider({
    required FsrsService fsrsService,
    required HiveService hiveService,
    required SupabaseService supabaseService,
  })  : _fsrsService = fsrsService,
        _hiveService = hiveService,
        _supabaseService = supabaseService;

  List<FsrsCardState> _dueCards = [];
  final Map<String, DeckCard> _deckCardCache = {};
  int _currentIndex = 0;
  bool _isLoading = false;
  String? _error;

  List<FsrsCardState> get dueCards => List.unmodifiable(_dueCards);
  int get dueCount => _dueCards.length;
  bool get isLoading => _isLoading;
  String? get error => _error;

  FsrsCardState? get currentReviewCard =>
      _currentIndex < _dueCards.length ? _dueCards[_currentIndex] : null;

  DeckCard? get currentDeckCard {
    final card = currentReviewCard;
    if (card == null) return null;
    return _deckCardCache[card.cardId];
  }

  bool get isReviewComplete => _currentIndex >= _dueCards.length;

  Future<void> fetchDueCards(String userId) async {
    _isLoading = true;
    _error = null;
    _currentIndex = 0;
    notifyListeners();

    try {
      _dueCards = _hiveService.getDueCards(userId, DateTime.now());

      // Load associated DeckCards
      for (final fsrsCard in _dueCards) {
        if (!_deckCardCache.containsKey(fsrsCard.cardId)) {
          final cards = _hiveService.getCards(''); // search all
          for (final dc in cards) {
            _deckCardCache[dc.id] = dc;
          }
          break; // only need to load once
        }
      }
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startReview() {
    _currentIndex = 0;
    notifyListeners();
  }

  Future<void> submitReview(int rating) async {
    final card = currentReviewCard;
    if (card == null) return;

    _error = null;

    try {
      final updated = _fsrsService.reviewCard(card, rating);
      await _hiveService.saveFsrsCard(updated);

      final log = ReviewLogEntry(
        id: _uuid.v4(),
        userId: card.userId,
        cardId: card.cardId,
        rating: rating,
        scheduledDays: updated.scheduledDays,
        elapsedDays: updated.elapsedDays,
        review: DateTime.now(),
        state: updated.state,
      );
      await _hiveService.saveReviewLog(log);

      // Sync to Supabase
      try {
        await _supabaseService.upsertFsrsCard(updated.toJson());
        await _supabaseService.insertReviewLog(log.toJson());
      } on AppException {
        // Offline — data saved locally, will sync later
      }

      _currentIndex++;
    } on AppException catch (e) {
      _error = e.message;
    }

    notifyListeners();
  }
}

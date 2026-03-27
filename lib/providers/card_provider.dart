// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/card_provider.dart
// PURPOSE: CRUD operations for cards within a deck
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/services/services.dart';

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

  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Fetches all cards for [deckId], including notes/options/segments/pairs
  /// via Supabase joins. Falls back to Hive cache on network failure.
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

  /// Convenience method — adds a [QuestionType.readAndSelect] card,
  /// the most common type.
  Future<DeckCard?> addSimpleCard(
    String deckId, {
    required String frontText,
    required String backText,
    CardType cardType = CardType.normal,
    String? frontImageUrl,
    String? backImageUrl,
    String? frontAudioUrl,
    String? backAudioUrl,
  }) =>
      addCard(
        deckId,
        cardType: cardType,
        questionType: QuestionType.readAndSelect,
        frontText: frontText,
        backText: backText,
        frontImageUrl: frontImageUrl,
        backImageUrl: backImageUrl,
        frontAudioUrl: frontAudioUrl,
        backAudioUrl: backAudioUrl,
      );

  /// Full card-creation method. Inserts the card row then inserts all
  /// content nodes (notes, options, segments, or pairs) in order.
  ///
  /// Notes are generated automatically from [frontText]/[backText] for all
  /// question types except [QuestionType.matchMadness].
  /// When [cardType] is [CardType.both] a second reversed Note is also created.
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
      final cardId = _uuid.v4();
      final now = DateTime.now();

      await _supabaseService.insertCard({
        'id': cardId,
        'deck_id': deckId,
        'card_type': cardType.toJson(),
        'question_type': questionType.toJson(),
        'sort_order': _cards.length,
        'created_at': now.toIso8601String(),
      });

      // Notes (skipped for matchMadness)
      final insertedNotes = <Note>[];
      if (!questionType.usesPairs) {
        final fwd = await _insertNote(
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
        if (fwd != null) insertedNotes.add(fwd);

        // Second reversed note for CardType.both
        if (cardType == CardType.both) {
          final rev = await _insertNote(
            cardId: cardId,
            frontText: backText,
            backText: frontText,
            frontImageUrl: backImageUrl,
            backImageUrl: frontImageUrl,
            frontAudioUrl: backAudioUrl,
            backAudioUrl: frontAudioUrl,
            isReverse: true,
            createdAt: now,
          );
          if (rev != null) insertedNotes.add(rev);
        }
      }

      // Multiple-choice options
      final insertedOptions = <MultipleChoiceOption>[];
      for (var i = 0; i < options.length; i++) {
        final raw = await _supabaseService.insertMCOption({
          ...options[i].toJson(),
          'card_id': cardId,
          'display_order': i,
        });
        if (raw != null) {
          insertedOptions.add(MultipleChoiceOption.fromJson(raw));
        }
      }

      // Fill-in-the-blank segments
      final insertedSegments = <FillInTheBlankSegment>[];
      for (final seg in segments) {
        final raw = await _supabaseService.insertFITBSegment({
          ...seg.toJson(),
          'card_id': cardId,
        });
        if (raw != null) {
          insertedSegments.add(FillInTheBlankSegment.fromJson(raw));
        }
      }

      // Match-madness pairs
      final insertedPairs = <MatchMadnessPair>[];
      for (var i = 0; i < pairs.length; i++) {
        final raw = await _supabaseService.insertMMPair({
          ...pairs[i].toJson(),
          'card_id': cardId,
          'display_order': i,
        });
        if (raw != null) insertedPairs.add(MatchMadnessPair.fromJson(raw));
      }

      final card = DeckCard(
        id: cardId,
        deckId: deckId,
        cardType: cardType,
        questionType: questionType,
        sortOrder: _cards.length,
        createdAt: now,
        notes: insertedNotes,
        options: insertedOptions,
        segments: insertedSegments,
        pairs: insertedPairs,
      );

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
      await _hiveService.deleteCard(cardId);
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

  // ── Private helpers ──────────────────────────────────────────────────

  Future<Note?> _insertNote({
    required String cardId,
    required String frontText,
    required String backText,
    required bool isReverse,
    required DateTime createdAt,
    String? frontImageUrl,
    String? backImageUrl,
    String? frontAudioUrl,
    String? backAudioUrl,
  }) async {
    final raw = await _supabaseService.insertNote({
      'id': _uuid.v4(),
      'card_id': cardId,
      'front_text': frontText,
      'back_text': backText,
      'front_image_url': frontImageUrl,
      'back_image_url': backImageUrl,
      'front_audio_url': frontAudioUrl,
      'back_audio_url': backAudioUrl,
      'is_reverse': isReverse,
      'created_at': createdAt.toIso8601String(),
    });
    return raw != null ? Note.fromJson(raw) : null;
  }
}

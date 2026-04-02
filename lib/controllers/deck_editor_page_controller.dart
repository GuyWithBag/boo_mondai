// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/deck_editor_page_controller.dart
// PURPOSE: Manages the working copy of a Deck, DeckCards, and Editor Form State
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/repositories/repositories.barrel.dart';
import 'package:flutter/foundation.dart';

class DeckEditorPageController extends ChangeNotifier {
  final DeckRepository _deckRepository = Repositories.deck;
  final DeckCardRepository _deckCardRepository = Repositories.deckCard;

  // ── State ────────────────────────────────────────

  Deck? _deck;
  List<DeckCard> _cards = [];
  bool _isDirty = false;
  bool _isLoading = false;
  String? _error;

  // Editor State
  String? _activeCardId;
  final DeckCardFormState formState = DeckCardFormState.empty();

  // ── Getters ───────────────────────────────────────

  Deck? get deck => _deck;
  List<DeckCard> get cards => List.unmodifiable(_cards);
  bool get isDirty => _isDirty;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get activeCardId => _activeCardId;

  @override
  void dispose() {
    formState.dispose();
    super.dispose();
  }

  Future<void> loadDeck(String deckId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Assuming you have methods like getById or similar in your repos
      _deck = _deckRepository.getById(deckId);
      _cards = _deckCardRepository.getByDeckId(deckId);
    } on Exception catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // ── Form ↔ DeckCard Integration ───────────────────

  /// Selects a card, saving the current draft first if one exists.
  void selectCard(String? cardId) {
    if (_activeCardId != null) {
      saveActiveCardToDraft();
    }

    _activeCardId = cardId;

    if (cardId != null) {
      final card = _cards.where((c) => c.id == cardId).firstOrNull;
      if (card != null) {
        _populateFormFromCard(card);
      }
    }
    notifyListeners();
  }

  /// Pushes the current form data into the working memory `_cards` list
  void saveActiveCardToDraft() {
    if (_activeCardId == null) return;

    final draft = _cards.where((c) => c.id == _activeCardId).firstOrNull;
    final updated = _mergeFormIntoDraft(draft);

    if (updated != null) {
      _cards = [
        for (final c in _cards)
          if (c.id == updated.id) updated else c,
      ];
      _isDirty = true;
      notifyListeners();
    }
  }

  /// Creates a blank card, adds it to the list, and automatically selects it.
  void addBlankCard() {
    if (_deck == null) return;

    final newCard = DeckCard.now(
      deckId: _deck!.id,
      cardType: CardType.normal,
      questionType: QuestionType.flashcard,
      sortOrder: _cards.length,
    );

    _cards = [..._cards, newCard];
    _isDirty = true;
    selectCard(
      newCard.id,
    ); // Automatically saves the old card and loads the new one
  }

  // ── Deck Persistence ───────────────────────────────

  Future<void> saveDeck() async {
    if (_deck == null) return;

    saveActiveCardToDraft(); // Ensure current user interface edits are merged before saving

    _isLoading = true;
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

  // ── Private Helpers ───────────────────────────────

  void _populateFormFromCard(DeckCard card) {
    formState.questionType.value = card.questionType;
    formState.cardType.value = card.cardType;
    formState.frontController.text = card.question;
    formState.backController.text = card.answer;
    formState.identificationAnswerController.text = card.identificationAnswer;

    formState.multipleChoiceOptions.value = card.options.isNotEmpty
        ? card.options
              .map((o) => (text: o.optionText, isCorrect: o.isCorrect))
              .toList()
        : [...defaultMultipleChoiceOptions];

    if (card.segments.isNotEmpty) {
      formState.fillInTheBlankSentenceController.text =
          card.segments.first.fullText;
      formState.fillInTheBlankAnswersController.text = card.segments
          .map((seg) => seg.correctAnswer.replaceAll(',', r'\,'))
          .join(',');
    } else {
      formState.fillInTheBlankSentenceController.clear();
      formState.fillInTheBlankAnswersController.clear();
    }

    formState.matchPairs.value = card.pairs.isNotEmpty
        ? card.pairs.map((p) => (term: p.term, match: p.match)).toList()
        : [...defaultMatchPairs];
  }

  DeckCard? _mergeFormIntoDraft(DeckCard? draft) {
    if (draft == null) return null;

    final qType = formState.questionType.value;
    final backTextForSave =
        (qType.usesIdentificationAnswer || qType == QuestionType.wordScramble)
        ? ''
        : formState.backController.text.trim();

    final updatedNotes = draft.notes.map((n) {
      return n == draft.primaryNote
          ? n.copyWith(
              frontText: formState.frontController.text.trim(),
              backText: backTextForSave,
            )
          : n;
    }).toList();

    return draft.copyWith(
      notes: updatedNotes,
      cardType: formState.cardType.value,
      questionType: qType,
      identificationAnswer: qType.usesIdentificationAnswer
          ? formState.identificationAnswerController.text.trim()
          : '',
      // Note: Implement your _buildOptions, _buildSegments, _buildPairs methods here as you had them in the original file
    );
  }
}

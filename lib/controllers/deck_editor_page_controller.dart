// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/deck_editor_page_controller.dart
// PURPOSE: Manages the working copy of a Deck and its DeckCards during editing
// PROVIDERS: DeckEditorPageController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/repositories/repositories.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';
import 'package:flutter/foundation.dart';
import 'deck_editor_types.dart';

/// Drives the Deck Editor page — holds a working copy of the [Deck] and its
/// [DeckCard]s, tracks dirtiness, and persists via [save].
class DeckEditorPageController extends ChangeNotifier {
  final DeckRepository _deckRepository = Repositories.deck;
  final DeckCardRepository _deckCardRepository = Repositories.deckCard;

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

  // ── deck + card CRUD ─────────────────────────────────────

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
      id: UuidService.uuid.v4(),
      authorId: 'local',
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

  /// Creates a blank flashcard, appends it to the working list, and returns
  /// the new card's id so the page can select it.
  DeckCard createBlankCard(String deckId) {
    final card = DeckCard.create(
      deckId: deckId,
      cardType: CardType.normal,
      questionType: QuestionType.flashcard,
      sortOrder: _cards.length,
    );
    addCard(card);
    return card;
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

  // ── Form ↔ DeckCard helpers ────────────────────────────────────

  /// Populates every field in [form] from [card]'s data.
  /// Called when the user selects a different card in the sidebar.
  void populateFormFromCard(DeckCard card, DeckCardForm form) {
    form.qType.value = card.questionType;
    form.cType.value = card.cardType;
    form.frontCtrl.text = card.question;
    form.backCtrl.text = card.answer;
    form.identificationAnsCtrl.text = card.identificationAnswer;

    form.mcOpts.value = card.options.isNotEmpty
        ? card.options
              .map((o) => (text: o.optionText, isCorrect: o.isCorrect))
              .toList()
        : [...defaultMcOpts];

    if (card.segments.isNotEmpty) {
      form.fitbSentCtrl.text = card.segments.first.fullText;
      form.fitbAnsCtrl.text = card.segments
          .map((seg) => seg.correctAnswer.replaceAll(',', r'\,'))
          .join(',');
    } else {
      form.fitbSentCtrl.clear();
      form.fitbAnsCtrl.clear();
    }

    form.matchPairs.value = card.pairs.isNotEmpty
        ? card.pairs.map((p) => (term: p.term, match: p.match)).toList()
        : [...defaultMatchPairs];
  }

  /// Merges the current [form] values back into [draft], producing an
  /// updated [DeckCard]. Returns null when [draft] is null (no card selected).
  DeckCard? mergeFormIntoDraft(DeckCard? draft, DeckCardForm form) {
    if (draft == null) return null;

    final qType = form.qType.value;

    final backTextForSave =
        qType.usesIdentificationAnswer || qType == QuestionType.wordScramble
        ? ''
        : form.backCtrl.text.trim();

    final updatedNotes = draft.notes
        .map(
          (n) => n == draft.primaryNote
              ? n.copyWith(
                  frontText: form.frontCtrl.text.trim(),
                  backText: backTextForSave,
                )
              : n,
        )
        .toList();

    return draft.copyWith(
      notes: updatedNotes,
      cardType: form.cType.value,
      questionType: qType,
      identificationAnswer: qType.usesIdentificationAnswer
          ? form.identificationAnsCtrl.text.trim()
          : '',
      options: qType.usesOptions
          ? _buildOptions(form.mcOpts.value)
          : draft.options,
      segments: qType.usesSegments
          ? _buildSegments(form.fitbSentCtrl.text, form.fitbAnsCtrl.text)
          : draft.segments,
      pairs: qType.usesPairs ? _buildPairs(form.matchPairs.value) : draft.pairs,
    );
  }

  // ── Private editor-specific converters ───────────────────────

  static List<MultipleChoiceOption> _buildOptions(List<McOpt> opts) => [
    for (var i = 0; i < opts.length; i++)
      if (opts[i].text.trim().isNotEmpty)
        MultipleChoiceOption(
          id: '',
          cardId: '',
          optionText: opts[i].text.trim(),
          isCorrect: opts[i].isCorrect,
          displayOrder: i,
        ),
  ];

  static List<FillInTheBlankSegment> _buildSegments(
    String sentence,
    String answersRaw,
  ) {
    final s = sentence.trim();
    if (s.isEmpty) return [];
    final answers = splitFitbAnswers(answersRaw);
    if (answers.isEmpty) return [];
    final sl = s.toLowerCase();
    return [
      for (final a in answers)
        if (sl.contains(a.toLowerCase()))
          FillInTheBlankSegment(
            id: '',
            cardId: '',
            fullText: s,
            blankStart: sl.indexOf(a.toLowerCase()),
            blankEnd: sl.indexOf(a.toLowerCase()) + a.length,
            correctAnswer: a,
          ),
    ];
  }

  static List<MatchMadnessPair> _buildPairs(List<Pair> ps) => [
    for (var i = 0; i < ps.length; i++)
      if (ps[i].term.trim().isNotEmpty && ps[i].match.trim().isNotEmpty)
        MatchMadnessPair(
          id: '',
          cardId: '',
          term: ps[i].term.trim(),
          match: ps[i].match.trim(),
          isAutoPicked: false,
          displayOrder: i,
        ),
  ];
}

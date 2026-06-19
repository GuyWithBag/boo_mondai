// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/deck_editor_page_controller.dart
// PURPOSE: Manages the working copy of a Deck, CardTemplates, and Editor Form State
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        CardTemplate,
        Deck,
        DeckCardFormState,
        FlashcardTemplate,
        IdentificationTemplate,
        MultipleChoiceTemplate,
        FillInTheBlanksTemplate,
        WordScrambleTemplate,
        MatchMadnessTemplate,
        MultipleChoiceOption,
        FillInTheBlankSegment,
        MatchMadnessPair,
        LocalDB,
        uuid,
        CardType,
        QuestionType,
        StudyCardService,
        MultipleChoiceOptionData,
        defaultMultipleChoiceOptions,
        MatchPairData,
        defaultMatchPairs,
        TextHelper;

class EditDeckController extends Controller {
  EditDeckController({required String deckId, String? initialTemplateId}) {
    loadDeck(deckId);
    if (initialTemplateId != null) {
      selectTemplate(initialTemplateId);
    }
  }

  Deck? _deck;
  List<CardTemplate> _templates = []; // Replaced _cards
  bool _isDirty = false;

  // Editor State
  String? _activeTemplateId; // Replaced _activeCardId
  final DeckCardFormState formState = DeckCardFormState.empty();

  // ── Getters ───────────────────────────────────────

  Deck? get deck => _deck;
  List<CardTemplate> get templates => List.unmodifiable(_templates);
  bool get isDirty => _isDirty;
  String? get activeTemplateId => _activeTemplateId;

  void updateDeckTitle(String title) {
    final deck = _deck;
    if (deck == null || deck.title == title.trim()) return;

    _deck = deck.copyWith(title: title.trim());
    _isDirty = true;
    notifyListeners();
  }

  @override
  void dispose() {
    formState.dispose();
    super.dispose();
  }

  Future<void> loadDeck(String deckId) async {
    setLoading(true);

    try {
      _deck = LocalDB.deck.selectByPk({'id': deckId});
      _templates = LocalDB.cardTemplate.getByDeckId(deckId);
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  // ── Form ↔ Template Integration ───────────────────

  /// Selects a template, saving the current draft first if one exists.
  void selectTemplate(String? templateId) {
    if (_activeTemplateId != null) {
      saveActiveTemplateToDraft();
    }

    _activeTemplateId = templateId;

    if (templateId != null) {
      final template = _templates.where((t) => t.id == templateId).firstOrNull;
      if (template != null) {
        _populateFormFromTemplate(template);
      }
    }
    notifyListeners();
  }

  /// Pushes the current form data into the working memory `_templates` list
  void saveActiveTemplateToDraft() {
    if (_activeTemplateId == null) return;

    final draft = _templates
        .where((t) => t.id == _activeTemplateId)
        .firstOrNull;
    final updated = _mergeFormIntoDraft(draft);

    if (updated != null) {
      _templates = [
        for (final t in _templates)
          if (t.id == updated.id) updated else t,
      ];
      _isDirty = true;
      notifyListeners();
    }
  }

  /// Creates a blank flashcard, adds it to the list, and automatically selects it.
  void addBlankTemplate() {
    if (_deck == null) return;

    // Default to a basic FlashcardTemplate when adding new
    final newTemplate = FlashcardTemplate(
      id: uuid.v7(),
      updatedAt: DateTime.now(),
      deckId: _deck!.id,
      sortOrder: _templates.length,
      createdAt: DateTime.now(),
      frontText: '',
      backText: '',
    );

    _templates = [..._templates, newTemplate];
    _isDirty = true;
    selectTemplate(newTemplate.id);
  }

  // ── Deck Persistence ───────────────────────────────
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // PATH: lib/controllers/deck_editor_page_controller.dart
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Future<void> saveDeck() async {
    if (_deck == null) return;

    saveActiveTemplateToDraft();

    setLoading(true);

    try {
      final updatedDeck = _deck!.copyWith(
        cardCount: _templates.length,
        updatedAt: DateTime.now(),
      );

      await LocalDB.deck.upsert(updatedDeck);
      await LocalDB.cardTemplate.upsertMany(_templates);
      await StudyCardService.syncDeckStudyCards(
        deckId: updatedDeck.id,
        templates: _templates,
      );

      _deck = updatedDeck;
      _isDirty = false;
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  // ── Private Helpers ───────────────────────────────

  void _populateFormFromTemplate(CardTemplate template) {
    // Reset the form so old data doesn't bleed over
    formState.cardType.value = CardType.normal;
    formState.frontController.clear();
    formState.backController.clear();
    formState.identificationAnswerController.clear();
    formState.fillInTheBlankSentenceController.clear();
    formState.fillInTheBlankAnswersController.clear();

    // Use Dart 3 pattern matching to extract data precisely
    switch (template) {
      case FlashcardTemplate f:
        formState.questionType.value = QuestionType.flashcard;
        formState.cardType.value = f.cardType;
        formState.frontController.text = f.frontText;
        formState.backController.text = f.backText;
        break;

      case IdentificationTemplate i:
        formState.questionType.value = QuestionType.identification;
        formState.frontController.text = i.promptText;
        formState.identificationAnswerController.text = i.acceptedAnswers;
        break;

      case MultipleChoiceTemplate m:
        formState.questionType.value = QuestionType.multipleChoice;
        formState.frontController.text = m.questionPrompt;
        formState.multipleChoiceOptions.value = m.options.isNotEmpty
            ? m.options
                  .map(
                    (o) => MultipleChoiceOptionData(
                      text: o.optionText,
                      isCorrect: o.isCorrect,
                    ),
                  )
                  .toList()
            : [...defaultMultipleChoiceOptions];
        break;

      case FillInTheBlanksTemplate fb:
        formState.questionType.value = QuestionType.fillInTheBlanks;
        if (fb.segments.isNotEmpty) {
          formState.fillInTheBlankSentenceController.text =
              fb.segments.first.fullText; // Assuming logic holds
          formState.fillInTheBlankAnswersController.text = fb.segments
              .map((seg) => seg.correctAnswer.replaceAll(',', r'\,'))
              .join(',');
        }
        break;

      case WordScrambleTemplate ws:
        formState.questionType.value = QuestionType.wordScramble;
        formState.frontController.text = ws.sentenceToScramble;
        break;

      case MatchMadnessTemplate mm:
        formState.questionType.value = QuestionType.matchMadness;
        formState.matchPairs.value = mm.pairs.isNotEmpty
            ? mm.pairs
                  .map((p) => MatchPairData(term: p.term, match: p.match))
                  .toList()
            : [...defaultMatchPairs];
        break;

      default:
        break;
    }
  }

  CardTemplate? _mergeFormIntoDraft(CardTemplate? draft) {
    if (draft == null || _deck == null) return null;

    final qType = formState.questionType.value;

    // Preserve the shared base metadata
    final id = draft.id;
    final deckId = draft.deckId;
    final sortOrder = draft.sortOrder;
    final createdAt = draft.createdAt;
    final sourceId = draft.sourceTemplateId;

    // Build the specific template based on what the UI dropdown is currently set to
    switch (qType) {
      case QuestionType.flashcard:
        return FlashcardTemplate(
          id: id,
          updatedAt: DateTime.now(),

          deckId: deckId,
          sortOrder: sortOrder,
          createdAt: createdAt,
          sourceTemplateId: sourceId,
          frontText: formState.frontController.text.trim(),
          backText: formState.backController.text.trim(),
          cardType: formState.cardType.value,
        );

      case QuestionType.identification:
        return IdentificationTemplate(
          id: id,
          updatedAt: DateTime.now(),

          deckId: deckId,
          sortOrder: sortOrder,
          createdAt: createdAt,
          sourceTemplateId: sourceId,
          promptText: formState.frontController.text.trim(),
          acceptedAnswers: formState.identificationAnswerController.text.trim(),
        );

      case QuestionType.multipleChoice:
        return MultipleChoiceTemplate(
          id: id,
          deckId: deckId,
          updatedAt: DateTime.now(),

          sortOrder: sortOrder,
          createdAt: createdAt,
          sourceTemplateId: sourceId,
          questionPrompt: formState.frontController.text.trim(),
          options: _buildOptions(id),
        );

      case QuestionType.fillInTheBlanks:
        return FillInTheBlanksTemplate(
          id: id,
          deckId: deckId,
          updatedAt: DateTime.now(),

          sortOrder: sortOrder,
          createdAt: createdAt,
          sourceTemplateId: sourceId,
          segments: _buildSegments(id),
        );

      case QuestionType.wordScramble:
        return WordScrambleTemplate(
          id: id,
          updatedAt: DateTime.now(),

          deckId: deckId,
          sortOrder: sortOrder,
          createdAt: createdAt,
          sourceTemplateId: sourceId,
          sentenceToScramble: formState.frontController.text.trim(),
        );

      case QuestionType.matchMadness:
        return MatchMadnessTemplate(
          id: id,
          deckId: deckId,
          updatedAt: DateTime.now(),

          sortOrder: sortOrder,
          createdAt: createdAt,
          sourceTemplateId: sourceId,
          pairs: _buildPairs(id),
        );
    }
  }

  // ── Build Helpers for Complex Types ───────────────────────────────

  List<MultipleChoiceOption> _buildOptions(String templateId) {
    final tuples = formState.multipleChoiceOptions.value;
    return List.generate(
      tuples.length,
      (i) => MultipleChoiceOption(
        id: uuid.v7(),
        templateId: templateId, // Use the new ID reference
        optionText: tuples[i].text,
        isCorrect: tuples[i].isCorrect,
        displayOrder: i,
      ),
    );
  }

  List<FillInTheBlankSegment> _buildSegments(String templateId) {
    final sentence = formState.fillInTheBlankSentenceController.text.trim();
    final answers = TextHelper.splitCommaSeparated(
      formState.fillInTheBlankAnswersController.text,
    );
    if (sentence.isEmpty || answers.isEmpty) return [];

    final lowerSentence = sentence.toLowerCase();
    var searchStart = 0;
    final segments = <FillInTheBlankSegment>[];

    for (final answer in answers) {
      final lowerAnswer = answer.toLowerCase();
      var blankStart = lowerSentence.indexOf(lowerAnswer, searchStart);
      if (blankStart == -1) {
        blankStart = lowerSentence.indexOf(lowerAnswer);
      }
      if (blankStart == -1) continue;

      final blankEnd = blankStart + answer.length;
      searchStart = blankEnd;
      segments.add(
        FillInTheBlankSegment(
          id: uuid.v7(),
          cardId: templateId,
          fullText: sentence,
          blankStart: blankStart,
          blankEnd: blankEnd,
          correctAnswer: answer,
        ),
      );
    }

    return segments;
  }

  List<MatchMadnessPair> _buildPairs(String templateId) {
    final tuples = formState.matchPairs.value;
    return List.generate(
      tuples.length,
      (i) => MatchMadnessPair(
        id: uuid.v7(),
        templateId: templateId, // Use the new ID reference
        term: tuples[i].term,
        match: tuples[i].match,
        displayOrder: i,
      ),
    );
  }
}

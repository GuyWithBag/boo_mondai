// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/deck_editor_page_controller.dart
// PURPOSE: Manages the working copy of a Deck, CardTemplates, and Editor Form State
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/repositories/repositories.barrel.dart';
import 'package:boo_mondai/services/uuid_service.dart';
import 'package:flutter/foundation.dart';

class DeckEditorPageController extends ChangeNotifier {
  final DeckRepository _deckRepository = Repositories.deck;

  // Update to use the new template repository
  final CardTemplateRepository _templateRepository = Repositories.cardTemplate;

  // ── State ────────────────────────────────────────

  Deck? _deck;
  List<CardTemplate> _templates = []; // Replaced _cards
  bool _isDirty = false;
  bool _isLoading = false;
  String? _error;

  // Editor State
  String? _activeTemplateId; // Replaced _activeCardId
  final DeckCardFormState formState = DeckCardFormState.empty();

  // ── Getters ───────────────────────────────────────

  Deck? get deck => _deck;
  List<CardTemplate> get templates => List.unmodifiable(_templates);
  bool get isDirty => _isDirty;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get activeTemplateId => _activeTemplateId;

  @override
  void dispose() {
    formState.dispose();
    super.dispose();
  }

  Future<void> loadDeck(String deckId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _deck = _deckRepository.getById(deckId);
      _templates = _templateRepository.getByDeckId(deckId);
    } on Exception catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
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
      id: UuidService.uuid.v4(),
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

    _isLoading = true;
    notifyListeners();

    try {
      final updatedDeck = _deck!.copyWith(
        cardCount: _templates.length,
        updatedAt: DateTime.now(),
      );

      await _deckRepository.save(updatedDeck);
      await _templateRepository.saveAll(_templates);

      // ── THE CLEAN WAY TO GENERATE REVIEW CARDS ──────────

      // 1. Fetch the review cards that already exist for this deck
      final existingReviewCards = Repositories.reviewCard.getByDeckId(
        _deck!.id,
      );

      // 2. Create a fast-lookup set of template IDs that already have review cards
      final existingTemplateIds = existingReviewCards
          .map((rc) => rc.templateId)
          .toSet();

      // 3. Only generate a new ReviewCard if the template doesn't have one yet
      final newReviewCards = <ReviewCard>[];
      for (final template in _templates) {
        if (!existingTemplateIds.contains(template.id)) {
          newReviewCards.add(
            ReviewCard(
              id: UuidService.uuid.v4(), // strictly opaque, clean UUID
              deckId: template.deckId,
              templateId: template.id,
              isReversed: false,
            ),
          );
        }
      }

      // 4. Save only the newly generated ones
      if (newReviewCards.isNotEmpty) {
        await Repositories.reviewCard.saveAll(newReviewCards);
      }
      // ─────────────────────────────────────────────────────

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

  void _populateFormFromTemplate(CardTemplate template) {
    // Reset the form so old data doesn't bleed over
    formState.frontController.clear();
    formState.backController.clear();
    formState.identificationAnswerController.clear();
    formState.fillInTheBlankSentenceController.clear();
    formState.fillInTheBlankAnswersController.clear();

    // Use Dart 3 pattern matching to extract data precisely
    switch (template) {
      case FlashcardTemplate f:
        formState.questionType.value = QuestionType.flashcard;
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
                  .map((o) => (text: o.optionText, isCorrect: o.isCorrect))
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
            ? mm.pairs.map((p) => (term: p.term, match: p.match)).toList()
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
          deckId: deckId,
          sortOrder: sortOrder,
          createdAt: createdAt,
          sourceTemplateId: sourceId,
          frontText: formState.frontController.text.trim(),
          backText: formState.backController.text.trim(),
        );

      case QuestionType.identification:
        return IdentificationTemplate(
          id: id,
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
          sortOrder: sortOrder,
          createdAt: createdAt,
          sourceTemplateId: sourceId,
          segments: _buildSegments(id),
        );

      case QuestionType.wordScramble:
        return WordScrambleTemplate(
          id: id,
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
        id: UuidService.uuid.v4(),
        templateId: templateId, // Use the new ID reference
        optionText: tuples[i].text,
        isCorrect: tuples[i].isCorrect,
        displayOrder: i,
      ),
    );
  }

  List<FillInTheBlankSegment> _buildSegments(String templateId) {
    // Note: Re-implement your segment parsing logic here based on your UI's controllers
    // Example placeholder:
    return [];
  }

  List<MatchMadnessPair> _buildPairs(String templateId) {
    final tuples = formState.matchPairs.value;
    return List.generate(
      tuples.length,
      (i) => MatchMadnessPair(
        id: UuidService.uuid.v4(),
        templateId: templateId, // Use the new ID reference
        term: tuples[i].term,
        match: tuples[i].match,
        displayOrder: i,
      ),
    );
  }
}

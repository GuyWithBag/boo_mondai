import 'package:boo_mondai/core/services/uuid.dart';
import 'package:boo_mondai/features/cards/models/card_template.dto.dart';
import 'package:boo_mondai/features/cards/models/card_type.dto.dart';
import 'package:boo_mondai/features/cards/models/fill_in_the_blank_segment.dto.dart';
import 'package:boo_mondai/features/cards/models/fill_in_the_blanks_template.dto.dart';
import 'package:boo_mondai/features/cards/models/flashcard_template.dto.dart';
import 'package:boo_mondai/features/cards/models/identification_template.dto.dart';
import 'package:boo_mondai/features/cards/models/match_madness_pair.dto.dart';
import 'package:boo_mondai/features/cards/models/match_madness_template.dto.dart';
import 'package:boo_mondai/features/cards/models/match_pair_data.dto.dart';
import 'package:boo_mondai/features/cards/models/multiple_choice_option.dto.dart';
import 'package:boo_mondai/features/cards/models/multiple_choice_option_data.dto.dart';
import 'package:boo_mondai/features/cards/models/multiple_choice_template.dto.dart';
import 'package:boo_mondai/features/cards/models/word_scramble_template.dart';
import 'package:boo_mondai/features/decks/models/deck.dto.dart';
import 'package:boo_mondai/features/edit_deck/helpers/edit_deck_question_type.helper.dart';
import 'package:boo_mondai/features/edit_deck/models/card_template.form_state.dart';
import 'package:boo_mondai/features/edit_deck/models/deck_editor_types.dart';
import 'package:boo_mondai/features/edit_deck/models/question_type.dart';
import 'package:boo_mondai/lib.barrel.dart' show StringHelper;

abstract interface class DraftFormAdapter<TDraft> {
  String draftId(TDraft draft);
  void populateFormFromDraft(TDraft draft);
  TDraft? mergeFormIntoDraft(TDraft? draft);
}

class DraftFormSession<TDraft> {
  DraftFormSession({required this.adapter, List<TDraft> drafts = const []})
    : _drafts = [...drafts];

  final DraftFormAdapter<TDraft> adapter;

  List<TDraft> _drafts;
  String? _activeDraftId;

  List<TDraft> get drafts => List.unmodifiable(_drafts);
  String? get activeDraftId => _activeDraftId;
  TDraft? get activeDraft {
    final activeDraftId = _activeDraftId;
    if (activeDraftId == null) return null;

    return _drafts
        .where((draft) => adapter.draftId(draft) == activeDraftId)
        .firstOrNull;
  }

  void setDrafts(List<TDraft> drafts) {
    _drafts = [...drafts];
    if (_activeDraftId case final activeDraftId?
        when !_drafts.any((draft) => adapter.draftId(draft) == activeDraftId)) {
      _activeDraftId = null;
    }
  }

  void selectDraft(String? draftId) {
    saveActiveDraft();

    _activeDraftId = draftId;
    final draft = activeDraft;
    if (draft != null) {
      adapter.populateFormFromDraft(draft);
    }
  }

  TDraft? saveActiveDraft() {
    final draft = activeDraft;
    if (draft == null) return null;

    final updated = adapter.mergeFormIntoDraft(draft);
    if (updated == null) return null;

    replaceDraft(updated);
    return updated;
  }

  void addDraft(TDraft draft, {bool select = true}) {
    _drafts = [..._drafts, draft];
    if (select) {
      selectDraft(adapter.draftId(draft));
    }
  }

  void replaceDraft(TDraft draft) {
    final draftId = adapter.draftId(draft);
    _drafts = [
      for (final current in _drafts)
        if (adapter.draftId(current) == draftId) draft else current,
    ];
  }

  List<TDraft> commitAll() {
    saveActiveDraft();
    return drafts;
  }
}

class CardTemplateDraftFormAdapter implements DraftFormAdapter<CardTemplate> {
  const CardTemplateDraftFormAdapter({required this.formState});

  final CardTemplateFormState formState;

  @override
  String draftId(CardTemplate draft) => draft.id;

  @override
  void populateFormFromDraft(CardTemplate draft) {
    formState.cardType.value = CardType.normal;
    formState.verticallyCentered.value = true;
    formState.frontController.clear();
    formState.backController.clear();
    formState.identificationAnswerController.clear();
    formState.fillInTheBlankSentenceController.clear();
    formState.fillInTheBlankAnswersController.clear();

    switch (draft) {
      case FlashcardTemplate f:
        formState.questionType.value = QuestionType.flashcard;
        formState.cardType.value = f.cardType;
        formState.verticallyCentered.value = f.verticallyCentered;
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
        formState.verticallyCentered.value = m.verticallyCentered;
        formState.frontController.text = m.questionPrompt;
        formState.multipleChoiceOptions.value = m.options.isNotEmpty
            ? m.options
                  .map(
                    (option) => MultipleChoiceOptionData(
                      text: option.optionText,
                      isCorrect: option.isCorrect,
                    ),
                  )
                  .toList()
            : [...defaultMultipleChoiceOptions];
        break;

      case FillInTheBlanksTemplate fb:
        formState.questionType.value = QuestionType.fillInTheBlanks;
        formState.verticallyCentered.value = fb.verticallyCentered;
        if (fb.segments.isNotEmpty) {
          formState.fillInTheBlankSentenceController.text =
              fb.segments.first.fullText;
          formState.fillInTheBlankAnswersController.text = fb.segments
              .map((segment) => segment.correctAnswer.replaceAll(',', r'\,'))
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
                  .map(
                    (pair) => MatchPairData(term: pair.term, match: pair.match),
                  )
                  .toList()
            : [...defaultMatchPairs];
        break;

      default:
        break;
    }

    ensureVisibleQuestionType();
  }

  void ensureVisibleQuestionType() {
    if (EditDeckQuestionTypeHelper.isVisible(formState.questionType.value)) {
      return;
    }

    formState.questionType.value = QuestionType.flashcard;
    formState.cardType.value = CardType.normal;
    formState.verticallyCentered.value = true;
  }

  @override
  CardTemplate? mergeFormIntoDraft(CardTemplate? draft) {
    if (draft == null) return null;

    final questionType = formState.questionType.value;
    final id = draft.id;
    final deckId = draft.deckId;
    final sortOrder = draft.sortOrder;
    final createdAt = draft.createdAt;
    final sourceId = draft.sourceTemplateId;
    final updatedAt = DateTime.now();

    return switch (questionType) {
      QuestionType.flashcard => FlashcardTemplate(
        id: id,
        deckId: deckId,
        sortOrder: sortOrder,
        createdAt: createdAt,
        updatedAt: updatedAt,
        sourceTemplateId: sourceId,
        verticallyCentered: formState.verticallyCentered.value,
        frontText: formState.frontController.text.trim(),
        backText: formState.backController.text.trim(),
        cardType: formState.cardType.value,
      ),
      QuestionType.identification => IdentificationTemplate(
        id: id,
        deckId: deckId,
        sortOrder: sortOrder,
        createdAt: createdAt,
        updatedAt: updatedAt,
        sourceTemplateId: sourceId,
        promptText: formState.frontController.text.trim(),
        acceptedAnswers: formState.identificationAnswerController.text.trim(),
      ),
      QuestionType.multipleChoice => MultipleChoiceTemplate(
        id: id,
        deckId: deckId,
        sortOrder: sortOrder,
        createdAt: createdAt,
        updatedAt: updatedAt,
        sourceTemplateId: sourceId,
        verticallyCentered: formState.verticallyCentered.value,
        questionPrompt: formState.frontController.text.trim(),
        options: _buildOptions(id),
      ),
      QuestionType.fillInTheBlanks => FillInTheBlanksTemplate(
        id: id,
        deckId: deckId,
        sortOrder: sortOrder,
        createdAt: createdAt,
        updatedAt: updatedAt,
        sourceTemplateId: sourceId,
        verticallyCentered: formState.verticallyCentered.value,
        segments: _buildSegments(id),
      ),
      QuestionType.wordScramble => WordScrambleTemplate(
        id: id,
        deckId: deckId,
        sortOrder: sortOrder,
        createdAt: createdAt,
        updatedAt: updatedAt,
        sourceTemplateId: sourceId,
        sentenceToScramble: formState.frontController.text.trim(),
      ),
      QuestionType.matchMadness => MatchMadnessTemplate(
        id: id,
        deckId: deckId,
        sortOrder: sortOrder,
        createdAt: createdAt,
        updatedAt: updatedAt,
        sourceTemplateId: sourceId,
        pairs: _buildPairs(id),
      ),
    };
  }

  CardTemplate createDraft({
    required Deck deck,
    required QuestionType questionType,
    required CardType cardType,
    required int sortOrder,
  }) {
    final now = DateTime.now();
    final id = uuid.v7();

    return switch (questionType) {
      QuestionType.flashcard => FlashcardTemplate(
        id: id,
        deckId: deck.id,
        sortOrder: sortOrder,
        createdAt: now,
        updatedAt: now,
        frontText: '',
        backText: '',
        cardType: cardType,
        verticallyCentered: formState.verticallyCentered.value,
      ),
      QuestionType.multipleChoice => MultipleChoiceTemplate(
        id: id,
        deckId: deck.id,
        sortOrder: sortOrder,
        createdAt: now,
        updatedAt: now,
        questionPrompt: '',
        verticallyCentered: formState.verticallyCentered.value,
        options: [
          for (
            var index = 0;
            index < defaultMultipleChoiceOptions.length;
            index++
          )
            MultipleChoiceOption(
              id: uuid.v7(),
              templateId: id,
              optionText: defaultMultipleChoiceOptions[index].text,
              isCorrect: defaultMultipleChoiceOptions[index].isCorrect,
              displayOrder: index,
            ),
        ],
      ),
      QuestionType.fillInTheBlanks => FillInTheBlanksTemplate(
        id: id,
        deckId: deck.id,
        sortOrder: sortOrder,
        createdAt: now,
        updatedAt: now,
        verticallyCentered: formState.verticallyCentered.value,
        segments: const [],
      ),
      QuestionType.matchMadness => MatchMadnessTemplate(
        id: id,
        deckId: deck.id,
        sortOrder: sortOrder,
        createdAt: now,
        updatedAt: now,
        pairs: [
          for (var index = 0; index < defaultMatchPairs.length; index++)
            MatchMadnessPair(
              id: uuid.v7(),
              templateId: id,
              term: defaultMatchPairs[index].term,
              match: defaultMatchPairs[index].match,
              displayOrder: index,
            ),
        ],
      ),
      QuestionType.identification => IdentificationTemplate(
        id: id,
        deckId: deck.id,
        sortOrder: sortOrder,
        createdAt: now,
        updatedAt: now,
        promptText: '',
        acceptedAnswers: '',
      ),
      QuestionType.wordScramble => WordScrambleTemplate(
        id: id,
        deckId: deck.id,
        sortOrder: sortOrder,
        createdAt: now,
        updatedAt: now,
        sentenceToScramble: '',
      ),
    };
  }

  List<MultipleChoiceOption> _buildOptions(String templateId) {
    final tuples = formState.multipleChoiceOptions.value;
    return List.generate(
      tuples.length,
      (index) => MultipleChoiceOption(
        id: uuid.v7(),
        templateId: templateId,
        optionText: tuples[index].text,
        isCorrect: tuples[index].isCorrect,
        displayOrder: index,
      ),
    );
  }

  List<FillInTheBlankSegment> _buildSegments(String templateId) {
    final sentence = formState.fillInTheBlankSentenceController.text.trim();
    final answers = StringHelper.toTrimmedCommaSeparatedValues(
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
      (index) => MatchMadnessPair(
        id: uuid.v7(),
        templateId: templateId,
        term: tuples[index].term,
        match: tuples[index].match,
        displayOrder: index,
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/deck_editor_page_controller.dart
// PURPOSE: Manages the working copy of a Deck, CardTemplates, and Editor Form State
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        CardTemplate,
        Deck,
        CardTemplateFormState,
        LocalDB,
        QuestionType,
        EditDeckQuestionTypeHelper,
        CardTemplateDraftFormAdapter,
        DraftFormSession,
        EditDeckService;
import 'package:flutter/material.dart' show TextEditingController;

import 'package:flutter_hooks/flutter_hooks.dart'
    show useEffect, useListenable, useMemoized;

EditDeckController useEditDeckController({
  required String deckId,
  String? initialTemplateId,
}) {
  final controller = useMemoized(
    () => EditDeckController(
      deckId: deckId,
      initialTemplateId: initialTemplateId,
    ),
    [deckId, initialTemplateId],
  );

  useListenable(controller);
  useEffect(() => controller.dispose, [controller]);

  return controller;
}

class EditDeckController extends Controller {
  EditDeckController({required String deckId, String? initialTemplateId}) {
    _pendingInitialTemplateId = initialTemplateId;
    loadDeck(deckId);
  }

  Deck? _deck;
  bool _isDirty = false;
  String? _pendingInitialTemplateId;

  // Editor State
  final TextEditingController titleController = TextEditingController();
  final CardTemplateFormState formState = CardTemplateFormState.empty();
  late final CardTemplateDraftFormAdapter _draftAdapter =
      CardTemplateDraftFormAdapter(formState: formState);
  late final DraftFormSession<CardTemplate> _draftSession = DraftFormSession(
    adapter: _draftAdapter,
  );

  // ── Getters ───────────────────────────────────────

  Deck? get deck => _deck;
  List<CardTemplate> get templateDrafts => _draftSession.drafts;
  List<CardTemplate> get templates => templateDrafts;
  bool get isDirty => _isDirty;
  String? get activeTemplateId => _draftSession.activeDraftId;
  CardTemplate? get activeTemplate => _draftSession.activeDraft;
  bool get hasActiveTemplate => activeTemplateId != null;
  QuestionType get questionType => formState.questionType.value;
  int get selectedFormatIndex =>
      EditDeckQuestionTypeHelper.selectedFormatIndex(questionType);

  void setFormatIndex(int index) {
    setQuestionType(EditDeckQuestionTypeHelper.questionTypeAt(index));
  }

  void setQuestionType(QuestionType value) {
    formState.questionType.value = EditDeckQuestionTypeHelper.isVisible(value)
        ? value
        : QuestionType.flashcard;
    formState.cardType.value =
        EditDeckQuestionTypeHelper.cardTypeForQuestionType(
          formState.questionType.value,
          formState.cardType.value,
        );
    notifyListeners();
  }

  void ensureVisibleQuestionType() {
    if (EditDeckQuestionTypeHelper.isVisible(questionType)) return;

    _draftAdapter.ensureVisibleQuestionType();
    notifyListeners();
  }

  void updateDeckTitle(String title) {
    final deck = _deck;
    if (deck == null || deck.title == title.trim()) return;

    _deck = deck.copyWith(title: title.trim());
    _isDirty = true;
    notifyListeners();
  }

  void markDirty() {
    if (_isDirty) return;

    _isDirty = true;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    formState.dispose();
    super.dispose();
  }

  Future<void> loadDeck(String deckId) async {
    setLoading(true);

    try {
      _deck = LocalDB.deck.selectByPk({'id': deckId});
      _syncTitleController();
      _draftSession.setDrafts(LocalDB.cardTemplate.getByDeckId(deckId));

      final pendingInitialTemplateId = _pendingInitialTemplateId;
      final initialTemplate = _draftSession.drafts.where((template) {
        return template.id == pendingInitialTemplateId;
      }).firstOrNull;
      final templateToSelect =
          initialTemplate ?? _draftSession.drafts.firstOrNull;

      _pendingInitialTemplateId = null;
      if (templateToSelect != null) {
        selectTemplate(templateToSelect.id);
      }
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  // ── Form ↔ Template Integration ───────────────────

  /// Selects a template, saving the current draft first if one exists.
  void selectTemplate(String? templateId) {
    _draftSession.selectDraft(templateId);
    notifyListeners();
  }

  /// Pushes the current form data into the working-memory draft list.
  void saveActiveTemplateToDraft() {
    final updated = _draftSession.saveActiveDraft();
    if (updated != null) {
      _isDirty = true;
      notifyListeners();
    }
  }

  /// Creates a blank template for the currently selected question type,
  /// adds it to the list, and automatically selects it.
  void addTemplate() {
    if (_deck == null) return;

    final newTemplate = _draftAdapter.createDraft(
      deck: _deck!,
      questionType: questionType,
      cardType: formState.cardType.value,
      sortOrder: _draftSession.drafts.length,
    );

    _draftSession.addDraft(newTemplate);
    _isDirty = true;
    notifyListeners();
  }

  // ── Deck Persistence ───────────────────────────────
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // PATH: lib/controllers/deck_editor_page_controller.dart
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Future<void> saveDeck({String? title}) async {
    if (_deck == null) return;

    if (title != null) {
      updateDeckTitle(title);
    }
    final templateDrafts = _draftSession.commitAll();

    setLoading(true);

    try {
      final updatedDeck = await EditDeckService.saveDeck(
        deck: _deck!,
        templateDrafts: templateDrafts,
        title: title,
      );

      _deck = updatedDeck;
      _syncTitleController();
      _isDirty = false;
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  // ── Private Helpers ───────────────────────────────

  void _syncTitleController() {
    final title = _deck?.title;
    if (title == null || titleController.text == title) return;

    titleController.text = title;
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/deck_editor_page_controller.dart
// PURPOSE: Manages the working copy of a Deck and CardTemplates
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        CardTemplateType,
        CardTemplatesService,
        Deck,
        DecksDirectoryPaths,
        DecksService,
        LocalDB,
        StudyCardService;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart'
    show FormState, GlobalKey, TextEditingController;
import 'package:signals_hooks/signals_hooks.dart';

class EditDeckController {
  EditDeckController({required String deckId, String? initialTemplateId}) {
    loadDeck(deckId, initialTemplateId: initialTemplateId);
  }

  late final Deck initialDeck;
  late final Signal<Deck> deck;

  final templates = signal<List<CardTemplate>>(const []);
  late final templatesEffect = effect(() {
    deck.value = deck.value.copyWith(
      cardTemplatesCount: templates.value.length,
    );
  });

  final formKey = GlobalKey<FormState>();
  late final isDirty = computed(() => initialDeck != deck.value);
  final activeTemplateId = signal<String?>(null);
  final isLoading = signal(false);
  final error = signal<Exception?>(null);

  final TextEditingController titleController = TextEditingController();

  late final currentTemplate = computed<CardTemplate?>(() {
    final id = activeTemplateId.value;
    if (id == null) return null;

    return templates.value.where((template) => template.id == id).firstOrNull;
  });

  late final hasCurrentTemplate = computed(() => currentTemplate.value != null);
  late final selectedCardTemplateType = computed(
    () => switch (currentTemplate.value) {
      final template? => CardTemplatesService.typeFor(template),
      _ => CardTemplateType.flashcard,
    },
  );

  void loadDeck(String deckId, {String? initialTemplateId}) {
    final profileId = LocalDB.currentProfile.getOrCreate().id;
    final loadedDeck =
        LocalDB.deck.selectByPk({'id': deckId}) ??
        Deck.createDummy(id: deckId, profileId: profileId);
    final loadedTemplates = LocalDB.cardTemplate.getByDeckId(deckId);

    initialDeck = loadedDeck;
    deck = signal(loadedDeck);
    templates.value = loadedTemplates;
    titleController.text = loadedDeck.title;

    final selectedId =
        initialTemplateId != null &&
            loadedTemplates.any((template) => template.id == initialTemplateId)
        ? initialTemplateId
        : loadedTemplates.firstOrNull?.id;
    onTemplateSelected(selectedId);
  }

  String? createAttachmentPath(PlatformFile file) {
    return DecksDirectoryPaths.attachment(
      deckTitle: deck.value.title,
      fileNameWithoutExtension: file.name,
    );
  }

  bool validate() => formKey.currentState?.validate() ?? true;

  void dispose() {
    templatesEffect();
    titleController.dispose();
    deck.dispose();
    templates.dispose();
    isDirty.dispose();
    activeTemplateId.dispose();
    isLoading.dispose();
    error.dispose();
    currentTemplate.dispose();
    hasCurrentTemplate.dispose();
    selectedCardTemplateType.dispose();
  }

  void onAddTemplatePressed() => addTemplate();

  void addTemplate() {
    final template = CardTemplatesService.create(
      type: selectedCardTemplateType.value,
      deckId: deck.value.id,
      sortOrder: templates.value.length,
    );
    templates.value = [...templates.value, template];
    onTemplateSelected(template.id);
  }

  void onTemplateSelected(String? templateId) {
    if (templateId == null) return;
    activeTemplateId.value = templateId;
  }

  void onCardTemplateTypeSelected(CardTemplateType type) {
    final current = currentTemplate.value;
    if (current == null || CardTemplatesService.typeFor(current) == type) {
      return;
    }

    updateTemplate(
      CardTemplatesService.create(
        type: type,
        deckId: deck.value.id,
        id: current.id,
        sortOrder: current.sortOrder,
        createdAt: current.createdAt,
        sourceTemplateId: current.sourceTemplateId,
      ),
    );
  }

  void updateTemplate(CardTemplate updated) {
    templates.value = [
      for (final template in templates.value)
        if (template.id == updated.id) updated else template,
    ];
  }

  Future<void> save() async {
    if (!validate()) return;

    isLoading.value = true;
    error.value = null;

    try {
      final updatedDeck = deck.value.copyWith(
        cardTemplatesCount: templates.value.length,
      );

      deck.value = (await DecksService.upsert(deck: updatedDeck))!;

      await LocalDB.cardTemplate.upsertMany(templates.value);
      await StudyCardService.syncDeckStudyCards(
        deckId: updatedDeck.id,
        templates: templates.value,
      );

      deck.value = updatedDeck;
    } on Exception catch (e) {
      error.value = e;
    } finally {
      isLoading.value = false;
    }
  }
}

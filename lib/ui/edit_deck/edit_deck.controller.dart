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

/// State shared by the card list and the active card editor.
///
/// [selectedTemplateId] is the single source of truth for selection. Both
/// the sidebar and editor derive their state from it.
class EditDeckController {
  EditDeckController({required String deckId, String? initialTemplateId}) {
    _load(deckId, initialTemplateId: initialTemplateId);
  }

  late final Deck initialDeck;
  late final List<CardTemplate> initialTemplates;
  late final Signal<Deck> deck;

  final templates = signal<List<CardTemplate>>(const []);
  final selectedTemplateId = signal<String?>(null);

  late final selectedTemplate = computed<CardTemplate?>(() {
    final id = selectedTemplateId.value;
    if (id == null) return null;
    for (final template in templates.value) {
      if (template.id == id) return template;
    }
    return null;
  });

  late final selectedTemplateIndex = computed<int?>(() {
    final id = selectedTemplateId.value;
    if (id == null) return null;
    final index = templates.value.indexWhere((template) => template.id == id);
    return index == -1 ? null : index;
  });

  late final selectedTemplateKey = computed<String?>(() {
    final template = selectedTemplate.value;
    if (template == null) return null;
    return '${template.id}:${CardTemplatesService.typeFor(template).name}';
  });

  late final hasSelectedTemplate = computed(
    () => selectedTemplate.value != null,
  );

  late final selectedCardTemplateType = computed<CardTemplateType>(() {
    final template = selectedTemplate.value;
    return template == null
        ? CardTemplateType.flashcard
        : CardTemplatesService.typeFor(template);
  });

  final formKey = GlobalKey<FormState>();
  final isLoading = signal(false);
  final error = signal<Exception?>(null);
  final TextEditingController titleController = TextEditingController();

  void _load(String deckId, {String? initialTemplateId}) {
    final profileId = LocalDB.currentProfile.getOrCreate().id;
    final loadedDeck =
        LocalDB.deck.selectByPk({'id': deckId}) ??
        Deck.createDummy(id: deckId, profileId: profileId);
    final loadedTemplates = LocalDB.cardTemplate.getByDeckId(deckId);

    initialDeck = loadedDeck;
    initialTemplates = List.unmodifiable(loadedTemplates);
    deck = signal(loadedDeck);
    templates.value = [...loadedTemplates];
    selectedTemplateId.value =
        loadedTemplates.any((template) => template.id == initialTemplateId)
        ? initialTemplateId
        : loadedTemplates.firstOrNull?.id;
    titleController.text = loadedDeck.title;
  }

  String? createAttachmentPath(PlatformFile file) {
    return DecksDirectoryPaths.attachment(
      deckTitle: deck.value.title,
      fileNameWithoutExtension: file.name,
    );
  }

  bool validate() => formKey.currentState?.validate() ?? true;

  void addTemplate() {
    final template = CardTemplatesService.create(
      type: selectedCardTemplateType.value,
      deckId: deck.value.id,
      sortOrder: templates.value.length,
    );
    templates.value = [...templates.value, template];
    selectedTemplateId.value = template.id;
  }

  void selectTemplate(String id) {
    if (templates.value.any((template) => template.id == id)) {
      selectedTemplateId.value = id;
    }
  }

  CardTemplate? templateById(String id) {
    for (final template in templates.value) {
      if (template.id == id) return template;
    }
    return null;
  }

  void updateTemplate(CardTemplate updated) {
    final index = templates.value.indexWhere(
      (template) => template.id == updated.id,
    );
    if (index == -1) return;
    final next = [...templates.value];
    next[index] = updated;
    templates.value = next;
  }

  void changeSelectedTemplateType(CardTemplateType type) {
    final current = selectedTemplate.value;
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

  void dispose() {
    titleController.dispose();
    deck.dispose();
    templates.dispose();
    selectedTemplate.dispose();
    selectedTemplateIndex.dispose();
    selectedTemplateKey.dispose();
    hasSelectedTemplate.dispose();
    selectedCardTemplateType.dispose();
    selectedTemplateId.dispose();
    isLoading.dispose();
    error.dispose();
  }
}

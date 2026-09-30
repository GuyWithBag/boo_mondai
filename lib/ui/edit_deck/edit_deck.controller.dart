import 'package:boo_mondai/lib.barrel.dart'
    show
        ButtonColor,
        CardTemplate,
        CardTemplateType,
        CardTemplatesService,
        Deck,
        DecksDirectoryPaths,
        DecksService,
        ListHelper,
        LocalDB,
        ModalAction,
        SnackbarColor,
        StudyCardService,
        showModal,
        showSnackbar;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart'
    show
        FormState,
        GlobalKey,
        TextEditingController,
        BuildContext,
        Icons,
        Icon,
        MainAxisAlignment;
import 'package:go_router/go_router.dart';
import 'package:signals_hooks/signals_hooks.dart';

/// State shared by the card list and the active card editor.
///
/// [selectedTemplateId] is the single source of truth for selection. Both
/// the sidebar and editor derive their state from it.
class EditDeckController {
  EditDeckController({required String deckId, String? initialTemplateId})
    : titleController = TextEditingController() {
    _load(deckId, initialTemplateId: initialTemplateId);
    titleController.addListener(
      () => deck.value = deck.value.copyWith(title: titleController.text),
    );
  }

  late final Signal<Deck> initialDeck;
  late final ListSignal<CardTemplate> initialTemplates;
  late final Signal<Deck> deck;
  final TextEditingController titleController;

  late final deckEffect = effect(() {
    deck.value = deck.value.copyWith(
      cardTemplatesCount: templates.value.length,
    );
  });

  late final isDirty = computed(
    () =>
        initialDeck.value != deck.value ||
        !ListHelper.equal(initialTemplates.value, templates.value),
  );

  final templates = signal<List<CardTemplate>>(const []);
  final selectedTemplateId = signal<String?>(null);

  final formKey = GlobalKey<FormState>();
  final isValidated = signal(true);

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

  final isLoading = signal(false);
  final error = signal<Exception?>(null);

  void _load(String deckId, {String? initialTemplateId}) {
    final profileId = LocalDB.currentProfile.getOrCreate().id;
    final loadedDeck =
        LocalDB.deck.selectByPk({'id': deckId}) ??
        Deck.createDummy(id: deckId, profileId: profileId);
    final loadedTemplates = LocalDB.cardTemplate.getByDeckId(deckId);

    initialDeck = signal(loadedDeck);
    initialTemplates = listSignal(loadedTemplates);
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

  bool validate(BuildContext context) {
    final valid = formKey.currentState?.validate() ?? true;
    isValidated.value = valid;

    if (!valid) {
      showSnackbar(
        context,
        message: 'You have invalid fields.',
        color: SnackbarColor.error,
      );
    }

    return valid;
  }

  void addTemplate(BuildContext context) {
    final template = CardTemplatesService.create(
      type: selectedCardTemplateType.value,
      deckId: deck.value.id,
      sortOrder: templates.value.length,
    );
    templates.value = [...templates.value, template];
    selectedTemplateId.value = template.id;
    showSnackbar(context, message: 'New Card Template Created');
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

  Future<void> onPop(BuildContext context) async {
    if (isDirty.value == false) {
      context.pop();
      return;
    }

    final res = await showModal(
      context: context,
      leading: Icon(Icons.dangerous),
      title: 'You have unsaved changes.',
      subtitle: 'If you don\'t save, you will lose your changes.',
      actionsMainAxisAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        ModalAction(label: 'Go Back', value: false),
        ModalAction(label: 'Exit', value: true, color: ButtonColor.primary),
      ],
    );
    if (res != true) {
      return;
    }
    if (!context.mounted) return;
    context.pop();
  }

  Future<void> save(BuildContext context) async {
    if (!validate(context)) return;
    isLoading.value = true;
    error.value = null;
    try {
      deck.value = (await DecksService.upsert(deck: deck.value))!;
      await LocalDB.cardTemplate.upsertMany(templates.value);
      await StudyCardService.syncDeckStudyCards(
        deckId: deck.value.id,
        templates: templates.value,
      );
    } on Exception catch (e) {
      error.value = e;
    } finally {
      isLoading.value = false;
    }
    if (!context.mounted) return;
    showSnackbar(context, message: 'Deck Saved', color: SnackbarColor.success);
    initialDeck.value = deck.value;
    initialTemplates.value = templates.value;
  }

  void dispose() {
    titleController.dispose();
    deckEffect();
  }
}

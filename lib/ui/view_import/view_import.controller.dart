import 'package:boo_mondai/features/decks_import_export/decks.importer.service.dart';
import 'package:boo_mondai/features/decks_import_export/models/deck_import.mode.dart';
import 'package:boo_mondai/features/decks_import_export/models/deck_import.preview.dart';
import 'package:boo_mondai/features/decks_import_export/models/deck_import_title_conflict.dart';
import 'package:boo_mondai/features/decks_import_export/models/deck_import_unsupported_key.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        ButtonColor,
        ModalAction,
        SnackbarColor,
        TextField,
        showModal,
        showSnackbar;
import 'package:flutter/material.dart' hide TextField;
import 'package:signals/signals_flutter.dart';

class ViewImportController {
  ViewImportController({DecksImporterService? importerService})
    : importerService = importerService ?? const DecksImporterService() {
    importTextController.addListener(syncImportText);
    formDeckTitleController.addListener(syncFormDeckTitle);
    shouldShowDeckTitle = computed(
      () => importMode.value == DeckImportMode.cardTemplates,
    );
    canImportText = computed(() {
      if (importText.value.trim().isEmpty) return false;
      if (!shouldShowDeckTitle.value) return true;
      return formDeckTitle.value.trim().isNotEmpty;
    });
  }

  final DecksImporterService importerService;
  final importTextController = TextEditingController();
  final formDeckTitleController = TextEditingController();
  final importText = signal('');
  final formDeckTitle = signal('');
  final importMode = signal(DeckImportMode.decks);
  final isPickingFile = signal(false);
  final isImporting = signal(false);
  final error = signal<Exception?>(null);
  final preview = signal<DeckImportPreview?>(null);
  late final Computed<bool> shouldShowDeckTitle;
  late final Computed<bool> canImportText;

  void syncImportText() {
    importText.value = importTextController.text;
  }

  void syncFormDeckTitle() {
    formDeckTitle.value = formDeckTitleController.text;
  }

  void setImportMode(DeckImportMode value) {
    importMode.value = value;
  }

  Future<void> importFromText(BuildContext context) async {
    if (!canImportText.value) return;

    isImporting.value = true;
    error.value = null;

    try {
      final nextPreview = switch (importMode.value) {
        DeckImportMode.decks => await importerService.previewDecksFromText(
          importText.value,
        ),
        DeckImportMode.cardTemplates =>
          await importerService.previewCardTemplatesFromText(
            text: importText.value,
            deckTitle: formDeckTitle.value,
          ),
      };

      if (!context.mounted) return;
      await commitPreview(context, nextPreview);
    } on Exception catch (e) {
      error.value = e;
      if (context.mounted) {
        showSnackbar(
          context,
          message: 'Import failed: $e',
          color: SnackbarColor.error,
        );
      }
    } finally {
      isImporting.value = false;
    }
  }

  Future<void> importFromFile(BuildContext context) async {
    if (shouldShowDeckTitle.value && formDeckTitle.value.trim().isEmpty) {
      return;
    }

    isPickingFile.value = true;
    isImporting.value = true;
    error.value = null;

    try {
      final nextPreview = switch (importMode.value) {
        DeckImportMode.decks => await importerService.previewDecksFromFiles(),
        DeckImportMode.cardTemplates =>
          await importerService.previewCardTemplatesFromFiles(
            formDeckTitle.value,
          ),
      };

      if (!nextPreview.hasChanges || !context.mounted) return;
      await commitPreview(context, nextPreview);
    } on Exception catch (e) {
      error.value = e;
      if (context.mounted) {
        showSnackbar(
          context,
          message: 'Import failed: $e',
          color: SnackbarColor.error,
        );
      }
    } finally {
      isImporting.value = false;
      isPickingFile.value = false;
    }
  }

  Future<void> commitPreview(
    BuildContext context,
    DeckImportPreview nextPreview,
  ) async {
    preview.value = nextPreview;
    var resolvedPreview = nextPreview;

    if (!resolvedPreview.hasChanges) {
      showSnackbar(context, message: 'No importable data found.');
      return;
    }

    if (resolvedPreview.hasTitleConflicts) {
      final resolvedTitles = await resolveTitleConflicts(
        context,
        resolvedPreview.titleConflicts,
      );
      if (resolvedTitles == null) return;
      resolvedPreview = resolvedPreview.resolveTitleConflicts(resolvedTitles);
    }

    if (!context.mounted) return;

    if (resolvedPreview.hasUnsupportedKeys) {
      final shouldContinue = await confirmUnsupportedKeys(
        context,
        resolvedPreview.unsupportedKeys,
      );
      if (shouldContinue != true) return;
    }

    await importerService.commitPreview(resolvedPreview);

    if (!context.mounted) return;

    showSnackbar(
      context,
      message: importSuccessMessage(resolvedPreview),
      leading: const Icon(Icons.upload_file_outlined),
      color: SnackbarColor.success,
    );
    Navigator.of(context).pop(true);
  }

  Future<Map<int, String>?> resolveTitleConflicts(
    BuildContext context,
    List<DeckImportTitleConflict> conflicts,
  ) async {
    final resolvedTitles = <int, String>{};

    for (final conflict in conflicts) {
      if (!context.mounted) return null;

      final acceptSuggested = await showModal<bool>(
        context: context,
        title: 'Deck title already exists',
        subtitle:
            '"${conflict.title}" already exists. Use "${conflict.suggestedTitle}" or choose a new title.',
        showCancelButton: true,
        actions: const [
          ModalAction<bool>(value: false, label: 'Rename title'),
          ModalAction<bool>(value: true, label: 'Use suggested'),
        ],
      );

      if (acceptSuggested == null) return null;
      if (acceptSuggested) {
        resolvedTitles[conflict.deckIndex] = conflict.suggestedTitle;
        continue;
      }

      if (!context.mounted) return null;

      final renamedTitle = await promptForDeckTitle(context);
      if (renamedTitle == null || renamedTitle.trim().isEmpty) return null;
      resolvedTitles[conflict.deckIndex] = renamedTitle.trim();
    }

    return resolvedTitles;
  }

  Future<String?> promptForDeckTitle(BuildContext context) async {
    final controller = TextEditingController();
    try {
      return showModal<String?>(
        context: context,
        title: 'Rename title to...',
        child: TextField(controller: controller),
        actions: [
          const ModalAction<String?>(value: null, label: 'Cancel'),
          ModalAction<String?>(
            value: null,
            valueBuilder: () => controller.text,
            label: 'Confirm',
          ),
        ],
      );
    } finally {
      controller.dispose();
    }
  }

  Future<bool?> confirmUnsupportedKeys(
    BuildContext context,
    List<DeckImportUnsupportedKey> keys,
  ) {
    return showModal<bool>(
      context: context,
      title: 'Some fields will be ignored',
      subtitle:
          'Generated ids, dates, joined data, and unsupported fields do not import.',
      showCancelButton: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 220),
        child: SingleChildScrollView(
          child: SelectableText(unsupportedKeysText(keys)),
        ),
      ),
      actions: const [
        ModalAction<bool>(value: false, label: 'Cancel'),
        ModalAction<bool>(
          value: true,
          label: 'Continue',
          color: ButtonColor.primary,
        ),
      ],
    );
  }

  String unsupportedKeysText(List<DeckImportUnsupportedKey> keys) {
    return [
      for (final key in keys.take(80))
        '${key.path} (${unsupportedKeyReasonLabel(key.reason)})',
      if (keys.length > 80) '...and ${keys.length - 80} more.',
    ].join('\n');
  }

  String unsupportedKeyReasonLabel(DeckImportUnsupportedKeyReason reason) {
    return switch (reason) {
      DeckImportUnsupportedKeyReason.generated => 'generated',
      DeckImportUnsupportedKeyReason.joined => 'joined',
      DeckImportUnsupportedKeyReason.unsupported => 'unsupported',
    };
  }

  String importSuccessMessage(DeckImportPreview preview) {
    final deckCount = preview.result.decks.length;
    final templateCount = preview.result.cardTemplates.length;

    return 'Imported $deckCount ${deckCount == 1 ? 'deck' : 'decks'} and '
        '$templateCount ${templateCount == 1 ? 'template' : 'templates'}.';
  }

  void dispose() {
    importTextController.removeListener(syncImportText);
    formDeckTitleController.removeListener(syncFormDeckTitle);
    importTextController.dispose();
    formDeckTitleController.dispose();
    canImportText.dispose();
    shouldShowDeckTitle.dispose();
    preview.dispose();
    error.dispose();
    isImporting.dispose();
    isPickingFile.dispose();
    importMode.dispose();
    formDeckTitle.dispose();
    importText.dispose();
  }
}

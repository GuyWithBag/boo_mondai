import 'dart:convert';
import 'dart:io';

import 'package:boo_mondai/lib.barrel.dart'
    show
        CardImportDecision,
        CardTemplate,
        CardSimilarityConfig,
        Controller,
        Deck,
        DeckImportMode,
        ChangePlan,
        ImportCardsPayload,
        ImportFailure,
        ImportOptions,
        ImportResult,
        ChangedEntity,
        ImportExportService;
import 'package:file_picker/file_picker.dart';

enum ImportFileStatus {
  canceled,
  imported,
  unreadableFile,
  unsupportedFormat,
  failed,
}

class ImportFileResult<T> {
  const ImportFileResult({
    required this.status,
    this.items = const [],
    this.error,
  });

  final ImportFileStatus status;
  final List<T> items;
  final Exception? error;

  bool get didImport => status == ImportFileStatus.imported;
  int get importedCount => items.length;
}

/// UI-facing state holder for import/export workflows.
class ImportExportController extends Controller {
  ChangePlan<ImportCardsPayload, CardTemplate>? currentPlan;
  List<ChangedEntity<Object?>> latestChanges = const [];
  List<String> latestFailures = const [];

  /// Exports one deck and stores change logs.
  Future<Map<String, dynamic>?> exportDeck(String deckId) async {
    setLoading(true);
    try {
      final result = await ImportExportService.exportDeck(deckId);
      latestChanges = result.changes;
      latestFailures = const [];
      return result.value;
    } on Exception catch (e) {
      setError(e);
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Exports multiple decks with partial-failure reporting.
  Future<List<Map<String, dynamic>>> exportDecks(List<String> deckIds) async {
    setLoading(true);
    try {
      final result = await ImportExportService.exportDecks(deckIds);
      latestChanges = result.changes;
      latestFailures = result.failures;
      return result.values;
    } on Exception catch (e) {
      setError(e);
      return const [];
    } finally {
      setLoading(false);
    }
  }

  Future<File?> exportDeckBundle(String deckId) async {
    setLoading(true);
    try {
      latestFailures = const [];
      return ImportExportService.exportDeckBundle(deckId);
    } on Exception catch (e) {
      setError(e);
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Imports one deck from decoded payload.
  Future<Deck?> importDeck({
    required Map<String, dynamic> payload,
    DeckImportMode mode = DeckImportMode.createNew,
    String? targetDeckId,
  }) async {
    setLoading(true);
    try {
      final result = await ImportExportService.importDeck(
        payload: payload,
        mode: mode,
        targetDeckId: targetDeckId,
      );
      latestChanges = result.changes;
      latestFailures = const [];
      return result.value;
    } on Exception catch (e) {
      setError(e);
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Imports one deck from raw JSON.
  Future<Deck?> importDeckJson({
    required String rawJson,
    DeckImportMode mode = DeckImportMode.createNew,
    String? targetDeckId,
  }) async {
    return importDeck(
      payload: jsonDecode(rawJson) as Map<String, dynamic>,
      mode: mode,
      targetDeckId: targetDeckId,
    );
  }

  /// Imports multiple deck payloads with partial success.
  Future<List<Deck?>> importDecks({
    required List<Map<String, dynamic>> payloads,
    DeckImportMode mode = DeckImportMode.createNew,
    Map<int, String> updateTargetsByIndex = const {},
  }) async {
    setLoading(true);
    try {
      final result = await ImportExportService.importDecks(
        payloads: payloads,
        mode: mode,
        updateTargetsByIndex: updateTargetsByIndex,
      );
      latestChanges = result.changes;
      latestFailures = result.failures;
      return result.values;
    } on Exception catch (e) {
      setError(e);
      return const [];
    } finally {
      setLoading(false);
    }
  }

  /// Imports multiple decks from raw JSON.
  Future<List<Deck?>> importDecksJson({
    required String rawJson,
    DeckImportMode mode = DeckImportMode.createNew,
    Map<int, String> updateTargetsByIndex = const {},
  }) async {
    setLoading(true);
    try {
      final result = await ImportExportService.importDecksJson(
        rawJson: rawJson,
        mode: mode,
        updateTargetsByIndex: updateTargetsByIndex,
      );
      latestChanges = result.changes;
      latestFailures = result.failures;
      return result.values;
    } on Exception catch (e) {
      setError(e);
      return const [];
    } finally {
      setLoading(false);
    }
  }

  Future<ImportFileResult<Deck>> importDecksFromFile() async {
    final result = await FilePicker.pickFiles(
      dialogTitle: 'Import decks',
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) {
      return const ImportFileResult(status: ImportFileStatus.canceled);
    }

    final bytes = result.files.single.bytes;
    if (bytes == null) {
      return const ImportFileResult(status: ImportFileStatus.unreadableFile);
    }

    try {
      final rawJson = utf8.decode(bytes);
      final decoded = jsonDecode(rawJson);
      final imported = await _importDecodedDecksJson(
        rawJson: rawJson,
        decoded: decoded,
      );

      final currentError = error;
      if (currentError != null) {
        return ImportFileResult(
          status: ImportFileStatus.failed,
          error: currentError,
        );
      }

      return ImportFileResult(
        status: ImportFileStatus.imported,
        items: imported,
      );
    } on FormatException catch (e) {
      return ImportFileResult(
        status: ImportFileStatus.unsupportedFormat,
        error: e,
      );
    } on Exception catch (e) {
      return ImportFileResult(status: ImportFileStatus.failed, error: e);
    }
  }

  Future<ImportResult?> importDeckBundleFromFile({
    ImportOptions options = const ImportOptions(),
  }) async {
    final result = await FilePicker.pickFiles(
      dialogTitle: 'Import deck bundle',
      type: FileType.custom,
      allowedExtensions: const ['zip', 'boomondai.zip'],
      withData: false,
    );
    if (result == null || result.files.isEmpty) {
      return null;
    }

    final path = result.files.single.path;
    if (path == null) {
      return const ImportFailure('Unable to read selected file.');
    }

    setLoading(true);
    try {
      return ImportExportService.importDeckBundle(File(path), options);
    } on Exception catch (e) {
      setError(e);
      return ImportFailure(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<List<Deck>> _importDecodedDecksJson({
    required String rawJson,
    required Object? decoded,
  }) async {
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('decks')) {
        final imported = await importDecksJson(rawJson: rawJson);
        return imported.whereType<Deck>().toList(growable: false);
      }

      if (decoded.containsKey('deck')) {
        final imported = await importDeckJson(rawJson: rawJson);
        return imported == null ? const [] : [imported];
      }
    } else if (decoded is List) {
      final imported = await importDecksJson(rawJson: rawJson);
      return imported.whereType<Deck>().toList(growable: false);
    }

    throw const FormatException('Unsupported import format.');
  }

  /// Exports cards from one deck.
  Future<Map<String, dynamic>?> exportCards({
    required String deckId,
    List<String>? templateIds,
  }) async {
    setLoading(true);
    try {
      final result = await ImportExportService.exportCards(
        deckId: deckId,
        templateIds: templateIds,
      );
      latestChanges = result.changes;
      latestFailures = const [];
      return result.value;
    } on Exception catch (e) {
      setError(e);
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Builds a similarity plan for importing cards into one deck.
  Future<ChangePlan<ImportCardsPayload, CardTemplate>?> previewCardImport({
    required String deckId,
    required List<Map<String, dynamic>> incomingTemplateMaps,
    CardSimilarityConfig similarity = const CardSimilarityConfig(),
  }) async {
    setLoading(true);
    try {
      final plan = await ImportExportService.previewCardImport(
        deckId: deckId,
        incomingTemplateMaps: incomingTemplateMaps,
        similarity: similarity,
      );
      currentPlan = plan;
      latestChanges = plan.changes;
      latestFailures = const [];
      return plan;
    } on Exception catch (e) {
      setError(e);
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Builds a similarity plan from raw JSON.
  Future<ChangePlan<ImportCardsPayload, CardTemplate>?> previewCardImportJson({
    required String deckId,
    required String rawJson,
    CardSimilarityConfig similarity = const CardSimilarityConfig(),
  }) async {
    setLoading(true);
    try {
      final plan = await ImportExportService.previewCardImportJson(
        deckId: deckId,
        rawJson: rawJson,
        similarity: similarity,
      );
      currentPlan = plan;
      latestChanges = plan.changes;
      latestFailures = const [];
      return plan;
    } on Exception catch (e) {
      setError(e);
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Applies user card-import choices for the latest preview plan.
  Future<void> applyCardImportDecisions(
    List<CardImportDecision> decisions,
  ) async {
    final plan = currentPlan;
    if (plan == null) {
      setError(Exception('No active import plan. Run preview first.'));
      return;
    }

    setLoading(true);
    try {
      final result = await ImportExportService.applyCardImportPlan(
        plan: plan,
        decisions: decisions,
      );
      latestChanges = result.changes;
      latestFailures = const [];
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }
}

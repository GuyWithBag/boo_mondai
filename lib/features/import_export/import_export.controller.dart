import 'dart:convert';

import 'package:boo_mondai/lib.barrel.dart'
    show
        CardImportDecision,
        CardSimilarityConfig,
        Controller,
        Deck,
        DeckImportMode,
        ChangePlan,
        ImportCardsPayload,
        ChangeLog,
        ImportExportService;

/// UI-facing state holder for import/export workflows.
class ImportExportController extends Controller {
  ChangePlan<ImportCardsPayload>? currentPlan;
  List<ChangeLog> latestChanges = const [];
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
  Future<ChangePlan<ImportCardsPayload>?> previewCardImport({
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
  Future<ChangePlan<ImportCardsPayload>?> previewCardImportJson({
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

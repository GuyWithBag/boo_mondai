/// Describes the kind of mutation produced by an import/export operation.
enum ImportExportChangeType { created, updated, skipped }

/// Controls how a deck payload should be imported.
enum DeckImportMode { createNew, updateExisting, skip }

/// Controls what to do with one incoming card during import.
enum CardImportAction { updateExisting, importAsNew, skip }

/// A user-facing record of one import/export decision.
class ImportExportChangeLog {
  /// Creates a change log entry for an imported or exported deck/card.
  const ImportExportChangeLog({
    required this.type,
    required this.entityType,
    required this.entityId,
    required this.message,
  });

  /// Whether the operation created, updated, or skipped the entity.
  final ImportExportChangeType type;

  /// Logical entity name such as `deck` or `card_template`.
  final String entityType;

  /// Local entity id affected by the operation.
  final String entityId;

  /// Short explanation suitable for showing in an import summary.
  final String message;
}

/// A possible update target for an imported card.
class ImportCardMatchCandidate {
  /// Creates a similarity match between an incoming card and an existing card.
  const ImportCardMatchCandidate({
    required this.incomingTemplateId,
    required this.existingTemplateId,
    required this.score,
    required this.existingPreview,
    required this.incomingPreview,
  });

  /// Template id from the import payload.
  final String incomingTemplateId;

  /// Existing local template id that may be updated.
  final String existingTemplateId;

  /// Similarity score from 0 to 100.
  final int score;

  /// Human-readable summary of the existing local card.
  final String existingPreview;

  /// Human-readable summary of the incoming card.
  final String incomingPreview;
}

/// Preview result for importing cards into one deck.
class ImportCardsPlan {
  /// Creates a card import plan with detected update candidates.
  const ImportCardsPlan({
    required this.deckId,
    required this.incomingTemplates,
    required this.candidates,
  });

  /// Deck that will receive imported cards.
  final String deckId;

  /// Incoming card template maps, usually from an export payload.
  final List<Map<String, dynamic>> incomingTemplates;

  /// Similar cards that the user can choose to update instead of duplicating.
  final List<ImportCardMatchCandidate> candidates;
}

/// User decision for one incoming card template.
class CardImportDecision {
  /// Creates an import decision for one incoming template.
  const CardImportDecision({
    required this.incomingTemplateId,
    required this.action,
    this.targetTemplateId,
  });

  /// Incoming template id from the import payload.
  final String incomingTemplateId;

  /// Selected action for this incoming template.
  final CardImportAction action;

  /// Existing local template id to update when [action] is updateExisting.
  final String? targetTemplateId;
}

/// Tunable knobs used by card similarity detection.
class CardSimilarityConfig {
  /// Creates similarity settings for import preview.
  const CardSimilarityConfig({
    this.threshold = 85,
    this.matchBySourceTemplateId = true,
    this.matchAcrossCardTypes = true,
  });

  /// Minimum 0..100 score needed before a pair is surfaced as a candidate.
  final int threshold;

  /// Whether identical `sourceTemplateId` should short-circuit as a match.
  final bool matchBySourceTemplateId;

  /// Whether similarity comparisons can cross card types.
  final bool matchAcrossCardTypes;
}

/// Result returned after an import/export operation mutates local data.
class ImportExportResult<T> {
  /// Creates a result with the operation value and change log entries.
  const ImportExportResult({required this.value, required this.changeLogs});

  /// Operation-specific return value.
  final T value;

  /// Ordered log entries describing created, updated, and skipped entities.
  final List<ImportExportChangeLog> changeLogs;
}

/// Result of batch import/export where some entries may fail.
class ImportExportBatchResult<T> {
  /// Creates a batch result with successes, failures, and change logs.
  const ImportExportBatchResult({
    required this.values,
    required this.failures,
    required this.changeLogs,
  });

  /// Successfully processed results.
  final List<T> values;

  /// Human-readable failures tied to a source index or identifier.
  final List<String> failures;

  /// Combined change logs across all processed entries.
  final List<ImportExportChangeLog> changeLogs;
}

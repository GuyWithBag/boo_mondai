/// Controls how a deck payload should be imported.
enum DeckImportMode { createNew, updateExisting, skip }

/// Controls what to do with one incoming card during import.
enum CardImportAction { updateExisting, importAsNew, skip }

/// A possible update target for an imported card.
class ImportCardMatchCandidate {
  const ImportCardMatchCandidate({
    required this.incomingTemplateId,
    required this.existingTemplateId,
    required this.score,
    required this.existingPreview,
    required this.incomingPreview,
  });

  final String incomingTemplateId;
  final String existingTemplateId;
  final int score;
  final String existingPreview;
  final String incomingPreview;
}

/// Payload for previewing or applying imported cards into one deck.
class ImportCardsPayload {
  const ImportCardsPayload({
    required this.deckId,
    required this.incomingTemplates,
    required this.candidates,
  });

  final String deckId;
  final List<Map<String, dynamic>> incomingTemplates;
  final List<ImportCardMatchCandidate> candidates;
}

/// User decision for one incoming card template.
class CardImportDecision {
  const CardImportDecision({
    required this.incomingTemplateId,
    required this.action,
    this.targetTemplateId,
  });

  final String incomingTemplateId;
  final CardImportAction action;
  final String? targetTemplateId;
}

/// Tunable knobs used by card similarity detection.
class CardSimilarityConfig {
  const CardSimilarityConfig({
    this.threshold = 85,
    this.matchBySourceTemplateId = true,
    this.matchAcrossCardTypes = true,
  });

  final int threshold;
  final bool matchBySourceTemplateId;
  final bool matchAcrossCardTypes;
}

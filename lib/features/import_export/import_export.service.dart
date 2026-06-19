import 'dart:convert';

import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        CardTemplateMapper,
        Deck,
        DeckMapper,
        DeckImportMode,
        FillInTheBlanksTemplate,
        FillInTheBlankSegment,
        FlashcardTemplate,
        IdentificationTemplate,
        ImportCardMatchCandidate,
        ChangePreview,
        ImportCardsPayload,
        ImportExportBackup,
        ChangeBatchResult,
        ChangeRecord,
        ChangeComparer,
        ChangeSource,
        ChangeType,
        ChangeResult,
        LocalDB,
        MatchMadnessPair,
        MatchMadnessTemplate,
        MultipleChoiceOption,
        MultipleChoiceTemplate,
        CardImportAction,
        CardImportDecision,
        CardSimilarityConfig,
        StudyCardService,
        WordScrambleTemplate,
        uuid;

/// Static import/export operations for decks and card templates.
class ImportExportService {
  const ImportExportService._();

  /// Exports one deck with templates, tags, and media URL references.
  static Future<ChangeResult<Map<String, dynamic>>> exportDeck(
    String deckId,
  ) async {
    final deck = LocalDB.deck.selectByPk({'id': deckId});
    if (deck == null) {
      throw Exception('Deck not found: $deckId');
    }
    final templates = LocalDB.cardTemplate.getByDeckId(deckId);
    final payload = _buildDeckPayload(deck: deck, templates: templates);
    final logs = [
      ChangeRecord(
        type: ChangeType.added,
        source: ChangeSource.importExport,
        entityType: 'deck',
        entityId: deck.id,
        title: 'Exported ${deck.title}',
        subtitle: '${templates.length} cards',
        after: deck,
      ),
    ];
    await _storeBackup(
      operation: 'export_deck',
      entityType: 'deck',
      entityId: deck.id,
      title: 'Export deck ${deck.title}',
      payload: payload,
      logs: logs,
    );
    return ChangeResult(value: payload, changes: logs);
  }

  /// Exports multiple decks and returns per-deck partial failures.
  static Future<ChangeBatchResult<Map<String, dynamic>>> exportDecks(
    List<String> deckIds,
  ) async {
    final values = <Map<String, dynamic>>[];
    final failures = <String>[];
    final logs = <ChangeRecord>[];

    for (final deckId in deckIds) {
      try {
        final result = await exportDeck(deckId);
        values.add(result.value);
        logs.addAll(result.changes);
      } on Exception catch (e) {
        failures.add('Deck $deckId: $e');
      }
    }

    return ChangeBatchResult(values: values, failures: failures, changes: logs);
  }

  /// Exports cards from one deck, optionally scoped to [templateIds].
  static Future<ChangeResult<Map<String, dynamic>>> exportCards({
    required String deckId,
    List<String>? templateIds,
  }) async {
    final deck = LocalDB.deck.selectByPk({'id': deckId});
    if (deck == null) {
      throw Exception('Deck not found: $deckId');
    }

    final deckTemplates = LocalDB.cardTemplate.getByDeckId(deckId);
    final selected = templateIds == null
        ? deckTemplates
        : deckTemplates
              .where((template) => templateIds.contains(template.id))
              .toList(growable: false);

    final payload = <String, dynamic>{
      'format': 'boo_mondai_cards_v1',
      'deck': {'id': deck.id, 'title': deck.title},
      'exported_at': DateTime.now().toIso8601String(),
      'card_templates': [for (final template in selected) template.toMap()],
    };

    final logs = [
      ChangeRecord(
        type: ChangeType.added,
        source: ChangeSource.importExport,
        entityType: 'card_templates',
        entityId: deckId,
        title: 'Exported cards from ${deck.title}',
        subtitle: '${selected.length} cards',
      ),
    ];

    await _storeBackup(
      operation: 'export_cards',
      entityType: 'card_templates',
      entityId: deckId,
      title: 'Export cards from ${deck.title}',
      payload: payload,
      logs: logs,
    );

    return ChangeResult(value: payload, changes: logs);
  }

  /// Imports one deck payload using [mode] and optional [targetDeckId].
  static Future<ChangeResult<Deck?>> importDeck({
    required Map<String, dynamic> payload,
    DeckImportMode mode = DeckImportMode.createNew,
    String? targetDeckId,
  }) async {
    final deckMap = Map<String, dynamic>.from(
      payload['deck'] as Map<String, dynamic>,
    );
    final incomingDeck = DeckMapper.fromMap(deckMap);
    final incomingTemplateMaps = _extractTemplateMaps(payload);
    final incomingTemplates = _decodeTemplates(incomingTemplateMaps);
    final logs = <ChangeRecord>[];

    if (mode == DeckImportMode.skip) {
      logs.add(
        ChangeRecord(
          type: ChangeType.skipped,
          source: ChangeSource.importExport,
          entityType: 'deck',
          entityId: incomingDeck.id,
          title: 'Skipped ${incomingDeck.title}',
          after: incomingDeck,
        ),
      );
      return ChangeResult(value: null, changes: logs);
    }

    if (mode == DeckImportMode.updateExisting) {
      if (targetDeckId == null) {
        throw Exception('targetDeckId is required for updateExisting mode.');
      }
      final target = LocalDB.deck.selectByPk({'id': targetDeckId});
      if (target == null) {
        throw Exception('Target deck not found: $targetDeckId');
      }

      final now = DateTime.now();
      final updatedDeck = target.copyWith(
        title: incomingDeck.title,
        shortDescription: incomingDeck.shortDescription,
        longDescription: incomingDeck.longDescription,
        coverImageUrl: incomingDeck.coverImageUrl,
        tags: incomingDeck.tags,
        updatedAt: now,
        buildNumber: target.buildNumber + 1,
      );
      await LocalDB.deck.upsert(updatedDeck);

      final copiedTemplates = _copyTemplatesForDeck(
        templates: incomingTemplates,
        deckId: target.id,
      );
      await LocalDB.cardTemplate.upsertMany(copiedTemplates);
      await StudyCardService.syncDeckStudyCards(
        deckId: target.id,
        templates: LocalDB.cardTemplate.getByDeckId(target.id),
      );

      logs.add(
        ChangeRecord(
          type: ChangeType.modified,
          source: ChangeSource.importExport,
          entityType: 'deck',
          entityId: target.id,
          title: 'Updated ${target.title}',
          subtitle: '${copiedTemplates.length} imported cards',
          before: target,
          after: updatedDeck,
          fields: ChangeComparer.decks(target, updatedDeck),
        ),
      );

      await _storeBackup(
        operation: 'import_deck',
        entityType: 'deck',
        entityId: target.id,
        title: 'Import deck update ${updatedDeck.title}',
        payload: payload,
        logs: logs,
      );

      return ChangeResult(value: updatedDeck, changes: logs);
    }

    final profile = LocalDB.profile.getOrCreate();
    final now = DateTime.now();
    final createdDeck = incomingDeck.copyWith(
      id: uuid.v7(),
      userId: profile.id,
      createdAt: now,
      updatedAt: now,
      isPublished: false,
      isEditable: true,
      visibilityState: incomingDeck.visibilityState,
      userProfile: null,
      listing: null,
      sourceDeckId: incomingDeck.sourceDeckId ?? incomingDeck.id,
    );
    final copiedTemplates = _copyTemplatesForDeck(
      templates: incomingTemplates,
      deckId: createdDeck.id,
    );
    await LocalDB.deck.upsert(createdDeck);
    await LocalDB.cardTemplate.upsertMany(copiedTemplates);
    await StudyCardService.syncDeckStudyCards(
      deckId: createdDeck.id,
      templates: copiedTemplates,
    );

    logs.add(
      ChangeRecord(
        type: ChangeType.added,
        source: ChangeSource.importExport,
        entityType: 'deck',
        entityId: createdDeck.id,
        title: createdDeck.title,
        subtitle: '${copiedTemplates.length} imported cards',
        after: createdDeck,
      ),
    );

    await _storeBackup(
      operation: 'import_deck',
      entityType: 'deck',
      entityId: createdDeck.id,
      title: 'Import new deck ${createdDeck.title}',
      payload: payload,
      logs: logs,
    );

    return ChangeResult(value: createdDeck, changes: logs);
  }

  /// Imports one deck from raw JSON.
  static Future<ChangeResult<Deck?>> importDeckJson({
    required String rawJson,
    DeckImportMode mode = DeckImportMode.createNew,
    String? targetDeckId,
  }) async {
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Expected deck JSON object.');
    }
    return importDeck(payload: decoded, mode: mode, targetDeckId: targetDeckId);
  }

  /// Imports multiple deck payloads with partial success.
  static Future<ChangeBatchResult<Deck?>> importDecks({
    required List<Map<String, dynamic>> payloads,
    DeckImportMode mode = DeckImportMode.createNew,
    Map<int, String> updateTargetsByIndex = const {},
  }) async {
    final values = <Deck?>[];
    final failures = <String>[];
    final logs = <ChangeRecord>[];

    for (var i = 0; i < payloads.length; i++) {
      try {
        final result = await importDeck(
          payload: payloads[i],
          mode: mode,
          targetDeckId: updateTargetsByIndex[i],
        );
        values.add(result.value);
        logs.addAll(result.changes);
      } on Exception catch (e) {
        failures.add('Index $i: $e');
      }
    }

    return ChangeBatchResult(values: values, failures: failures, changes: logs);
  }

  /// Imports multiple decks from raw JSON. Accepts either `{decks:[...]}` or `[...]`.
  static Future<ChangeBatchResult<Deck?>> importDecksJson({
    required String rawJson,
    DeckImportMode mode = DeckImportMode.createNew,
    Map<int, String> updateTargetsByIndex = const {},
  }) async {
    final decoded = jsonDecode(rawJson);
    final payloads = switch (decoded) {
      List _ =>
        decoded
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(growable: false),
      Map _ =>
        ((decoded as Map<String, dynamic>)['decks'] as List<dynamic>)
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(growable: false),
      _ => throw Exception('Expected JSON array or object containing "decks".'),
    };

    return importDecks(
      payloads: payloads,
      mode: mode,
      updateTargetsByIndex: updateTargetsByIndex,
    );
  }

  /// Previews card import and detects likely update candidates.
  static Future<ChangePreview<ImportCardsPayload>> previewCardImport({
    required String deckId,
    required List<Map<String, dynamic>> incomingTemplateMaps,
    CardSimilarityConfig similarity = const CardSimilarityConfig(),
  }) async {
    final incoming = _decodeTemplates(incomingTemplateMaps);
    final existing = LocalDB.cardTemplate.getByDeckId(deckId);
    final candidates = <ImportCardMatchCandidate>[];
    final changes = <ChangeRecord>[];

    for (final template in incoming) {
      final incomingPreview = _templatePreview(template);
      final incomingText = incomingPreview.toLowerCase();

      ImportCardMatchCandidate? best;
      for (final local in existing) {
        if (!similarity.matchAcrossCardTypes &&
            local.runtimeType != template.runtimeType) {
          continue;
        }

        final score = _similarityScore(
          incoming: template,
          existing: local,
          incomingText: incomingText,
          existingText: _templatePreview(local).toLowerCase(),
          similarity: similarity,
        );
        if (score < similarity.threshold) continue;

        final candidate = ImportCardMatchCandidate(
          incomingTemplateId: template.id,
          existingTemplateId: local.id,
          score: score,
          existingPreview: _templatePreview(local),
          incomingPreview: incomingPreview,
        );
        if (best == null || candidate.score > best.score) {
          best = candidate;
        }
      }
      if (best != null) {
        candidates.add(best);
        final existingTemplateId = best.existingTemplateId;
        final local = existing.firstWhere(
          (template) => template.id == existingTemplateId,
        );
        changes.add(
          ChangeRecord(
            type: ChangeType.modified,
            source: ChangeSource.importExport,
            entityType: 'card_template',
            entityId: local.id,
            title: ChangeComparer.templateTitle(local),
            subtitle: 'Likely imported card update',
            before: local,
            after: template,
            fields: ChangeComparer.templates(local, template),
          ),
        );
      } else {
        changes.add(
          ChangeRecord(
            type: ChangeType.added,
            source: ChangeSource.importExport,
            entityType: 'card_template',
            entityId: template.id,
            title: ChangeComparer.templateTitle(template),
            subtitle: 'Imported card will be added',
            after: template,
          ),
        );
      }
    }

    return ChangePreview<ImportCardsPayload>(
      payload: ImportCardsPayload(
        deckId: deckId,
        incomingTemplates: incomingTemplateMaps,
        candidates: candidates,
      ),
      changes: changes,
    );
  }

  /// JSON helper for [previewCardImport].
  static Future<ChangePreview<ImportCardsPayload>> previewCardImportJson({
    required String deckId,
    required String rawJson,
    CardSimilarityConfig similarity = const CardSimilarityConfig(),
  }) async {
    final decoded = jsonDecode(rawJson);
    final incomingMaps = switch (decoded) {
      List _ =>
        decoded
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(growable: false),
      Map _ =>
        ((decoded as Map<String, dynamic>)['card_templates'] as List)
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(growable: false),
      _ => throw Exception(
        'Expected JSON array or object containing "card_templates".',
      ),
    };
    return previewCardImport(
      deckId: deckId,
      incomingTemplateMaps: incomingMaps,
      similarity: similarity,
    );
  }

  /// Applies card import decisions and returns detailed change logs.
  static Future<ChangeResult<List<CardTemplate>>> applyCardImportPlan({
    required ChangePreview<ImportCardsPayload> plan,
    required List<CardImportDecision> decisions,
  }) async {
    final logs = <ChangeRecord>[];
    final payload = plan.payload;
    final incoming = _decodeTemplates(payload.incomingTemplates);
    final decisionByIncomingId = {
      for (final decision in decisions) decision.incomingTemplateId: decision,
    };
    final written = <CardTemplate>[];

    for (final template in incoming) {
      final decision = decisionByIncomingId[template.id];
      if (decision?.action == CardImportAction.skip) {
        logs.add(
          ChangeRecord(
            type: ChangeType.skipped,
            source: ChangeSource.importExport,
            entityType: 'card_template',
            entityId: template.id,
            title: ChangeComparer.templateTitle(template),
            subtitle: 'Skipped imported card',
            after: template,
          ),
        );
        continue;
      }

      if (decision?.action == CardImportAction.updateExisting &&
          decision?.targetTemplateId != null) {
        final existing = LocalDB.cardTemplate.selectByPk({
          'id': decision!.targetTemplateId!,
        });
        if (existing == null) {
          logs.add(
            ChangeRecord(
              type: ChangeType.skipped,
              source: ChangeSource.importExport,
              entityType: 'card_template',
              entityId: decision.targetTemplateId!,
              title: 'Skipped card update',
              subtitle: 'Target template was not found locally.',
            ),
          );
          continue;
        }

        final updated = _copyTemplateWithIdentity(
          source: template,
          targetId: existing.id,
          deckId: payload.deckId,
          createdAt: existing.createdAt,
        );
        await LocalDB.cardTemplate.upsert(updated);
        written.add(updated);
        logs.add(
          ChangeRecord(
            type: ChangeType.modified,
            source: ChangeSource.importExport,
            entityType: 'card_template',
            entityId: existing.id,
            title: ChangeComparer.templateTitle(updated),
            subtitle: 'Updated imported card',
            before: existing,
            after: updated,
            fields: ChangeComparer.templates(existing, updated),
          ),
        );
        continue;
      }

      final created = _copyTemplateWithIdentity(
        source: template,
        targetId: uuid.v7(),
        deckId: payload.deckId,
        createdAt: DateTime.now(),
      );
      await LocalDB.cardTemplate.upsert(created);
      written.add(created);
      logs.add(
        ChangeRecord(
          type: ChangeType.added,
          source: ChangeSource.importExport,
          entityType: 'card_template',
          entityId: created.id,
          title: ChangeComparer.templateTitle(created),
          subtitle: 'Imported new card',
          after: created,
        ),
      );
    }

    final allTemplates = LocalDB.cardTemplate.getByDeckId(payload.deckId);
    await StudyCardService.syncDeckStudyCards(
      deckId: payload.deckId,
      templates: allTemplates,
    );

    await _storeBackup(
      operation: 'import_cards',
      entityType: 'card_templates',
      entityId: payload.deckId,
      title: 'Import cards into ${payload.deckId}',
      payload: {
        'deck_id': payload.deckId,
        'incoming_count': payload.incomingTemplates.length,
        'decision_count': decisions.length,
      },
      logs: logs,
    );

    return ChangeResult(value: written, changes: logs);
  }

  static Map<String, dynamic> _buildDeckPayload({
    required Deck deck,
    required List<CardTemplate> templates,
  }) {
    return {
      'format': 'boo_mondai_deck_v1',
      'exported_at': DateTime.now().toIso8601String(),
      'deck': deck.toMap(),
      'card_templates': [for (final template in templates) template.toMap()],
    };
  }

  static List<Map<String, dynamic>> _extractTemplateMaps(
    Map<String, dynamic> payload,
  ) {
    final raw = payload['card_templates'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }

  static List<CardTemplate> _decodeTemplates(List<Map<String, dynamic>> maps) {
    return maps.map(CardTemplateMapper.fromMap).toList(growable: false);
  }

  static List<CardTemplate> _copyTemplatesForDeck({
    required List<CardTemplate> templates,
    required String deckId,
  }) {
    final idMap = {for (final template in templates) template.id: uuid.v7()};
    final now = DateTime.now();
    return [
      for (final template in templates)
        _copyTemplate(
          source: template,
          targetDeckId: deckId,
          targetId: idMap[template.id]!,
          idMap: idMap,
          createdAt: now,
        ),
    ];
  }

  static CardTemplate _copyTemplateWithIdentity({
    required CardTemplate source,
    required String targetId,
    required String deckId,
    required DateTime createdAt,
  }) {
    final idMap = {source.id: targetId};
    return _copyTemplate(
      source: source,
      targetDeckId: deckId,
      targetId: targetId,
      idMap: idMap,
      createdAt: createdAt,
    );
  }

  static CardTemplate _copyTemplate({
    required CardTemplate source,
    required String targetDeckId,
    required String targetId,
    required Map<String, String> idMap,
    required DateTime createdAt,
  }) {
    final now = DateTime.now();
    return switch (source) {
      FlashcardTemplate t => FlashcardTemplate(
        id: targetId,
        deckId: targetDeckId,
        sortOrder: t.sortOrder,
        createdAt: createdAt,
        updatedAt: now,
        sourceTemplateId: t.sourceTemplateId ?? t.id,
        tags: t.tags,
        frontText: t.frontText,
        backText: t.backText,
        frontImageUrl: t.frontImageUrl,
        backImageUrl: t.backImageUrl,
        frontAudioUrl: t.frontAudioUrl,
        backAudioUrl: t.backAudioUrl,
        cardType: t.cardType,
      ),
      IdentificationTemplate t => IdentificationTemplate(
        id: targetId,
        deckId: targetDeckId,
        sortOrder: t.sortOrder,
        createdAt: createdAt,
        updatedAt: now,
        sourceTemplateId: t.sourceTemplateId ?? t.id,
        tags: t.tags,
        promptText: t.promptText,
        acceptedAnswers: t.acceptedAnswers,
        imageUrl: t.imageUrl,
        audioUrl: t.audioUrl,
      ),
      MultipleChoiceTemplate t => MultipleChoiceTemplate(
        id: targetId,
        deckId: targetDeckId,
        sortOrder: t.sortOrder,
        createdAt: createdAt,
        updatedAt: now,
        sourceTemplateId: t.sourceTemplateId ?? t.id,
        tags: t.tags,
        questionPrompt: t.questionPrompt,
        options: [
          for (final option in t.options)
            MultipleChoiceOption(
              id: uuid.v7(),
              templateId: targetId,
              optionText: option.optionText,
              isCorrect: option.isCorrect,
              displayOrder: option.displayOrder,
            ),
        ],
        imageUrl: t.imageUrl,
        audioUrl: t.audioUrl,
      ),
      FillInTheBlanksTemplate t => FillInTheBlanksTemplate(
        id: targetId,
        deckId: targetDeckId,
        sortOrder: t.sortOrder,
        createdAt: createdAt,
        updatedAt: now,
        sourceTemplateId: t.sourceTemplateId ?? t.id,
        tags: t.tags,
        segments: [
          for (final segment in t.segments)
            FillInTheBlankSegment(
              id: uuid.v7(),
              cardId: targetId,
              fullText: segment.fullText,
              blankStart: segment.blankStart,
              blankEnd: segment.blankEnd,
              correctAnswer: segment.correctAnswer,
            ),
        ],
      ),
      MatchMadnessTemplate t => MatchMadnessTemplate(
        id: targetId,
        deckId: targetDeckId,
        sortOrder: t.sortOrder,
        createdAt: createdAt,
        updatedAt: now,
        sourceTemplateId: t.sourceTemplateId ?? t.id,
        tags: t.tags,
        pairs: [
          for (final pair in t.pairs)
            MatchMadnessPair(
              id: uuid.v7(),
              templateId: targetId,
              sourceTemplateId: pair.sourceTemplateId == null
                  ? null
                  : idMap[pair.sourceTemplateId] ?? pair.sourceTemplateId,
              term: pair.term,
              match: pair.match,
              isAutoPicked: pair.isAutoPicked,
              displayOrder: pair.displayOrder,
            ),
        ],
      ),
      WordScrambleTemplate t => WordScrambleTemplate(
        id: targetId,
        deckId: targetDeckId,
        sortOrder: t.sortOrder,
        createdAt: createdAt,
        updatedAt: now,
        sourceTemplateId: t.sourceTemplateId ?? t.id,
        tags: t.tags,
        sentenceToScramble: t.sentenceToScramble,
        imageUrl: t.imageUrl,
        audioUrl: t.audioUrl,
      ),
      _ => throw UnsupportedError(
        'Unsupported card template type: ${source.runtimeType}',
      ),
    };
  }

  static int _similarityScore({
    required CardTemplate incoming,
    required CardTemplate existing,
    required String incomingText,
    required String existingText,
    required CardSimilarityConfig similarity,
  }) {
    if (similarity.matchBySourceTemplateId) {
      final incomingSource = incoming.sourceTemplateId;
      final existingSource = existing.sourceTemplateId;
      if (incomingSource != null &&
          existingSource != null &&
          incomingSource == existingSource) {
        return 100;
      }
      if (incomingSource != null && incomingSource == existing.id) return 100;
      if (existingSource != null && existingSource == incoming.id) return 100;
    }

    return _diceCoefficientScore(incomingText, existingText);
  }

  static int _diceCoefficientScore(String a, String b) {
    if (a == b) return 100;
    if (a.isEmpty || b.isEmpty) return 0;
    if (a.length == 1 || b.length == 1) {
      return a[0] == b[0] ? 100 : 0;
    }

    final aPairs = _bigrams(a);
    final bPairs = _bigrams(b);
    var overlap = 0;
    final bCount = <String, int>{};
    for (final pair in bPairs) {
      bCount[pair] = (bCount[pair] ?? 0) + 1;
    }
    for (final pair in aPairs) {
      final count = bCount[pair] ?? 0;
      if (count > 0) {
        overlap++;
        bCount[pair] = count - 1;
      }
    }
    final score = (2 * overlap) / (aPairs.length + bPairs.length);
    return (score * 100).round();
  }

  static List<String> _bigrams(String value) {
    final trimmed = value.trim().toLowerCase();
    if (trimmed.length < 2) return [trimmed];
    final pairs = <String>[];
    for (var i = 0; i < trimmed.length - 1; i++) {
      pairs.add(trimmed.substring(i, i + 2));
    }
    return pairs;
  }

  static String _templatePreview(CardTemplate template) {
    return switch (template) {
      FlashcardTemplate t => '${t.frontText} -> ${t.backText}',
      IdentificationTemplate t => '${t.promptText} -> ${t.acceptedAnswers}',
      MultipleChoiceTemplate t =>
        '${t.questionPrompt} -> ${t.options.where((o) => o.isCorrect).map((o) => o.optionText).join(', ')}',
      FillInTheBlanksTemplate t =>
        t.segments.isEmpty
            ? ''
            : '${t.segments.first.fullText} -> ${t.segments.map((s) => s.correctAnswer).join(', ')}',
      MatchMadnessTemplate t =>
        t.pairs.take(3).map((p) => '${p.term}:${p.match}').join(', '),
      WordScrambleTemplate t => t.sentenceToScramble,
      _ => '',
    };
  }

  static Future<void> _storeBackup({
    required String operation,
    required String entityType,
    required String? entityId,
    required String title,
    required Map<String, dynamic> payload,
    required List<ChangeRecord> logs,
  }) async {
    final backup = ImportExportBackup(
      id: uuid.v7(),
      operation: operation,
      entityType: entityType,
      entityId: entityId,
      title: title,
      payloadJson: jsonEncode(payload),
      changeLogsJson: jsonEncode([for (final log in logs) log.toJson()]),
      createdAt: DateTime.now(),
    );
    await LocalDB.importExportBackup.upsert(backup);
  }
}

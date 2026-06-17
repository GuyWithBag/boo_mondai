// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/deck_downloads_service.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        CardTemplatesRemoteDB,
        ChangeLog,
        ChangePlan,
        ChangeResult,
        ChangeReviewController,
        ChangeReviewDiffService,
        ChangeReviewStatus,
        ChangeSource,
        ChangeType,
        Deck,
        DeckDownloadPayload,
        DecksRemoteDB,
        DownloadCheckpoint,
        DownloadCheckpointLocalDB,
        DownloadCheckpointStatus,
        FillInTheBlankSegment,
        FillInTheBlanksTemplate,
        FlashcardTemplate,
        IdentificationTemplate,
        LocalDB,
        MatchMadnessPair,
        MatchMadnessTemplate,
        MultipleChoiceOption,
        MultipleChoiceTemplate,
        RemoteDB,
        StudyCardService,
        VisibilityState,
        WordScrambleTemplate,
        uuid;

const _kPageSize = 20;

class DeckDownloadsService {
  DeckDownloadsService();

  final DecksRemoteDB _decks = RemoteDB.deck;
  final CardTemplatesRemoteDB _cardTemplates = RemoteDB.card;
  final DownloadCheckpointLocalDB _downloadCheckpoints =
      LocalDB.downloadCheckpoint;

  final Set<String> _pausedPlanIds = {};

  // ── Public API ────────────────────────────────────────────────────────────

  Future<ChangeResult<DeckDownloadPayload>> downloadDeck(
    Deck sourceDeck,
    ChangeReviewController reviewController, {
    String? resumePlanId,
  }) async {
    final reviewPlan = resumePlanId != null
        ? reviewController.planById(resumePlanId)!
        : reviewController.start(
            source: ChangeSource.deckDownload,
            title: sourceDeck.title,
            status: ChangeReviewStatus.previewing,
            progress: 0,
          );

    _pausedPlanIds.remove(reviewPlan.id);

    try {
      // 1. Fetch remote deck metadata
      reviewController.update(reviewPlan.id, progress: 0.05);
      final remoteDeck = await _decks.selectById(sourceDeck.id) ?? sourceDeck;

      // 2. Check for an existing local copy
      final localDeck = _findExistingDownload(remoteDeck.id);

      // 3. If already downloaded and no changes needed, return immediately
      final existingPlan = await previewDeckDownload(sourceDeck);
      if (localDeck != null && existingPlan.changes.isEmpty) {
        reviewController.complete(reviewPlan.id, changes: existingPlan.changes);
        return ChangeResult(
          value: existingPlan.payload,
          changes: existingPlan.changes,
        );
      }

      // 4. Load or create a checkpoint — existing is nullable, checkpoint is not
      final existing = _downloadCheckpoints.getByDeckId(remoteDeck.id);
      final alreadyFetchedIds =
          existing?.fetchedTemplateIds.toSet() ?? <String>{};

      final totalCount =
          existing?.totalTemplates ??
          await _fetchTotalTemplateCount(remoteDeck.id);

      var checkpoint = DownloadCheckpoint(
        deckId: remoteDeck.id,
        deckTitle: remoteDeck.title,
        totalTemplates: totalCount,
        fetchedTemplateIds: alreadyFetchedIds.toList(),
        status: DownloadCheckpointStatus.downloading,
        createdAt: existing?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _downloadCheckpoints.upsert(checkpoint);

      // 5. Stream templates in pages
      final allFetchedTemplates = <CardTemplate>[];
      var offset = alreadyFetchedIds.length;

      reviewController.update(
        reviewPlan.id,
        status: ChangeReviewStatus.applying,
        progress: _downloadProgress(offset, totalCount),
      );

      while (offset < totalCount) {
        // Check if paused between pages
        if (_pausedPlanIds.contains(reviewPlan.id)) {
          await _downloadCheckpoints.upsert(
            checkpoint.copyWith(
              status: DownloadCheckpointStatus.paused,
              updatedAt: DateTime.now(),
            ),
          );
          reviewController.update(
            reviewPlan.id,
            status: ChangeReviewStatus.paused,
          );
          return ChangeResult(
            value: existingPlan.payload,
            changes: existingPlan.changes,
          );
        }

        final page = await _cardTemplates.selectManyPaged(
          deckId: remoteDeck.id,
          offset: offset,
          pageSize: _kPageSize,
        );

        if (page.isEmpty) break;

        final newTemplates = page
            .where((t) => !alreadyFetchedIds.contains(t.id))
            .toList();
        allFetchedTemplates.addAll(newTemplates);
        alreadyFetchedIds.addAll(newTemplates.map((t) => t.id));
        offset = alreadyFetchedIds.length;

        checkpoint = checkpoint.copyWith(
          fetchedTemplateIds: alreadyFetchedIds.toList(),
          updatedAt: DateTime.now(),
        );
        await _downloadCheckpoints.upsert(checkpoint);

        reviewController.update(
          reviewPlan.id,
          progress: _downloadProgress(offset, totalCount),
        );
      }

      // 6. All templates fetched — write to local DB
      final localDeckId = localDeck?.id ?? uuid.v7();
      final now = DateTime.now();
      final newLocalDeck = remoteDeck.copyWith(
        id: localDeckId,
        userId: LocalDB.profile.getOrCreate().id,
        sourceDeckId: remoteDeck.id,
        visibilityState: VisibilityState.private,
        isPublished: false,
        isEditable: true,
        createdAt: localDeck?.createdAt ?? now,
        updatedAt: now,
        userProfile: null,
        listing: null,
      );

      final templateIdMap = {
        for (final t in allFetchedTemplates) t.id: uuid.v7(),
      };
      final localTemplates = [
        for (final t in allFetchedTemplates)
          _copyTemplate(
            t,
            localDeckId: localDeckId,
            localTemplateId: templateIdMap[t.id]!,
            templateIdMap: templateIdMap,
            now: now,
          ),
      ];

      await LocalDB.deck.upsert(newLocalDeck);
      await LocalDB.cardTemplate.upsertMany(localTemplates);
      await StudyCardService.syncDeckStudyCards(
        deckId: localDeckId,
        templates: localTemplates,
      );

      // 7. Clean up checkpoint
      await _downloadCheckpoints.deleteByPk({'deck_id': remoteDeck.id});

      final changes = _buildDownloadChanges(
        remoteDeck: remoteDeck,
        localDeck: localDeck,
        remoteTemplates: allFetchedTemplates,
        localTemplates: localDeck == null
            ? []
            : LocalDB.cardTemplate.getByDeckId(localDeckId),
      );

      reviewController.complete(reviewPlan.id, changes: changes);
      return ChangeResult(
        value: DeckDownloadPayload(
          remoteDeck: remoteDeck,
          localDeck: newLocalDeck,
          remoteTemplates: allFetchedTemplates,
          localTemplates: localTemplates,
        ).copyWith(downloadedDeck: newLocalDeck),
        changes: changes,
      );
    } catch (e) {
      reviewController.fail(reviewPlan.id, e);
      rethrow;
    }
  }

  void pauseDownload(String planId) {
    _pausedPlanIds.add(planId);
  }

  Future<ChangeResult<DeckDownloadPayload>> resumeDownload(
    Deck sourceDeck,
    ChangeReviewController reviewController,
    String planId,
  ) {
    return downloadDeck(sourceDeck, reviewController, resumePlanId: planId);
  }

  // ── Preview ───────────────────────────────────────────────────────────────

  Future<ChangePlan<DeckDownloadPayload>> previewDeckDownload(
    Deck sourceDeck,
  ) async {
    final remoteDeck = await _decks.selectById(sourceDeck.id) ?? sourceDeck;
    final localDeck = _findExistingDownload(remoteDeck.id);

    final remoteTemplates = await _cardTemplates.selectMany(
      filters: {'deck_id': remoteDeck.id},
      orderBy: 'sort_order',
      ascending: true,
    );
    final localTemplates = localDeck == null
        ? <CardTemplate>[]
        : LocalDB.cardTemplate.getByDeckId(localDeck.id);

    return ChangePlan(
      payload: DeckDownloadPayload(
        remoteDeck: remoteDeck,
        localDeck: localDeck,
        remoteTemplates: remoteTemplates,
        localTemplates: localTemplates,
      ),
      changes: _buildDownloadChanges(
        remoteDeck: remoteDeck,
        localDeck: localDeck,
        remoteTemplates: remoteTemplates,
        localTemplates: localTemplates,
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<int> _fetchTotalTemplateCount(String deckId) async {
    final rows = await _cardTemplates.client
        .from(_cardTemplates.tableName)
        .select('id')
        .eq('deck_id', deckId);
    return rows.length;
  }

  double _downloadProgress(int fetched, int total) {
    if (total == 0) return 0.5;
    return 0.1 + (fetched / total) * 0.8;
  }

  Deck? _findExistingDownload(String sourceDeckId) {
    final matches = LocalDB.deck.selectMany(
      where: (deck) => deck.sourceDeckId == sourceDeckId,
      limit: 1,
    );
    return matches.isEmpty ? null : matches.first;
  }

  List<ChangeLog> _buildDownloadChanges({
    required Deck remoteDeck,
    required Deck? localDeck,
    required List<CardTemplate> remoteTemplates,
    required List<CardTemplate> localTemplates,
  }) {
    final changes = <ChangeLog>[];

    if (localDeck == null) {
      changes.add(
        ChangeLog(
          type: ChangeType.added,
          source: ChangeSource.deckDownload,
          entityType: 'deck',
          entityId: remoteDeck.id,
          title: remoteDeck.title,
          subtitle: 'Deck will be added to your local library.',
          after: remoteDeck,
          remoteId: remoteDeck.id,
          remoteUpdatedAt: remoteDeck.updatedAt,
        ),
      );
      changes.addAll(
        remoteTemplates.map(
          (t) => ChangeLog(
            type: ChangeType.added,
            source: ChangeSource.deckDownload,
            entityType: 'card_template',
            entityId: t.id,
            title: ChangeReviewDiffService.templateTitle(t),
            subtitle: 'Card will be copied from the published deck.',
            after: t,
            remoteId: t.id,
            remoteUpdatedAt: t.updatedAt,
          ),
        ),
      );
      return changes;
    }

    if (remoteDeck.updatedAt.isAfter(localDeck.updatedAt)) {
      changes.add(
        ChangeLog(
          type: ChangeType.modified,
          source: ChangeSource.deckDownload,
          entityType: 'deck',
          entityId: localDeck.id,
          title: localDeck.title,
          subtitle: 'Published deck metadata is newer than your local copy.',
          before: localDeck,
          after: remoteDeck,
          fields: ChangeReviewDiffService.diffDecks(localDeck, remoteDeck),
          localId: localDeck.id,
          remoteId: remoteDeck.id,
          localUpdatedAt: localDeck.updatedAt,
          remoteUpdatedAt: remoteDeck.updatedAt,
        ),
      );
    }

    final localBySourceId = {
      for (final t in localTemplates)
        if (t.sourceTemplateId != null) t.sourceTemplateId!: t,
    };
    final remoteIds = remoteTemplates.map((t) => t.id).toSet();

    for (final remoteTemplate in remoteTemplates) {
      final localTemplate = localBySourceId[remoteTemplate.id];
      if (localTemplate == null) {
        changes.add(
          ChangeLog(
            type: ChangeType.added,
            source: ChangeSource.deckDownload,
            entityType: 'card_template',
            entityId: remoteTemplate.id,
            title: ChangeReviewDiffService.templateTitle(remoteTemplate),
            subtitle: 'Published deck has a card missing locally.',
            after: remoteTemplate,
            remoteId: remoteTemplate.id,
            remoteUpdatedAt: remoteTemplate.updatedAt,
          ),
        );
      } else if (remoteTemplate.updatedAt.isAfter(localTemplate.updatedAt)) {
        changes.add(
          ChangeLog(
            type: ChangeType.modified,
            source: ChangeSource.deckDownload,
            entityType: 'card_template',
            entityId: localTemplate.id,
            title: ChangeReviewDiffService.templateTitle(localTemplate),
            subtitle: 'Published card is newer than your local copy.',
            before: localTemplate,
            after: remoteTemplate,
            fields: ChangeReviewDiffService.diffTemplates(
              localTemplate,
              remoteTemplate,
            ),
            localId: localTemplate.id,
            remoteId: remoteTemplate.id,
            localUpdatedAt: localTemplate.updatedAt,
            remoteUpdatedAt: remoteTemplate.updatedAt,
          ),
        );
      }
    }

    for (final localTemplate in localTemplates) {
      final sourceId = localTemplate.sourceTemplateId;
      if (sourceId == null || remoteIds.contains(sourceId)) continue;
      changes.add(
        ChangeLog(
          type: ChangeType.removed,
          source: ChangeSource.deckDownload,
          entityType: 'card_template',
          entityId: localTemplate.id,
          title: ChangeReviewDiffService.templateTitle(localTemplate),
          subtitle:
              'Local card points to a published card that no longer exists.',
          before: localTemplate,
          localId: localTemplate.id,
          remoteId: sourceId,
          localUpdatedAt: localTemplate.updatedAt,
        ),
      );
    }

    return changes;
  }

  CardTemplate _copyTemplate(
    CardTemplate template, {
    required String localDeckId,
    required String localTemplateId,
    required Map<String, String> templateIdMap,
    required DateTime now,
  }) {
    return switch (template) {
      FlashcardTemplate t => FlashcardTemplate(
        id: localTemplateId,
        deckId: localDeckId,
        sortOrder: t.sortOrder,
        createdAt: now,
        updatedAt: now,
        sourceTemplateId: t.id,
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
        id: localTemplateId,
        deckId: localDeckId,
        sortOrder: t.sortOrder,
        createdAt: now,
        updatedAt: now,
        sourceTemplateId: t.id,
        tags: t.tags,
        promptText: t.promptText,
        acceptedAnswers: t.acceptedAnswers,
        imageUrl: t.imageUrl,
        audioUrl: t.audioUrl,
      ),
      MultipleChoiceTemplate t => MultipleChoiceTemplate(
        id: localTemplateId,
        deckId: localDeckId,
        sortOrder: t.sortOrder,
        createdAt: now,
        updatedAt: now,
        sourceTemplateId: t.id,
        tags: t.tags,
        questionPrompt: t.questionPrompt,
        options: [
          for (final option in t.options)
            MultipleChoiceOption(
              id: uuid.v7(),
              templateId: localTemplateId,
              optionText: option.optionText,
              isCorrect: option.isCorrect,
              displayOrder: option.displayOrder,
            ),
        ],
        imageUrl: t.imageUrl,
        audioUrl: t.audioUrl,
      ),
      FillInTheBlanksTemplate t => FillInTheBlanksTemplate(
        id: localTemplateId,
        deckId: localDeckId,
        sortOrder: t.sortOrder,
        createdAt: now,
        updatedAt: now,
        sourceTemplateId: t.id,
        tags: t.tags,
        segments: [
          for (final segment in t.segments)
            FillInTheBlankSegment(
              id: uuid.v7(),
              cardId: localTemplateId,
              fullText: segment.fullText,
              blankStart: segment.blankStart,
              blankEnd: segment.blankEnd,
              correctAnswer: segment.correctAnswer,
            ),
        ],
      ),
      MatchMadnessTemplate t => MatchMadnessTemplate(
        id: localTemplateId,
        deckId: localDeckId,
        sortOrder: t.sortOrder,
        createdAt: now,
        updatedAt: now,
        sourceTemplateId: t.id,
        tags: t.tags,
        pairs: [
          for (final pair in t.pairs)
            MatchMadnessPair(
              id: uuid.v7(),
              templateId: localTemplateId,
              sourceTemplateId: pair.sourceTemplateId == null
                  ? null
                  : templateIdMap[pair.sourceTemplateId] ??
                        pair.sourceTemplateId,
              term: pair.term,
              match: pair.match,
              isAutoPicked: pair.isAutoPicked,
              displayOrder: pair.displayOrder,
            ),
        ],
      ),
      WordScrambleTemplate t => WordScrambleTemplate(
        id: localTemplateId,
        deckId: localDeckId,
        sortOrder: t.sortOrder,
        createdAt: now,
        updatedAt: now,
        sourceTemplateId: t.id,
        tags: t.tags,
        sentenceToScramble: t.sentenceToScramble,
        imageUrl: t.imageUrl,
        audioUrl: t.audioUrl,
      ),
      _ => throw UnsupportedError(
        'Unsupported card template type: ${template.runtimeType}',
      ),
    };
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/deck_downloads_service.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        CardTemplatesRemoteDB,
        ChangedEntity,
        ChangeDirection,
        PreviewedChangePlan,
        ChangeResult,
        ChangeTrackerService,
        ChangedEntityHelper,
        ChangeTrackerStatus,
        ChangeSource,
        ChangeType,
        Deck,
        DeckDownloadPayload,
        DecksRemoteDB,
        FillInTheBlankSegment,
        FillInTheBlanksTemplate,
        FlashcardTemplate,
        IdentificationTemplate,
        StoredMediaService,
        StoredMediaPathHelper,
        ImageHelper,
        LocalDB,
        MatchMadnessPair,
        MatchMadnessTemplate,
        MultipleChoiceOption,
        MultipleChoiceTemplate,
        ProgressCheckpointService,
        ProgressCheckpointType,
        RemoteDB,
        Service,
        StudyCardService,
        VisibilityState,
        WordScrambleTemplate,
        uuid,
        ChangeTrackerEntry;
import 'package:boo_mondai/core/services/service_registry.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show CountOption;

const _kPageSize = 20;

class DeckDownloadsService extends Service {
  DeckDownloadsService({
    ChangeTrackerService? changeTrackerService,
    ProgressCheckpointService? progressCheckpointService,
  }) : progressCheckpointService =
           progressCheckpointService ?? ProgressCheckpointService(),
       changeTrackerService = ServiceRegistry.add(
         changeTrackerService ??
             ChangeTrackerService(
               inboundLabel: 'download',
               outboundLabel: 'upload',
             ),
       );

  @override
  String get name => 'DeckDownloadsService';

  final ChangeTrackerService changeTrackerService;
  final ProgressCheckpointService progressCheckpointService;

  final DecksRemoteDB _decks = RemoteDB.deck;
  final CardTemplatesRemoteDB _cardTemplates = RemoteDB.card;

  final Set<String> _pausedEntryIds = {};

  // ── Public API ────────────────────────────────────────────────────────────

  Future<ChangeResult<DeckDownloadPayload, Object?>> downloadDeck(
    Deck sourceDeck, {
    String? resumeEntryId,
  }) async {
    final entry = resumeEntryId != null
        ? changeTrackerService.entryById(resumeEntryId)!
        : changeTrackerService.start(
            entry: ChangeTrackerEntry(
              source: ChangeSource.deckDownload,
              title: sourceDeck.title,
              status: ChangeTrackerStatus.planning,
              progress: 0,
            ),
          );

    _pausedEntryIds.remove(entry.id);

    try {
      // 1. Fetch remote deck metadata
      changeTrackerService.update(entry.id, progress: 0.05);
      final remoteDeck = await _decks.selectById(sourceDeck.id) ?? sourceDeck;

      // 2. Check for an existing local copy
      final localDeck = _findExistingDownload(remoteDeck.id);

      // 3. If already downloaded and no changes needed, return immediately
      final existingPlan = await previewDeckDownload(sourceDeck);
      if (localDeck != null && existingPlan.changes.isEmpty) {
        changeTrackerService.complete(entry.id, changes: existingPlan.changes);
        return ChangeResult(
          value: existingPlan.payload,
          changes: existingPlan.changes,
        );
      }

      // 4. Load or create a checkpoint — existing is nullable, checkpoint is not
      final existing = progressCheckpointService.getByTypeAndTargetId(
        ProgressCheckpointType.deckDownloadFetch,
        remoteDeck.id,
      );
      final alreadyFetchedIds =
          existing?.completedTargetItemIds.toSet() ?? <String>{};

      final totalCount =
          existing?.totalItems ?? await _fetchTotalTemplateCount(remoteDeck.id);

      var checkpoint = progressCheckpointService.start(
        type: ProgressCheckpointType.deckDownloadFetch,
        targetId: remoteDeck.id,
        operationDescription: 'Fetching deck templates',
        totalItems: totalCount,
        completedTargetItemIds: alreadyFetchedIds,
      );

      // 5. Stream templates in pages
      final allFetchedTemplates = <CardTemplate>[];
      var offset = alreadyFetchedIds.length;

      changeTrackerService.update(
        entry.id,
        status: ChangeTrackerStatus.applying,
        progress: _downloadProgress(offset, totalCount),
      );

      while (offset < totalCount) {
        // Check if paused between pages
        if (_pausedEntryIds.contains(entry.id)) {
          progressCheckpointService.pause(checkpoint.id);
          changeTrackerService.update(
            entry.id,
            status: ChangeTrackerStatus.paused,
          );
          return ChangeResult(
            value: existingPlan.payload,
            changes: existingPlan.changes,
          );
        }

        final page = await _cardTemplates.selectManyPaged(
          filters: {'deck_id': remoteDeck.id},
          orderBy: 'sort_order',
          offset: offset,
          pageSize: _kPageSize,
        );

        if (page.isEmpty) break;

        final newTemplates = page
            .where((t) => !alreadyFetchedIds.contains(t.id))
            .toList();
        allFetchedTemplates.addAll(newTemplates);
        final pageIds = newTemplates.map((template) => template.id).toList();
        alreadyFetchedIds.addAll(pageIds);
        checkpoint = progressCheckpointService.markItemsCompleted(
          checkpointId: checkpoint.id,
          itemIds: pageIds,
        );
        offset = alreadyFetchedIds.length;

        changeTrackerService.update(
          entry.id,
          progress: _downloadProgress(offset, totalCount),
        );
      }

      // 6. All templates fetched — write to local DB
      final localDeckId = localDeck?.id ?? uuid.v7();
      final now = DateTime.now();
      var newLocalDeck = remoteDeck.copyWith(
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
      final coverRemotePath = remoteDeck.coverImageUrl;
      if (coverRemotePath != null && ImageHelper.isRemoteUrl(coverRemotePath)) {
        final coverLocalPath = await StoredMediaService.remoteToLocal(
          path: StoredMediaPathHelper.deckCoverImage(
            deckTitle: newLocalDeck.title,
          ),
          remoteUrl: coverRemotePath,
        );
        if (coverLocalPath != null) {
          await LocalDB.deck.upsert(newLocalDeck.copyWith(updatedAt: now));
        }
      }
      await LocalDB.cardTemplate.upsertMany(localTemplates);
      await StudyCardService.syncDeckStudyCards(
        deckId: localDeckId,
        templates: localTemplates,
      );

      // 7. Clean up checkpoint
      await progressCheckpointService.delete(checkpoint.id);

      final changes = _buildDownloadChanges(
        remoteDeck: remoteDeck,
        localDeck: localDeck,
        remoteTemplates: allFetchedTemplates,
        localTemplates: localDeck == null
            ? []
            : LocalDB.cardTemplate.getByDeckId(localDeckId),
      );

      changeTrackerService.complete(entry.id, changes: changes);
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
      changeTrackerService.fail(entry.id, e);
      rethrow;
    }
  }

  void pauseDownload(String entryId) {
    _pausedEntryIds.add(entryId);
  }

  Future<ChangeResult<DeckDownloadPayload, Object?>> resumeDownload(
    Deck sourceDeck,
    String entryId,
  ) {
    return downloadDeck(sourceDeck, resumeEntryId: entryId);
  }

  // ── Preview ───────────────────────────────────────────────────────────────

  Future<PreviewedChangePlan<DeckDownloadPayload, Object?>> previewDeckDownload(
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

    return PreviewedChangePlan(
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
    final count = await _cardTemplates.client
        .from(_cardTemplates.tableName)
        .count(CountOption.exact)
        .eq('deck_id', deckId);
    return count;
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

  List<ChangedEntity> _buildDownloadChanges({
    required Deck remoteDeck,
    required Deck? localDeck,
    required List<CardTemplate> remoteTemplates,
    required List<CardTemplate> localTemplates,
  }) {
    final changes = <ChangedEntity>[];

    if (localDeck == null) {
      changes.add(
        ChangedEntity(
          changeType: ChangeType.added,
          source: ChangeSource.deckDownload,
          direction: ChangeDirection.inbound,
          id: remoteDeck.id,
          afterChange: remoteDeck,
          remoteId: remoteDeck.id,
          remoteUpdatedAt: remoteDeck.updatedAt,
        ),
      );
      changes.addAll(
        remoteTemplates.map(
          (t) => ChangedEntity(
            changeType: ChangeType.added,
            source: ChangeSource.deckDownload,
            direction: ChangeDirection.inbound,
            id: t.id,
            afterChange: t,
            remoteId: t.id,
            remoteUpdatedAt: t.updatedAt,
          ),
        ),
      );
      return changes;
    }

    if (remoteDeck.updatedAt.isAfter(localDeck.updatedAt)) {
      changes.add(
        ChangedEntity(
          changeType: ChangeType.modified,
          source: ChangeSource.deckDownload,
          direction: ChangeDirection.inbound,
          id: localDeck.id,
          beforeChange: localDeck,
          afterChange: remoteDeck,
          changedProperties: ChangedEntityHelper.getChangedProperties(
            before: localDeck.toMap(),
            after: remoteDeck.toMap(),
          ),
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
          ChangedEntity(
            changeType: ChangeType.added,
            source: ChangeSource.deckDownload,
            direction: ChangeDirection.inbound,
            id: remoteTemplate.id,
            afterChange: remoteTemplate,
            remoteId: remoteTemplate.id,
            remoteUpdatedAt: remoteTemplate.updatedAt,
          ),
        );
      } else if (remoteTemplate.updatedAt.isAfter(localTemplate.updatedAt)) {
        changes.add(
          ChangedEntity(
            changeType: ChangeType.modified,
            source: ChangeSource.deckDownload,
            direction: ChangeDirection.inbound,
            id: localTemplate.id,
            beforeChange: localTemplate,
            afterChange: remoteTemplate,
            changedProperties: ChangedEntityHelper.getChangedProperties(
              before: localTemplate.toMap(),
              after: remoteTemplate.toMap(),
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
        ChangedEntity(
          changeType: ChangeType.removed,

          source: ChangeSource.deckDownload,
          direction: ChangeDirection.inbound,
          id: localTemplate.id,
          beforeChange: localTemplate,
          afterChange: localTemplate,
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
      ),
      _ => throw UnsupportedError(
        'Unsupported card template type: ${template.runtimeType}',
      ),
    };
  }
}

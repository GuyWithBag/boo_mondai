import 'package:boo_mondai/lib.barrel.dart'
    show
        DecksRemoteDB,
        CardTemplatesRemoteDB,
        Deck,
        CardTemplate,
        FlashcardTemplate,
        IdentificationTemplate,
        MultipleChoiceTemplate,
        FillInTheBlanksTemplate,
        MatchMadnessTemplate,
        WordScrambleTemplate,
        LocalDB,
        uuid,
        VisibilityState,
        MultipleChoiceOption,
        FillInTheBlankSegment,
        MatchMadnessPair,
        StudyCardService,
        SyncChangeLog,
        SyncChangeType,
        SyncOperationType,
        SyncOperationLog,
        SyncOperationProgress,
        DeckDownloadResult,
        DeckDownloadPlan;

/// Downloads an online deck into the current user's local deck library.
///
/// The downloaded deck is stored as a private, editable local copy. The
/// original remote deck and template IDs are preserved in `source*Id` fields so
/// the app can recognize repeated downloads and trace local content back to the
/// published source.
class DeckDownloadsService {
  DeckDownloadsService({
    DecksRemoteDB? decksRemoteDB,
    CardTemplatesRemoteDB? cardTemplatesRemoteDB,
  }) : _decksRemoteDB = decksRemoteDB ?? DecksRemoteDB(),
       _cardTemplatesRemoteDB =
           cardTemplatesRemoteDB ?? CardTemplatesRemoteDB();

  final DecksRemoteDB _decksRemoteDB;
  final CardTemplatesRemoteDB _cardTemplatesRemoteDB;

  /// Creates a local copy of [sourceDeck] and all of its card templates.
  ///
  /// If the deck was already downloaded, this returns the existing local deck
  /// instead of creating duplicates. Otherwise it fetches the latest remote
  /// deck row when available, clones the deck/templates with fresh local IDs,
  /// creates the review cards needed by FSRS, persists everything locally, and
  /// returns the new local deck.
  Future<DeckDownloadResult> downloadDeck(Deck sourceDeck) async {
    final operation = SyncOperationLog.instance.start(
      kind: SyncOperationType.deckDownload,
      subjectId: sourceDeck.id,
      subjectTitle: sourceDeck.title,
      progress: const SyncOperationProgress.indeterminate(
        label: 'Preparing download',
      ),
    );

    try {
      SyncOperationLog.instance.update(
        operation.id,
        progress: const SyncOperationProgress(
          completed: 0,
          total: 4,
          label: 'Fetching deck',
        ),
      );
      final plan = await previewDeckDownload(sourceDeck);
      SyncOperationLog.instance.update(
        operation.id,
        progress: const SyncOperationProgress(
          completed: 1,
          total: 4,
          label: 'Planning changes',
        ),
        changes: plan.changes,
      );

      if (plan.localDeck != null) {
        SyncOperationLog.instance.succeed(
          operation.id,
          progress: const SyncOperationProgress(
            completed: 4,
            total: 4,
            label: 'Already downloaded',
          ),
          changes: plan.changes,
        );
        return DeckDownloadResult(
          deck: plan.localDeck!,
          plan: plan,
          alreadyDownloaded: true,
        );
      }

      final localDeck = await _createLocalCopy(
        remoteDeck: plan.remoteDeck,
        remoteTemplates: plan.remoteTemplates,
        operationId: operation.id,
      );

      SyncOperationLog.instance.succeed(
        operation.id,
        progress: const SyncOperationProgress(
          completed: 4,
          total: 4,
          label: 'Download complete',
        ),
        changes: plan.changes,
      );
      return DeckDownloadResult(
        deck: localDeck,
        plan: plan,
        alreadyDownloaded: false,
      );
    } catch (e) {
      SyncOperationLog.instance.fail(operation.id, e);
      rethrow;
    }
  }

  Future<DeckDownloadPlan> previewDeckDownload(Deck sourceDeck) async {
    final remoteDeck =
        await _decksRemoteDB.selectById(sourceDeck.id) ?? sourceDeck;
    final localDeck = _findExistingDownload(remoteDeck.id);

    // Fetch templates in author-defined order so the local deck preserves the
    // same card sequence as the published deck.
    final remoteTemplates = await _cardTemplatesRemoteDB.selectMany(
      filters: {'deck_id': remoteDeck.id},
      orderBy: 'sort_order',
      ascending: true,
    );
    final localTemplates = localDeck == null
        ? <CardTemplate>[]
        : LocalDB.cardTemplate.getByDeckId(localDeck.id);

    return DeckDownloadPlan(
      remoteDeck: remoteDeck,
      localDeck: localDeck,
      remoteTemplates: remoteTemplates,
      localTemplates: localTemplates,
      changes: _buildDownloadChanges(
        remoteDeck: remoteDeck,
        localDeck: localDeck,
        remoteTemplates: remoteTemplates,
        localTemplates: localTemplates,
      ),
    );
  }

  Future<Deck> _createLocalCopy({
    required Deck remoteDeck,
    required List<CardTemplate> remoteTemplates,
    required String operationId,
  }) async {
    final currentProfile = LocalDB.profile.getOrCreate();
    final now = DateTime.now();
    final localDeckId = uuid.v7();
    final localDeck = remoteDeck.copyWith(
      id: localDeckId,
      userId: currentProfile.id,
      sourceDeckId: remoteDeck.id,
      visibilityState: VisibilityState.private,
      isPublished: false,
      isEditable: true,
      createdAt: now,
      updatedAt: now,
      userProfile: null,
      listing: null,
    );

    SyncOperationLog.instance.update(
      operationId,
      progress: const SyncOperationProgress(
        completed: 2,
        total: 4,
        label: 'Copying cards',
      ),
    );

    // Precompute every remote-template -> local-template ID mapping before
    // copying templates. Some child records, such as Match Madness auto-picked
    // pairs, can refer to another template in the same deck.
    final templateIdMap = {
      for (final template in remoteTemplates) template.id: uuid.v7(),
    };
    final localTemplates = [
      for (final template in remoteTemplates)
        _copyTemplate(
          template,
          localDeckId: localDeckId,
          localTemplateId: templateIdMap[template.id]!,
          templateIdMap: templateIdMap,
          now: now,
        ),
    ];
    await LocalDB.deck.upsert(localDeck);
    await LocalDB.cardTemplate.upsertMany(localTemplates);
    SyncOperationLog.instance.update(
      operationId,
      progress: const SyncOperationProgress(
        completed: 3,
        total: 4,
        label: 'Creating study cards',
      ),
    );
    await StudyCardService.syncDeckStudyCards(
      deckId: localDeckId,
      templates: localTemplates,
    );

    return localDeck;
  }

  List<SyncChangeLog> _buildDownloadChanges({
    required Deck remoteDeck,
    required Deck? localDeck,
    required List<CardTemplate> remoteTemplates,
    required List<CardTemplate> localTemplates,
  }) {
    final changes = <SyncChangeLog>[];
    if (localDeck == null) {
      changes.add(
        SyncChangeLog(
          type: SyncChangeType.created,
          entityType: 'deck',
          entityId: remoteDeck.id,
          remoteId: remoteDeck.id,
          remoteUpdatedAt: remoteDeck.updatedAt,
          message: 'Deck will be added to your local library.',
        ),
      );
      changes.addAll(
        remoteTemplates.map(
          (template) => SyncChangeLog(
            type: SyncChangeType.created,
            entityType: 'card_template',
            entityId: template.id,
            remoteId: template.id,
            remoteUpdatedAt: template.updatedAt,
            message: 'Card will be copied from the published deck.',
          ),
        ),
      );
      return changes;
    }

    if (remoteDeck.updatedAt.isAfter(localDeck.updatedAt)) {
      changes.add(
        SyncChangeLog(
          type: SyncChangeType.updated,
          entityType: 'deck',
          entityId: localDeck.id,
          localId: localDeck.id,
          remoteId: remoteDeck.id,
          localUpdatedAt: localDeck.updatedAt,
          remoteUpdatedAt: remoteDeck.updatedAt,
          message: 'Published deck metadata is newer than your local copy.',
        ),
      );
    }

    final localBySourceId = {
      for (final template in localTemplates)
        if (template.sourceTemplateId != null)
          template.sourceTemplateId!: template,
    };
    final remoteIds = remoteTemplates.map((template) => template.id).toSet();

    for (final remoteTemplate in remoteTemplates) {
      final localTemplate = localBySourceId[remoteTemplate.id];
      if (localTemplate == null) {
        changes.add(
          SyncChangeLog(
            type: SyncChangeType.created,
            entityType: 'card_template',
            entityId: remoteTemplate.id,
            remoteId: remoteTemplate.id,
            remoteUpdatedAt: remoteTemplate.updatedAt,
            message: 'Published deck has a card missing locally.',
          ),
        );
      } else if (remoteTemplate.updatedAt.isAfter(localTemplate.updatedAt)) {
        changes.add(
          SyncChangeLog(
            type: SyncChangeType.updated,
            entityType: 'card_template',
            entityId: localTemplate.id,
            localId: localTemplate.id,
            remoteId: remoteTemplate.id,
            localUpdatedAt: localTemplate.updatedAt,
            remoteUpdatedAt: remoteTemplate.updatedAt,
            message: 'Published card is newer than your local copy.',
          ),
        );
      }
    }

    for (final localTemplate in localTemplates) {
      final sourceTemplateId = localTemplate.sourceTemplateId;
      if (sourceTemplateId == null || remoteIds.contains(sourceTemplateId)) {
        continue;
      }
      changes.add(
        SyncChangeLog(
          type: SyncChangeType.deletedRemotely,
          entityType: 'card_template',
          entityId: localTemplate.id,
          localId: localTemplate.id,
          remoteId: sourceTemplateId,
          localUpdatedAt: localTemplate.updatedAt,
          message:
              'Local card points to a published card that no longer exists.',
        ),
      );
    }

    return changes;
  }

  /// Returns the local deck previously cloned from [sourceDeckId], if present.
  Deck? _findExistingDownload(String sourceDeckId) {
    final matches = LocalDB.deck.selectMany(
      where: (deck) => deck.sourceDeckId == sourceDeckId,
      limit: 1,
    );
    return matches.isEmpty ? null : matches.first;
  }

  CardTemplate _copyTemplate(
    CardTemplate template, {
    required String localDeckId,
    required String localTemplateId,
    required Map<String, String> templateIdMap,
    required DateTime now,
  }) {
    // Each template subtype owns different nested data, so copying is explicit
    // instead of relying on a base-class copy that could miss subtype fields.
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
              // Auto-picked pairs can point at a source template. Prefer the
              // newly generated local ID when the referenced template was part
              // of this download; otherwise keep the original external ID.
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

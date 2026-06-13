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
        ChangeLog,
        ChangePlan,
        ChangeResult,
        ChangeReviewDiffService,
        ChangeReviewStatus,
        ChangeReviewStore,
        ChangeSource,
        ChangeType,
        DeckDownloadPayload;

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
  Future<ChangeResult<DeckDownloadPayload>> downloadDeck(
    Deck sourceDeck,
  ) async {
    final reviewPlan = ChangeReviewStore.instance.start(
      source: ChangeSource.deckDownload,
      title: 'Deck Download',
      status: ChangeReviewStatus.previewing,
      progress: 0,
    );

    try {
      ChangeReviewStore.instance.update(reviewPlan.id, progress: 0.25);
      final plan = await previewDeckDownload(sourceDeck);
      ChangeReviewStore.instance.update(
        reviewPlan.id,
        status: ChangeReviewStatus.applying,
        progress: 0.5,
        changes: plan.changes,
      );

      if (plan.payload.localDeck != null) {
        ChangeReviewStore.instance.complete(
          reviewPlan.id,
          changes: plan.changes,
        );
        return ChangeResult(value: plan.payload, changes: plan.changes);
      }

      final localDeck = await _createLocalCopy(
        remoteDeck: plan.payload.remoteDeck,
        remoteTemplates: plan.payload.remoteTemplates,
        reviewPlanId: reviewPlan.id,
      );

      ChangeReviewStore.instance.complete(reviewPlan.id, changes: plan.changes);
      return ChangeResult(
        value: plan.payload.copyWith(downloadedDeck: localDeck),
        changes: plan.changes,
      );
    } catch (e) {
      ChangeReviewStore.instance.fail(reviewPlan.id, e);
      rethrow;
    }
  }

  Future<ChangePlan<DeckDownloadPayload>> previewDeckDownload(
    Deck sourceDeck,
  ) async {
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

  Future<Deck> _createLocalCopy({
    required Deck remoteDeck,
    required List<CardTemplate> remoteTemplates,
    required String reviewPlanId,
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

    ChangeReviewStore.instance.update(reviewPlanId, progress: 0.75);

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
    ChangeReviewStore.instance.update(reviewPlanId, progress: 0.9);
    await StudyCardService.syncDeckStudyCards(
      deckId: localDeckId,
      templates: localTemplates,
    );

    return localDeck;
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
          (template) => ChangeLog(
            type: ChangeType.added,
            source: ChangeSource.deckDownload,
            entityType: 'card_template',
            entityId: template.id,
            title: ChangeReviewDiffService.templateTitle(template),
            subtitle: 'Card will be copied from the published deck.',
            after: template,
            remoteId: template.id,
            remoteUpdatedAt: template.updatedAt,
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
      for (final template in localTemplates)
        if (template.sourceTemplateId != null)
          template.sourceTemplateId!: template,
    };
    final remoteIds = remoteTemplates.map((template) => template.id).toSet();

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
      final sourceTemplateId = localTemplate.sourceTemplateId;
      if (sourceTemplateId == null || remoteIds.contains(sourceTemplateId)) {
        continue;
      }
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
          remoteId: sourceTemplateId,
          localUpdatedAt: localTemplate.updatedAt,
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

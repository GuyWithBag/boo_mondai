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
        StudyCardService;

/// Downloads an online deck into the current user's local deck library.
///
/// The downloaded deck is stored as a private, editable local copy. The
/// original remote deck and template IDs are preserved in `source*Id` fields so
/// the app can recognize repeated downloads and trace local content back to the
/// published source.
class DeckDownloadsOnlineService {
  DeckDownloadsOnlineService({
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
  Future<Deck> downloadDeck(Deck sourceDeck) async {
    final existingDeck = _findExistingDownload(sourceDeck.id);
    if (existingDeck != null) return existingDeck;

    final remoteDeck =
        await _decksRemoteDB.selectById(sourceDeck.id) ?? sourceDeck;
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

    // Fetch templates in author-defined order so the local deck preserves the
    // same card sequence as the published deck.
    final remoteTemplates = await _cardTemplatesRemoteDB.selectMany(
      filters: {'deck_id': remoteDeck.id},
      orderBy: 'sort_order',
      ascending: true,
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
    await StudyCardService.syncDeckStudyCards(
      deckId: localDeckId,
      templates: localTemplates,
    );

    return localDeck;
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

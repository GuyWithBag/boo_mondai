import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplatesLocalDB,
        CardTemplatesRemoteDB,
        ChangeTrackerController,
        DeckListingsLocalDB,
        DeckListingsRemoteDB,
        DecksLocalDB,
        DecksRemoteDB,
        FsrsCardsLocalDB,
        FsrsCardsRemoteDB,
        ReviewLogsLocalDB,
        ReviewLogsRemoteDB,
        SyncDeletionLocalDB,
        TagLocalDB,
        TagsRemoteDB,
        DeckTagsLocalDB,
        DeckTagsRemoteDB,
        CardTemplateTagsLocalDB,
        CardTemplateTagsRemoteDB,
        UserStudyCardTagsLocalDB,
        UserStudyCardTagsRemoteDB,
        PublicBucketRemoteDB,
        StudyCardsLocalDB,
        StudyCardsRemoteDB,
        SyncStrategy,
        Deck,
        DeckListing,
        CardTemplate,
        StudyCard,
        FsrsCard,
        FsrsReviewLog,
        SyncDeletionService,
        NewestWinsSyncStrategy,
        DeckMediaSyncPreprocessor,
        DeckListingMediaSyncPreprocessor,
        CardTemplateMediaSyncPreprocessor,
        DeckListingsService,
        CardTemplatesService,
        StudyCardService,
        FsrsService,
        DecksService,
        AppendOnlySyncStrategy;

/// Runtime scope and dependencies for one deck sync operation.
///
/// This is not UI context. It identifies the sync target with [userId] and
/// optional [deckId], and provides the local/remote repositories, storage
/// access, and change tracker needed while previewing and applying sync steps.
class DeckSyncSession {
  const DeckSyncSession({
    required this.userId,
    required this.changeTrackerController,
    required this.decks,
    required this.remoteDecks,
    required this.deckListings,
    required this.remoteDeckListings,
    required this.cardTemplates,
    required this.remoteCardTemplates,
    required this.studyCards,
    required this.remoteStudyCards,
    required this.fsrsCards,
    required this.remoteFsrsCards,
    required this.reviewLogs,
    required this.remoteReviewLogs,
    required this.syncDeletions,
    required this.tags,
    required this.remoteTags,
    required this.deckTags,
    required this.remoteDeckTags,
    required this.cardTemplateTags,
    required this.remoteCardTemplateTags,
    required this.userStudyCardTags,
    required this.remoteUserStudyCardTags,
    required this.remoteStorage,
    this.deckId,
  });

  final String userId;
  final String? deckId;
  final ChangeTrackerController changeTrackerController;

  final DecksLocalDB decks;
  final DecksRemoteDB remoteDecks;

  final DeckListingsLocalDB deckListings;
  final DeckListingsRemoteDB remoteDeckListings;

  final CardTemplatesLocalDB cardTemplates;
  final CardTemplatesRemoteDB remoteCardTemplates;

  final StudyCardsLocalDB studyCards;
  final StudyCardsRemoteDB remoteStudyCards;

  final FsrsCardsLocalDB fsrsCards;
  final FsrsCardsRemoteDB remoteFsrsCards;

  final ReviewLogsLocalDB reviewLogs;
  final ReviewLogsRemoteDB remoteReviewLogs;

  final SyncDeletionLocalDB syncDeletions;

  final TagLocalDB tags;
  final TagsRemoteDB remoteTags;

  final DeckTagsLocalDB deckTags;
  final DeckTagsRemoteDB remoteDeckTags;

  final CardTemplateTagsLocalDB cardTemplateTags;
  final CardTemplateTagsRemoteDB remoteCardTemplateTags;

  final UserStudyCardTagsLocalDB userStudyCardTags;
  final UserStudyCardTagsRemoteDB remoteUserStudyCardTags;

  final PublicBucketRemoteDB remoteStorage;

  List<SyncStrategy<dynamic, DeckSyncSession>> getStrategies() {
    return <SyncStrategy<dynamic, DeckSyncSession>>[
      SyncDeletionService.createStrategy(this),
      NewestWinsSyncStrategy<Deck, DeckSyncSession>(
        name: 'decks',
        localDb: decks,
        remoteDb: remoteDecks,
        localIndex: DecksService.loadLocalDeckSyncIndexForSyncSession,
        remoteIndex: DecksService.loadRemoteDeckSyncIndexForSyncSession,
        localItemsByIds: DecksService.loadLocalDecksByIdsForSyncSession,
        remoteItemsByIds: DecksService.loadRemoteDecksByIdsForSyncSession,
        itemId: (deck) => deck.id,
        preprocessPushItem: (deck, session) =>
            DeckMediaSyncPreprocessor.preprocessPushItem(
              deck: deck,
              session: session,
            ),
        itemToChangeMap: remoteDecks.toMap,
      ),
      NewestWinsSyncStrategy<DeckListing, DeckSyncSession>(
        name: 'deck_listings',
        localDb: deckListings,
        remoteDb: remoteDeckListings,
        localIndex:
            DeckListingsService.loadLocalDeckListingSyncIndexForSyncSession,
        remoteIndex:
            DeckListingsService.loadRemoteDeckListingSyncIndexForSyncSession,
        localItemsByIds:
            DeckListingsService.loadLocalDeckListingsByIdsForSyncSession,
        remoteItemsByIds:
            DeckListingsService.loadRemoteDeckListingsByIdsForSyncSession,
        itemId: (listing) => listing.deckId,
        preprocessPushItem: (listing, session) =>
            DeckListingMediaSyncPreprocessor.preprocessPushItem(
              listing: listing,
              session: session,
            ),
        itemToChangeMap: remoteDeckListings.toMap,
      ),
      NewestWinsSyncStrategy<CardTemplate, DeckSyncSession>(
        name: 'card_templates',
        localDb: cardTemplates,
        remoteDb: remoteCardTemplates,
        localIndex:
            CardTemplatesService.loadLocalCardTemplateSyncIndexForSyncSession,
        remoteIndex:
            CardTemplatesService.loadRemoteCardTemplateSyncIndexForSyncSession,
        localItemsByIds:
            CardTemplatesService.loadLocalCardTemplatesByIdsForSyncSession,
        remoteItemsByIds:
            CardTemplatesService.loadRemoteCardTemplatesByIdsForSyncSession,
        itemId: (template) => template.id,
        preprocessPushItem: (template, session) =>
            CardTemplateMediaSyncPreprocessor.preprocessPushItem(
              template: template,
              session: session,
            ),
        itemToChangeMap: remoteCardTemplates.toMap,
      ),
      NewestWinsSyncStrategy<StudyCard, DeckSyncSession>(
        name: 'study_cards',
        localDb: studyCards,
        remoteDb: remoteStudyCards,
        localIndex: StudyCardService.loadLocalStudyCardSyncIndexForSyncSession,
        remoteIndex:
            StudyCardService.loadRemoteStudyCardSyncIndexForSyncSession,
        localItemsByIds:
            StudyCardService.loadLocalStudyCardsByIdsForSyncSession,
        remoteItemsByIds:
            StudyCardService.loadRemoteStudyCardsByIdsForSyncSession,
        itemId: (card) => card.id,
        itemToChangeMap: remoteStudyCards.toMap,
      ),
      NewestWinsSyncStrategy<FsrsCard, DeckSyncSession>(
        name: 'fsrs_cards',
        localDb: fsrsCards,
        remoteDb: remoteFsrsCards,
        localIndex: FsrsService.loadLocalFsrsCardSyncIndexForSyncSession,
        remoteIndex: FsrsService.loadRemoteFsrsCardSyncIndexForSyncSession,
        localItemsByIds: FsrsService.loadLocalFsrsCardsByIdsForSyncSession,
        remoteItemsByIds: FsrsService.loadRemoteFsrsCardsByIdsForSyncSession,
        itemId: (card) => card.id,
        itemToChangeMap: remoteFsrsCards.toMap,
      ),
      AppendOnlySyncStrategy<FsrsReviewLog, DeckSyncSession>(
        name: 'review_logs',
        localDb: reviewLogs,
        remoteDb: remoteReviewLogs,
        localIndex: FsrsService.loadLocalReviewLogSyncIndexForSyncSession,
        remoteIndex: FsrsService.loadRemoteReviewLogSyncIndexForSyncSession,
        localItemsByIds: FsrsService.loadLocalReviewLogsByIdsForSyncSession,
        remoteItemsByIds: FsrsService.loadRemoteReviewLogsByIdsForSyncSession,
        itemId: (log) => log.id,
      ),
    ];
  }
}

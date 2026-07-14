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
        StorageRemoteDB,
        StudyCardsLocalDB,
        StudyCardsRemoteDB,
        SyncStrategy,
        Deck,
        DeckListing,
        CardTemplate,
        StudyCard,
        FsrsCard,
        FsrsReviewLog,
        NewestWinsSyncStrategy,
        DeckListingsService,
        CardTemplatesService,
        StudyCardService,
        FsrsService,
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

  final StorageRemoteDB remoteStorage;

  List<SyncStrategy<dynamic>> getStrategies() {
    return <SyncStrategy<dynamic>>[
      NewestWinsSyncStrategy<Deck>(
        name: 'decks',
        localDb: decks,
        remoteDb: remoteDecks,
        localIndex: (_) async => decks.selectSyncIndexByUserIdAndOptionalDeckId(
          userId: userId,
          deckId: deckId,
        ),
        remoteIndex: (_) =>
            remoteDecks.selectSyncIndexByUserIdAndOptionalDeckId(
              userId: userId,
              deckId: deckId,
            ),
        localItemsByIds: (_, ids) async => decks.selectManyByIds(ids),
        remoteItemsByIds: (_, ids) => remoteDecks.selectManyByIds(ids),
        itemId: (deck) => deck.id,
        itemToChangeMap: remoteDecks.toMap,
      ),
      NewestWinsSyncStrategy<DeckListing>(
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
        itemToChangeMap: remoteDeckListings.toMap,
      ),
      NewestWinsSyncStrategy<CardTemplate>(
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
        itemToChangeMap: remoteCardTemplates.toMap,
      ),
      NewestWinsSyncStrategy<StudyCard>(
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
      NewestWinsSyncStrategy<FsrsCard>(
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
      AppendOnlySyncStrategy<FsrsReviewLog>(
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

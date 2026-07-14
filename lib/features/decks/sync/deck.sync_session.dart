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
        SyncMediaReference,
        SyncMediaReferenceApplier,
        FolderPaths,
        FolderPathStoredMediaPath,
        StoredMediaPath,
        StoredMediaService,
        ImageHelper,
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

  List<SyncStrategy<dynamic>> getStrategies() {
    return <SyncStrategy<dynamic>>[
      SyncDeletionService.createStrategy(this),
      NewestWinsSyncStrategy<Deck>(
        name: 'decks',
        localDb: decks,
        remoteDb: remoteDecks,
        localIndex: DecksService.loadLocalDeckSyncIndexForSyncSession,
        remoteIndex: DecksService.loadRemoteDeckSyncIndexForSyncSession,
        localItemsByIds: DecksService.loadLocalDecksByIdsForSyncSession,
        remoteItemsByIds: DecksService.loadRemoteDecksByIdsForSyncSession,
        itemId: (deck) => deck.id,
        preprocessPushItem: _preprocessDeckPushItem,
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
        preprocessPushItem: _preprocessDeckListingPushItem,
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

  Future<Deck> _preprocessDeckPushItem(Deck deck, DeckSyncSession session) {
    final localPath = FolderPaths.deckCoverImage(
      deck.title,
    ).toStoredMediaPath();

    return SyncMediaReferenceApplier.apply<Deck>(
      item: deck,
      persistItem: decks.upsert,
      references: [
        SyncMediaReference<Deck>(
          localPath: localPath,
          remotePath: _deckCoverRemotePath(deck),
          bucket: remoteStorage,
          readValue: (deck) => deck.coverImageUrl,
          shouldUpload: (_, currentValue) =>
              _shouldUploadStoredMedia(localPath, currentValue),
          writeValue: (deck, uploadedValue) =>
              deck.copyWith(coverImageUrl: uploadedValue),
        ),
      ],
    );
  }

  Future<DeckListing> _preprocessDeckListingPushItem(
    DeckListing listing,
    DeckSyncSession session,
  ) async {
    final deck = decks.selectByPk({'id': listing.deckId});
    if (deck == null) return listing;

    return SyncMediaReferenceApplier.apply<DeckListing>(
      item: listing,
      persistItem: deckListings.upsert,
      references: [
        for (var index = 0; index < listing.featuredImages.length; index++)
          _deckListingFeaturedImageReference(
            deck: deck,
            listing: listing,
            index: index,
          ),
      ],
    );
  }

  SyncMediaReference<DeckListing> _deckListingFeaturedImageReference({
    required Deck deck,
    required DeckListing listing,
    required int index,
  }) {
    final localPath = FolderPaths.deckListingFeaturedImage(
      deck.title,
      index,
    ).toStoredMediaPath();

    return SyncMediaReference<DeckListing>(
      localPath: localPath,
      remotePath: _deckListingFeaturedImageRemotePath(listing.deckId, index),
      bucket: remoteStorage,
      readValue: (listing) => listing.featuredImages[index],
      shouldUpload: (_, currentValue) =>
          _shouldUploadStoredMedia(localPath, currentValue),
      writeValue: (listing, uploadedValue) {
        final featuredImages = listing.featuredImages.toList();
        featuredImages[index] = uploadedValue;
        return listing.copyWith(featuredImages: featuredImages);
      },
    );
  }

  bool _shouldUploadStoredMedia(
    StoredMediaPath localPath,
    String? currentValue,
  ) {
    final storedMedia = StoredMediaService.getByPath(localPath);
    if (storedMedia == null) return false;

    final normalizedCurrentValue = currentValue?.trim();
    if (normalizedCurrentValue == null || normalizedCurrentValue.isEmpty) {
      return true;
    }
    if (!ImageHelper.isRemoteUrl(normalizedCurrentValue)) {
      return true;
    }

    return storedMedia.remoteUrl?.trim() != normalizedCurrentValue;
  }

  String _deckCoverRemotePath(Deck deck) {
    return 'users/$userId/decks/${deck.id}/cover';
  }

  String _deckListingFeaturedImageRemotePath(String deckId, int index) {
    return 'users/$userId/decks/$deckId/featured/image$index';
  }
}

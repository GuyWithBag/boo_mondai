import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        DeckListing,
        DeckSyncSession,
        ImageHelper,
        MediaRemotePathHelper,
        StoredMediaPath,
        StoredMediaPathHelper,
        StoredMediaService,
        SyncMediaReference,
        SyncMediaReferenceApplier;

abstract final class DeckListingMediaSyncPreprocessor {
  /// Uploads deck-listing local media before the listing row is pushed remotely.
  static Future<DeckListing> preprocessPushItem({
    required DeckListing listing,
    required DeckSyncSession session,
  }) async {
    final deck = session.decks.selectByPk({'id': listing.deckId});
    if (deck == null) return listing;

    return SyncMediaReferenceApplier.apply<DeckListing>(
      item: listing,
      persistItem: session.deckListings.upsert,
      references: [
        for (var index = 0; index < listing.featuredImages.length; index++)
          _featuredImageReference(
            deck: deck,
            listing: listing,
            index: index,
            session: session,
          ),
      ],
    );
  }

  static SyncMediaReference<DeckListing> _featuredImageReference({
    required Deck deck,
    required DeckListing listing,
    required int index,
    required DeckSyncSession session,
  }) {
    final localPath = StoredMediaPathHelper.deckListingFeaturedImage(
      deckTitle: deck.title,
      index: index,
    );

    return SyncMediaReference<DeckListing>(
      localPath: localPath,
      remotePath: MediaRemotePathHelper.deckListingFeaturedImage(
        profileId: session.userId,
        deckId: listing.deckId,
        index: index,
      ),
      bucket: session.remoteStorage,
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

  static bool _shouldUploadStoredMedia(
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
}

import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        DeckListing,
        ImageHelper,
        LocalDB,
        RemoteDB,
        MediaRemotePathHelper,
        DecksDirectoryPaths,
        SyncMediaReference,
        SyncMediaReferenceApplier,
        MediaHelper;

abstract final class DeckListingMediaSyncPreprocessor {
  /// Uploads deck-listing local media before the listing row is pushed remotely.
  static Future<DeckListing> preprocessPushItem({
    required DeckListing listing,
    required String profileId,
  }) async {
    final deck = LocalDB.deck.selectByPk({'id': listing.deckId});
    if (deck == null) return listing;

    return SyncMediaReferenceApplier.apply<DeckListing>(
      item: listing,
      persistItem: LocalDB.deckListing.upsert,
      references: [
        for (var index = 0; index < listing.featuredImages.length; index++)
          _featuredImageReference(
            deck: deck,
            listing: listing,
            index: index,
            profileId: profileId,
          ),
      ],
    );
  }

  static SyncMediaReference<DeckListing> _featuredImageReference({
    required Deck deck,
    required DeckListing listing,
    required int index,
    required String profileId,
  }) {
    final localPath = DecksDirectoryPaths.listingFeaturedImage(
      deckTitle: deck.title,
      index: index,
    );

    return SyncMediaReference<DeckListing>(
      localPath: localPath,
      remotePath: MediaRemotePathHelper.deckListingFeaturedImage(
        profileId: profileId,
        deckId: listing.deckId,
        index: index,
      ),
      bucket: RemoteDB.publicBucket,
      readValue: (listing) => listing.featuredImages[index],
      shouldUpload: (_, currentValue) =>
          _shouldUploadLocalMedia(localPath, currentValue),
      writeValue: (listing, uploadedValue) {
        final featuredImages = listing.featuredImages.toList();
        featuredImages[index] = uploadedValue;
        return listing.copyWith(featuredImages: featuredImages);
      },
    );
  }

  static bool _shouldUploadLocalMedia(String localPath, String? currentValue) {
    final normalizedCurrentValue = currentValue?.trim();
    if (normalizedCurrentValue == null || normalizedCurrentValue.isEmpty) {
      return true;
    }
    if (!MediaHelper.isRemoteUrl(normalizedCurrentValue)) {
      return true;
    }

    return false;
  }
}

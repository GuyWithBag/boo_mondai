import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        ImageHelper,
        LocalDB,
        RemoteDB,
        MediaRemotePathHelper,
        StoredMediaPath,
        StoredMediaPathHelper,
        StoredMediaService,
        SyncMarkdownMediaApplier,
        SyncMediaReference,
        SyncMediaReferenceApplier;

abstract final class DeckMediaSyncPreprocessor {
  /// Uploads deck-owned local media before the deck row is pushed remotely.
  static Future<Deck> preprocessPushItem({
    required Deck deck,
    required String profileId,
  }) async {
    final localPath = StoredMediaPathHelper.deckCoverImage(
      deckTitle: deck.title,
    );

    var updated = await SyncMediaReferenceApplier.apply<Deck>(
      item: deck,
      persistItem: LocalDB.deck.upsert,
      references: [
        SyncMediaReference<Deck>(
          localPath: localPath,
          remotePath: MediaRemotePathHelper.deckCoverImage(
            profileId: profileId,
            deckId: deck.id,
          ),
          bucket: RemoteDB.publicBucket,
          readValue: (deck) => deck.coverImageUrl,
          shouldUpload: (_, currentValue) =>
              _shouldUploadStoredMedia(localPath, currentValue),
          writeValue: (deck, uploadedValue) =>
              deck.copyWith(coverImageUrl: uploadedValue),
        ),
      ],
    );

    final longDescription = await SyncMarkdownMediaApplier.uploadAndRewrite(
      markdown: updated.longDescription,
      bucket: RemoteDB.publicBucket,
      remotePath: (storedMedia, index) =>
          MediaRemotePathHelper.deckMarkdownAttachment(
            profileId: profileId,
            deckId: updated.id,
            fileName: MediaRemotePathHelper.fileNameFromStoredMedia(
              storedMedia,
              index,
            ),
          ),
    );

    if (longDescription != updated.longDescription) {
      updated = updated.copyWith(longDescription: longDescription);
      await LocalDB.deck.upsert(updated);
    }

    return updated;
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

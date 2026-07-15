import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        DeckSyncSession,
        ImageHelper,
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
    required DeckSyncSession session,
  }) async {
    final localPath = StoredMediaPathHelper.deckCoverImage(
      deckTitle: deck.title,
    );

    var updated = await SyncMediaReferenceApplier.apply<Deck>(
      item: deck,
      persistItem: session.decks.upsert,
      references: [
        SyncMediaReference<Deck>(
          localPath: localPath,
          remotePath: MediaRemotePathHelper.deckCoverImage(
            profileId: session.userId,
            deckId: deck.id,
          ),
          bucket: session.remoteStorage,
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
      bucket: session.remoteStorage,
      remotePath: (storedMedia, index) =>
          MediaRemotePathHelper.deckMarkdownAttachment(
            profileId: session.userId,
            deckId: updated.id,
            fileName: MediaRemotePathHelper.fileNameFromStoredMedia(
              storedMedia,
              index,
            ),
          ),
    );

    if (longDescription != updated.longDescription) {
      updated = updated.copyWith(longDescription: longDescription);
      await session.decks.upsert(updated);
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

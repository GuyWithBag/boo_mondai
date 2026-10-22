import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        LocalDB,
        RemoteDB,
        MediaRemotePathHelper,
        DecksDirectoryPaths,
        SyncMarkdownMediaApplier,
        SyncMediaReference,
        SyncMediaReferenceApplier,
        MediaHelper;

abstract final class DeckMediaSyncPreprocessor {
  /// Uploads deck-owned local media before the deck row is pushed remotely.
  static Future<Deck> preprocessPushItem({
    required Deck deck,
    required String profileId,
  }) async {
    final localPath = DecksDirectoryPaths.coverImage(deckTitle: deck.title);

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
              _shouldUploadLocalMedia(localPath, currentValue),
          writeValue: (deck, uploadedValue) =>
              deck.copyWith(coverImageUrl: uploadedValue),
        ),
      ],
    );

    final longDescription = await SyncMarkdownMediaApplier.uploadAndRewrite(
      markdown: updated.longDescription,
      bucket: RemoteDB.publicBucket,
      remotePath: (localPath, index) =>
          MediaRemotePathHelper.deckMarkdownAttachment(
            profileId: profileId,
            deckId: updated.id,
            fileName: MediaRemotePathHelper.fileNameFromLocalPath(
              localPath,
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

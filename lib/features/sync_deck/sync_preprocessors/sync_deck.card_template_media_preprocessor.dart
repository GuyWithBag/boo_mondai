import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        CardTemplateMediaFieldsHelper,
        DeckSyncSession,
        MediaRemotePathHelper,
        SyncMarkdownMediaApplier;

abstract final class CardTemplateMediaSyncPreprocessor {
  /// Uploads card-template local media before the template row is pushed remotely.
  static Future<CardTemplate> preprocessPushItem({
    required CardTemplate template,
    required DeckSyncSession session,
  }) async {
    var updated = template;

    for (final field in CardTemplateMediaFieldsHelper.markdownFields(
      template,
    )) {
      final markdown = await SyncMarkdownMediaApplier.uploadAndRewrite(
        markdown: field.getValue(updated),
        bucket: session.remoteStorage,
        remotePath: (storedMedia, index) =>
            MediaRemotePathHelper.cardMarkdownAttachment(
              profileId: session.userId,
              deckId: updated.deckId,
              templateId: updated.id,
              field: field.name,
              fileName: MediaRemotePathHelper.fileNameFromStoredMedia(
                storedMedia,
                index,
              ),
            ),
      );
      updated = field.setValue(updated, markdown);
    }

    if (updated != template) {
      await session.cardTemplates.upsert(updated);
    }

    return updated;
  }
}

import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        MarkdownMediaFieldsHelper,
        LocalDB,
        MediaRemotePathHelper,
        RemoteDB,
        SyncMarkdownMediaApplier;

abstract final class CardTemplateMediaSyncPreprocessor {
  /// Uploads card-template local media before the template row is pushed remotely.
  static Future<CardTemplate> preprocessPushItem({
    required CardTemplate template,
    required String profileId,
  }) async {
    var updated = template;

    for (final field in MarkdownMediaFieldsHelper.markdownFields(template)) {
      final markdown = await SyncMarkdownMediaApplier.uploadAndRewrite(
        markdown: field.getValue(updated),
        bucket: RemoteDB.publicBucket,
        remotePath: (localPath, index) =>
            MediaRemotePathHelper.cardMarkdownAttachment(
              profileId: profileId,
              deckId: updated.deckId,
              templateId: updated.id,
              field: field.name,
              fileName: MediaRemotePathHelper.fileNameFromLocalPath(
                localPath,
                index,
              ),
            ),
      );
      updated = field.setValue(updated, markdown);
    }

    if (updated != template) {
      await LocalDB.cardTemplate.upsert(updated);
    }

    return updated;
  }
}

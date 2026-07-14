import 'dart:io';

import 'package:boo_mondai/lib.barrel.dart'
    show
        ImageHelper,
        LocalDB,
        StoredMedia,
        StoredMediaService,
        SyncMediaReference;

abstract final class SyncMediaReferenceApplier {
  static Future<T> apply<T>({
    required T item,
    required Iterable<SyncMediaReference<T>> references,
    Future<void> Function(T item)? persistItem,
  }) async {
    var updated = item;
    var changed = false;

    for (final reference in references) {
      final currentValue = reference.readValue(updated);
      final shouldUpload =
          reference.shouldUpload?.call(updated, currentValue) ??
          _shouldUploadMediaReference(currentValue);
      if (!shouldUpload) continue;

      final storedMedia = StoredMediaService.getByPath(reference.localPath);
      if (storedMedia == null) continue;

      final file = File(storedMedia.localPath);
      if (!await file.exists()) continue;

      final uploadedValue = await reference.bucket.uploadBytes(
        reference.remotePath,
        await file.readAsBytes(),
        contentType: storedMedia.mimeType,
        upsert: reference.upsert,
      );

      updated = reference.writeValue(updated, uploadedValue);
      await _updateStoredMediaRemoteUrl(storedMedia, uploadedValue);
      changed = true;
    }

    if (changed) {
      await persistItem?.call(updated);
    }

    return updated;
  }

  static bool _shouldUploadMediaReference(String? currentValue) {
    final value = currentValue?.trim();
    return value == null || value.isEmpty || !ImageHelper.isRemoteUrl(value);
  }

  static Future<void> _updateStoredMediaRemoteUrl(
    StoredMedia storedMedia,
    String remoteUrl,
  ) {
    return LocalDB.storedMedia.upsert(
      StoredMedia(
        id: storedMedia.id,
        localPath: storedMedia.localPath,
        remoteUrl: remoteUrl,
        mimeType: storedMedia.mimeType,
        byteSize: storedMedia.byteSize,
        createdAt: storedMedia.createdAt,
        updatedAt: DateTime.now(),
      ),
    );
  }
}

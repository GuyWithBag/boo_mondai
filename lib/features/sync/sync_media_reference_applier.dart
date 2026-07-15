import 'package:boo_mondai/lib.barrel.dart'
    show
        ImageHelper,
        StoredMediaService,
        StoredMediaUploadService,
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

      final uploadedValue = await StoredMediaUploadService.upload(
        storedMedia: storedMedia,
        bucket: reference.bucket,
        remotePath: reference.remotePath,
        upsert: reference.upsert,
      );
      if (uploadedValue == null) continue;

      updated = reference.writeValue(updated, uploadedValue);
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
}

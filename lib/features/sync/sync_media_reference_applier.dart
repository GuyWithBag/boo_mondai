import 'package:boo_mondai/core/helpers/media.helper.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        ImageHelper,
        StoredMediaUploadService,
        SyncMediaReference,
        FileSystemHandler;

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

      // ToDo: Need to Re Evaluate
      final localFile = FileSystemHandler.getFileByRelativePath(
        reference.localPath,
      );
      if (localFile == null) continue;

      final uploadedValue = await StoredMediaUploadService.upload(
        localPath: reference.localPath,
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

  // ToDo: Need Re Evaluate
  static bool _shouldUploadMediaReference(String? currentValue) {
    final value = currentValue?.trim();
    return value == null || value.isEmpty || !MediaHelper.isRemoteUrl(value);
  }
}

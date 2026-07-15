import 'dart:io';

import 'package:boo_mondai/lib.barrel.dart'
    show BucketSupabaseRemoteDB, StoredMedia, StoredMediaService;

abstract final class StoredMediaUploadService {
  /// Uploads a local stored-media file and records the returned remote value.
  static Future<String?> upload({
    required StoredMedia storedMedia,
    required BucketSupabaseRemoteDB bucket,
    required String remotePath,
    bool upsert = true,
  }) async {
    final file = File(storedMedia.localPath);
    if (!await file.exists()) return null;

    final uploadedValue = await bucket.uploadBytes(
      remotePath,
      await file.readAsBytes(),
      contentType: storedMedia.mimeType,
      upsert: upsert,
    );

    await StoredMediaService.markUploaded(storedMedia, uploadedValue);
    return uploadedValue;
  }
}

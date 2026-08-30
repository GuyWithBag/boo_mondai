import 'dart:io';

import 'package:boo_mondai/lib.barrel.dart'
    show BucketSupabaseRemoteDB, FileHelper, MediaHelper;

abstract final class StoredMediaUploadService {
  /// Uploads a local stored-media file and returns the remote value.
  static Future<String?> upload({
    required String localPath,
    required BucketSupabaseRemoteDB bucket,
    required String remotePath,
    bool upsert = true,
  }) async {
    final file = File(localPath);
    if (!await file.exists()) return null;

    return bucket.uploadBytes(
      remotePath,
      await file.readAsBytes(),
      contentType: MediaHelper.mimeTypeFromExtension(
        FileHelper.getExtension(file.path),
      ),
      upsert: upsert,
    );
  }
}

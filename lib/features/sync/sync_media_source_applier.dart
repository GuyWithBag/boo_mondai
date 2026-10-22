import 'package:boo_mondai/lib.barrel.dart'
    show BucketSupabaseRemoteDB, StoredMediaUploadService, MediaHelper;

typedef SyncMediaSourceRemotePathBuilder = String Function(String localPath);

abstract final class SyncMediaSourceApplier {
  // ToDo: Re Evaluate
  static Future<String?> uploadSource({
    required String? source,
    required BucketSupabaseRemoteDB bucket,
    required SyncMediaSourceRemotePathBuilder remotePath,
    bool upsert = true,
  }) async {
    final localPath = _localPathFromSource(source);
    if (localPath == null) return source;

    final currentSource = source?.trim();
    if (currentSource != null && MediaHelper.isRemoteUrl(currentSource)) {
      return source;
    }

    final uploadedValue = await StoredMediaUploadService.upload(
      localPath: localPath,
      bucket: bucket,
      remotePath: remotePath(localPath),
      upsert: upsert,
    );
    if (uploadedValue == null) return source;

    return uploadedValue;
  }

  static String? _localPathFromSource(String? source) {
    final value = source?.trim();
    if (value == null || value.isEmpty) return null;

    final uri = Uri.tryParse(value);
    if (uri?.scheme == 'local') {
      final localPath = uri!.path.isNotEmpty ? uri.path : uri.host;
      return localPath.trim().isEmpty ? null : localPath;
    }

    return null;
  }
}

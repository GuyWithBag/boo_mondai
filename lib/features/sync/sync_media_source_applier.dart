import 'package:boo_mondai/lib.barrel.dart'
    show
        BucketSupabaseRemoteDB,
        ImageHelper,
        StoredMedia,
        StoredMediaService,
        StoredMediaUploadService;

typedef SyncMediaSourceRemotePathBuilder =
    String Function(StoredMedia storedMedia);

abstract final class SyncMediaSourceApplier {
  static Future<String?> uploadSource({
    required String? source,
    required BucketSupabaseRemoteDB bucket,
    required SyncMediaSourceRemotePathBuilder remotePath,
    bool upsert = true,
  }) async {
    final storedMedia = _storedMediaFromSource(source);
    if (storedMedia == null) return source;

    final currentSource = source?.trim();
    if (currentSource != null &&
        ImageHelper.isRemoteUrl(currentSource) &&
        storedMedia.remoteUrl?.trim() == currentSource) {
      return source;
    }

    final uploadedValue = await StoredMediaUploadService.upload(
      storedMedia: storedMedia,
      bucket: bucket,
      remotePath: remotePath(storedMedia),
      upsert: upsert,
    );
    if (uploadedValue == null) return source;

    return uploadedValue;
  }

  static StoredMedia? _storedMediaFromSource(String? source) {
    final value = source?.trim();
    if (value == null || value.isEmpty) return null;

    final uri = Uri.tryParse(value);
    if (uri?.scheme == 'local') {
      final id = uri!.path.isNotEmpty ? uri.path : uri.host;
      if (id.trim().isEmpty) return null;
      return StoredMediaService.getById(id);
    }

    if (ImageHelper.isRemoteUrl(value)) {
      return StoredMediaService.getByRemoteUrl(value);
    }

    return null;
  }
}

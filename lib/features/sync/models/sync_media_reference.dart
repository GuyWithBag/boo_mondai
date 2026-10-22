import 'package:boo_mondai/lib.barrel.dart' show BucketSupabaseRemoteDB;

typedef SyncMediaUploadPredicate<T> =
    bool Function(T item, String? currentValue);

class SyncMediaReference<T> {
  const SyncMediaReference({
    required this.localPath,
    required this.remotePath,
    required this.bucket,
    required this.readValue,
    required this.writeValue,
    this.shouldUpload,
    this.upsert = true,
  });

  final String localPath;
  final String remotePath;
  final BucketSupabaseRemoteDB bucket;
  final String? Function(T item) readValue;
  final T Function(T item, String uploadedValue) writeValue;
  final SyncMediaUploadPredicate<T>? shouldUpload;
  final bool upsert;
}

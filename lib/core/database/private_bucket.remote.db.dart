// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/database/private_bucket.remote.db.dart
// PURPOSE: Private Supabase Storage bucket repository
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/core/database/bucket_supabase.remote.db.dart';
import 'package:boo_mondai/env.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show SignedUrlResult;

class PrivateBucketRemoteDB extends BucketSupabaseRemoteDB {
  @override
  String get bucketName => Env.privateMediaBucket;

  @override
  bool get isPublic => false;

  Future<String> createSignedUrl(String path, {int expiresInSeconds = 3600}) =>
      guard(() {
        return client.storage
            .from(bucketName)
            .createSignedUrl(path, expiresInSeconds);
      }, action: 'createSignedUrl($path)');

  Future<List<SignedUrlResult>> createSignedUrls(
    List<String> paths, {
    int expiresInSeconds = 3600,
  }) => guard(() {
    return client.storage
        .from(bucketName)
        .createSignedUrlsResult(paths, expiresInSeconds);
  }, action: 'createSignedUrls(${paths.length} files)');

  /// Uploads private media and returns the storage path.
  ///
  /// Private buckets should store paths in Postgres and generate signed URLs
  /// only when displaying/downloading the media.
  @override
  Future<String> uploadBytes(
    String path,
    Uint8List bytes, {
    String? contentType,
    bool upsert = false,
  }) => uploadBytesToBucket(
    path,
    bytes,
    contentType: contentType,
    upsert: upsert,
  );

  @override
  Future<String> uploadImage(
    String path,
    Uint8List bytes, {
    String? contentType,
    bool upsert = false,
  }) => uploadBytes(path, bytes, contentType: contentType, upsert: upsert);
}

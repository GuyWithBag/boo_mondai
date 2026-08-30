// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/database/private_bucket.remote.db.dart
// PURPOSE: Private Supabase Storage bucket repository
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show Env, BucketSupabaseRemoteDB;
import 'package:supabase_flutter/supabase_flutter.dart' show SignedUrlResult;

class PrivateBucketRemoteDB extends BucketSupabaseRemoteDB {
  @override
  String get name => Env.privateMediaBucket;

  @override
  bool get isPublic => false;

  Future<String> createSignedUrl(String path, {int expiresInSeconds = 3600}) =>
      guard(() {
        return client.storage
            .from(name)
            .createSignedUrl(path, expiresInSeconds);
      }, action: 'createSignedUrl($path)');

  Future<List<SignedUrlResult>> createSignedUrls(
    List<String> paths, {
    int expiresInSeconds = 3600,
  }) => guard(() {
    return client.storage
        .from(name)
        .createSignedUrlsResult(paths, expiresInSeconds);
  }, action: 'createSignedUrls(${paths.length} files)');
}

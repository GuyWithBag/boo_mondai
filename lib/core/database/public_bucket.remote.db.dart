// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/database/public_bucket.remote.db.dart
// PURPOSE: Public Supabase Storage bucket repository
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/core/database/bucket_supabase.remote.db.dart';
import 'package:boo_mondai/env.dart';
import 'package:flutter/foundation.dart';

class PublicBucketRemoteDB extends BucketSupabaseRemoteDB {
  @override
  String get bucketName => Env.publicMediaBucket;

  @override
  bool get isPublic => true;

  String getPublicUrl(String path) {
    return client.storage.from(bucketName).getPublicUrl(path);
  }

  @override
  Future<String> uploadBytes(
    String path,
    Uint8List bytes, {
    String? contentType,
    bool upsert = false,
  }) async {
    final uploadedPath = await uploadBytesToBucket(
      path,
      bytes,
      contentType: contentType,
      upsert: upsert,
    );
    return getPublicUrl(uploadedPath);
  }

  @override
  Future<String> uploadImage(
    String path,
    Uint8List bytes, {
    String? contentType,
    bool upsert = false,
  }) => uploadBytes(path, bytes, contentType: contentType, upsert: upsert);
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/database/public_bucket.remote.db.dart
// PURPOSE: Public Supabase Storage bucket repository
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/core/database/bucket_supabase.remote.db.dart';
import 'package:boo_mondai/env.dart';

class PublicBucketRemoteDB extends BucketSupabaseRemoteDB {
  @override
  String get name => Env.publicMediaBucket;

  @override
  bool get isPublic => true;
}

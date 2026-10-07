// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/shared/env.dart
// PURPOSE: Environment configuration — Supabase credentials, storage buckets, flags
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

abstract final class Env {
  // Replace with your Supabase project credentials
  static const supabaseUrl = 'https://rjaxxdzawkbovzovskhw.supabase.co';

  static const supabaseAnonKey =
      'sb_publishable_brxiBtAxKLStsdvRy0cWww_LgOA7nWt';

  static const publicMediaBucket = 'public-media';
  static const privateMediaBucket = 'private-media';
}

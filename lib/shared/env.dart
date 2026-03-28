// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/shared/env.dart
// PURPOSE: Environment configuration — Supabase credentials, storage buckets, flags
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

abstract final class Env {
  // Replace with your Supabase project credentials
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://fbrawcadldjwucbzxvpn.supabase.co',
  );

  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_ADMfC3ar7NRU6D0ywZuhQQ_lnTSLK1N',
  );

  static const storageBucket = 'card-images';
}

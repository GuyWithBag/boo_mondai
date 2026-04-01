// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_auth_service.dart
// PURPOSE: Supabase authentication and profile operations
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class SupabaseAuthService extends SupabaseService {
  Future<AuthResponse> signIn(String email, String password) => guard(
    () => client.auth.signInWithPassword(email: email, password: password),
  );

  // TODO: Create User Profile here to work with AuthProvider
  Future<AuthResponse> signUp(String email, String password) => guard(() {
    return client.auth.signUp(email: email, password: password);
  });

  Future<void> signOut() => guard(() => client.auth.signOut());

  Session? get currentSession => client.auth.currentSession;
  User? get currentUser => client.auth.currentUser;

  // ── Profiles ──────────────────────────────────────────

  Future<Map<String, dynamic>?> getProfile(String userId) => guard(
    () => client.from('profiles').select().eq('id', userId).maybeSingle(),
  );

  Future<void> upsertProfile(Map<String, dynamic> data) =>
      guard(() => client.from('profiles').upsert(data));
}

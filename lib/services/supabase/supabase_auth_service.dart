// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_auth_service.dart
// PURPOSE: Supabase authentication and profile operations
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/repositories/repositories.barrel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class SupabaseAuthService extends SupabaseService {
  // ── Auth ──────────────────────────────────────────────

  Future<AuthResponse> signIn(String email, String password) => guard(
    () => client.auth.signInWithPassword(email: email, password: password),
  );

  Future<AuthResponse> signUp(
    String email,
    String password,
    UserProfile profile,
  ) => guard(() async {
    final res = await client.auth.signUp(email: email, password: password);
    final newProfile = profile.copyWith(userId: res.user!.id);
    Repositories.userProfile.save(newProfile);
    return res;
  });

  Future<void> signOut() => guard(() => client.auth.signOut());

  Session? get currentSession => client.auth.currentSession;
  User? get currentUser => client.auth.currentUser;

  // ── Profiles ──────────────────────────────────────────

  Future<Map<String, dynamic>?> getProfile(String userId) =>
      fetchById('profiles', userId);

  Future<void> upsertProfile(Map<String, dynamic> data) =>
      upsertRow('profiles', data);
}

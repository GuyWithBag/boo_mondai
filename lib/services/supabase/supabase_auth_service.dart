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
  Future<AuthResponse> signIn(String email, String password) => guard(() async {
    final res = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return res;
  });

  // TODO: Create User Profile here to work with AuthProvider
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

  Future<void> signOut() => guard(() async {
    await client.auth.signOut();
    Repositories.userProfile.clear();
  });

  Session? get currentSession => client.auth.currentSession;
  User? get currentUser => client.auth.currentUser;

  // ── Profiles ──────────────────────────────────────────

  Future<Map<String, dynamic>?> getProfile(String userId) => guard(
    () => client.from('profiles').select().eq('id', userId).maybeSingle(),
  );

  Future<void> upsertProfile(Map<String, dynamic> data) =>
      guard(() => client.from('profiles').upsert(data));
}

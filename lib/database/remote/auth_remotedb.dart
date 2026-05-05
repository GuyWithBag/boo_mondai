// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_auth_service.dart
// PURPOSE: Supabase authentication and profile operations
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDB extends SupabaseRemoteDB<UserProfile> {
  @override
  String get tableName => 'profiles';

  @override
  UserProfile Function(Map<String, dynamic>) get fromMap =>
      UserProfileMapper.fromMap;

  @override
  Map<String, dynamic> toMap(UserProfile item) => item.toMap();

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
    LocalDB.userProfile.put(newProfile);
    return res;
  });

  Future<void> signOut() => guard(() => client.auth.signOut());

  Session? get currentSession => client.auth.currentSession;
  User? get currentUser => client.auth.currentUser;
}

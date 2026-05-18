// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_auth_service.dart
// PURPOSE: Supabase authentication and profile operations
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';

class ProfilesRemoteDB extends SupabaseRemoteDB<Profile> {
  @override
  String get tableName => 'profiles';

  @override
  Profile Function(Map<String, dynamic>) get fromMap => ProfileMapper.fromMap;

  @override
  Map<String, dynamic> toMap(Profile item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(Profile item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';

  Future<Profile?> selectByAuthUserId(String authUserId) =>
      selectOne(filters: {'user_id': authUserId});
}

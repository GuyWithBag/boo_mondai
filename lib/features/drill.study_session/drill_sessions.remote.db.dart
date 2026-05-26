// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_drill_service.dart
// PURPOSE: Supabase operations for drill sessions and answers
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show SupabaseRemoteDB, DrillSession, DrillSessionMapper;

class DrillSessionsRemoteDB extends SupabaseRemoteDB<DrillSession> {
  @override
  String get tableName => 'drill_sessions';

  @override
  DrillSession Function(Map<String, dynamic>) get fromMap =>
      DrillSessionMapper.fromMap;

  /// Strips the dart_mappable discriminator key before writing to the DB.
  @override
  Map<String, dynamic> toMap(DrillSession item) =>
      item.toMap()..remove('session_type');

  @override
  Map<String, Object?> primaryKeyFromItem(DrillSession item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';

  @override
  String get defaultSelect => _drillSessionWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {'deck', 'userProfile', 'user_profile'};
}

const _drillSessionWithRelationsSelect =
    '*, deck:decks(*), user_profile:profiles!drill_sessions_user_id_fkey(id, username, avatar_url, created_at)';

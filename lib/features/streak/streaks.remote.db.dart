// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_streak_service.dart
// PURPOSE: Supabase sync for user streaks
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show SupabaseRemoteDB, Streak, StreakMapper;

class StreaksRemoteDB extends SupabaseRemoteDB<Streak> {
  @override
  String get tableName => 'streaks';

  @override
  Streak Function(Map<String, dynamic>) get fromMap => StreakMapper.fromMap;

  @override
  Map<String, dynamic> toMap(Streak item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(Streak item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';

  @override
  bool get supportsSoftDelete => true;
}

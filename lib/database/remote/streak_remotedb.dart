// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_streak_service.dart
// PURPOSE: Supabase sync for user streaks
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';

class StreakRemoteDB extends SupabaseRemoteDB<Streak> {
  @override
  String get tableName => 'streaks';

  @override
  Streak Function(Map<String, dynamic>) get fromMap => StreakMapper.fromMap;

  @override
  Map<String, dynamic> toMap(Streak item) => item.toMap();
}

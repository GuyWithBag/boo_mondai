// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_drill_service.dart
// PURPOSE: Supabase operations for drill sessions and answers
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'supabase_service.dart';

class SupabaseDrillService extends SupabaseService {
  Future<Map<String, dynamic>> insertDrillSession(Map<String, dynamic> data) =>
      insertOne('drill_sessions', data);

  Future<void> updateDrillSession(String id, Map<String, dynamic> data) =>
      updateById('drill_sessions', id, data);

  Future<void> insertDrillAnswer(Map<String, dynamic> data) =>
      insertRow('drill_answers', data);

  Future<void> batchInsertDrillAnswers(List<Map<String, dynamic>> answers) =>
      insertMany('drill_answers', answers);
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_drill_service.dart
// PURPOSE: Supabase operations for drill sessions and answers
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'supabase_service.dart';

class SupabaseDrillService extends SupabaseService {
  Future<Map<String, dynamic>> insertDrillSession(Map<String, dynamic> data) =>
      guard(() => client.from('drill_sessions').insert(data).select().single());

  Future<void> updateDrillSession(String id, Map<String, dynamic> data) =>
      guard(() => client.from('drill_sessions').update(data).eq('id', id));

  Future<void> insertDrillAnswer(Map<String, dynamic> data) =>
      guard(() => client.from('drill_answers').insert(data));

  Future<void> batchInsertDrillAnswers(List<Map<String, dynamic>> answers) {
    if (answers.isEmpty) return Future.value();
    return guard(() => client.from('drill_answers').insert(answers));
  }
}

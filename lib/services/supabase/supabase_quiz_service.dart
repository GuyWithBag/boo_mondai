// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_quiz_service.dart
// PURPOSE: Supabase operations for quiz sessions and answers
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'supabase_service.dart';

class SupabaseQuizService extends SupabaseService {
  Future<Map<String, dynamic>> insertQuizSession(
          Map<String, dynamic> data) =>
      guard(() => client.from('quiz_sessions').insert(data).select().single());

  Future<void> updateQuizSession(String id, Map<String, dynamic> data) =>
      guard(() => client.from('quiz_sessions').update(data).eq('id', id));

  Future<void> insertQuizAnswer(Map<String, dynamic> data) =>
      guard(() => client.from('quiz_answers').insert(data));

  Future<void> batchInsertQuizAnswers(
          List<Map<String, dynamic>> answers) {
    if (answers.isEmpty) return Future.value();
    return guard(() => client.from('quiz_answers').insert(answers));
  }
}

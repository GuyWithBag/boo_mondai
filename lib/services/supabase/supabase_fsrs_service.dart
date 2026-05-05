// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_fsrs_service.dart
// PURPOSE: Supabase sync for FSRS card states and review logs
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'supabase_service.dart';

class SupabaseFsrsService extends SupabaseService {
  Future<void> upsertFsrsCard(Map<String, dynamic> data) =>
      upsertRow('fsrs_cards', data);

  Future<void> insertReviewLog(Map<String, dynamic> data) =>
      insertRow('review_logs', data);
}

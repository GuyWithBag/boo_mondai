// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/review_sessions.remote.db.dart
// PURPOSE: Supabase CRUD for review sessions
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';

class ReviewSessionsRemoteDB extends SupabaseRemoteDB<ReviewSession> {
  @override
  String get tableName => 'review_sessions';

  @override
  ReviewSession Function(Map<String, dynamic>) get fromMap =>
      ReviewSessionMapper.fromMap;

  @override
  Map<String, dynamic> toMap(ReviewSession item) =>
      item.toMap()..remove('session_type');

  @override
  Map<String, Object?> primaryKeyFromItem(ReviewSession item) => {
    'id': item.id,
  };

  @override
  String get upsertConflictTarget => 'id';

  @override
  String get defaultSelect => _reviewSessionWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {'deck', 'userProfile', 'user_profile'};
}

const _reviewSessionWithRelationsSelect =
    '*, deck:decks(*), user_profile:profiles!review_sessions_user_id_fkey(id, username, avatar_url, created_at)';

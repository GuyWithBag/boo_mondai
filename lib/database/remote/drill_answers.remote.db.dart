// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/drill_answers.remote.db.dart
// PURPOSE: Supabase CRUD for drill answers
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';

class DrillAnswersRemoteDB extends SupabaseRemoteDB<DrillAnswer> {
  @override
  String get tableName => 'drill_answers';

  @override
  DrillAnswer Function(Map<String, dynamic>) get fromMap =>
      DrillAnswerMapper.fromMap;

  @override
  Map<String, dynamic> toMap(DrillAnswer item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(DrillAnswer item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';

  @override
  String get defaultSelect => _drillAnswerWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {
    'session',
    'cardTemplate',
    'card_template',
  };
}

const _drillAnswerWithRelationsSelect =
    '*, session:drill_sessions(*, deck:decks(*), user_profile:profiles(id, username, avatar_url, created_at)), card_template:card_templates(*, tags(*), options:multiple_choice_options(*), segments:fill_in_the_blank_segments(*), pairs:match_madness_pairs(*))';

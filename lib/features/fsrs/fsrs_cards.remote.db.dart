// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_fsrs_service.dart
// PURPOSE: Supabase sync for FSRS card states and review logs
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show SupabaseRemoteDB, FsrsCard, FsrsCardMapper;

class FsrsCardsRemoteDB extends SupabaseRemoteDB<FsrsCard> {
  @override
  String get tableName => 'fsrs_cards';

  @override
  FsrsCard Function(Map<String, dynamic>) get fromMap => FsrsCardMapper.fromMap;

  @override
  Map<String, dynamic> toMap(FsrsCard item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(FsrsCard item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';

  @override
  String get defaultSelect => _fsrsCardWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {'studyCard', 'study_cards'};
}

const _fsrsCardWithRelationsSelect =
    '*, study_cards:study_cards(*, deck:decks(*), template:card_templates(*, tags(*), options:multiple_choice_options(*), segments:fill_in_the_blank_segments(*), pairs:match_madness_pairs(*), attachments:card_template_attachments(*)), personal_tags:tags(*))';

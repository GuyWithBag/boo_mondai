// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_card_service.dart
// PURPOSE: Supabase CRUD for deck cards and their content nodes
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show SupabaseRemoteDB, StudyCard, StudyCardMapper;

class StudyCardsRemoteDB extends SupabaseRemoteDB<StudyCard> {
  @override
  String get tableName => 'study_cards';

  @override
  StudyCard Function(Map<String, dynamic>) get fromMap =>
      StudyCardMapper.fromMap;

  @override
  Map<String, dynamic> toMap(StudyCard item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(StudyCard item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';

  @override
  String get defaultSelect => _studyCardWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {
    'template',
    'deck',
    'personalTags',
    'personal_tags',
  };
}

const _studyCardWithRelationsSelect =
    '*, deck:decks(*), template:card_templates(*, tags(*), options:multiple_choice_options(*), segments:fill_in_the_blank_segments(*), pairs:match_madness_pairs(*), attachments:card_template_attachments(*)), personal_tags:tags(*)';

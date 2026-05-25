// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_card_service.dart
// PURPOSE: Supabase CRUD for deck cards and their content nodes
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';

import 'package:boo_mondai/database/database.barrel.dart';

class ReviewCardsRemoteDB extends SupabaseRemoteDB<ReviewCard> {
  @override
  String get tableName => 'review_cards';

  @override
  ReviewCard Function(Map<String, dynamic>) get fromMap =>
      ReviewCardMapper.fromMap;

  @override
  Map<String, dynamic> toMap(ReviewCard item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(ReviewCard item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';

  @override
  String get defaultSelect => _reviewCardWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {
    'template',
    'deck',
    'personalTags',
    'personal_tags',
  };
}

const _reviewCardWithRelationsSelect =
    '*, deck:decks(*), template:card_templates(*, tags(*), options:multiple_choice_options(*), segments:fill_in_the_blank_segments(*), pairs:match_madness_pairs(*)), personal_tags:tags(*)';

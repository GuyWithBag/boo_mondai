// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_fsrs_service.dart
// PURPOSE: Supabase sync for FSRS card states and review logs
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show SupabaseRemoteDB, FsrsCard, FsrsCardMapper, SyncIndexEntry;

class FsrsCardsRemoteDB extends SupabaseRemoteDB<FsrsCard> {
  @override
  String get tableName => 'fsrs_cards';

  @override
  FsrsCard Function(Map<String, dynamic>) get fromMap => _fsrsCardFromMap;

  @override
  Map<String, dynamic> toMap(FsrsCard item) {
    final map = item.toMap();
    map['study_cards_id'] = map.remove('study_card_id');
    return map;
  }

  @override
  Map<String, Object?> primaryKeyFromItem(FsrsCard item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';

  @override
  String get defaultSelect => _fsrsCardWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {'studyCard', 'study_cards'};

  Future<List<FsrsCard>> selectManyByUserIdAndStudyCardIds({
    required String userId,
    required Set<String> studyCardIds,
  }) async {
    final cards = await selectMany(filters: {'user_id': userId});
    return cards
        .where((card) => studyCardIds.contains(card.studyCardId))
        .toList(growable: false);
  }

  Future<List<FsrsCard>> selectManyByIds(List<String> ids) async {
    final cards = <FsrsCard>[];
    for (final id in ids) {
      final card = await selectOne(filters: {'id': id});
      if (card != null) cards.add(card);
    }
    return cards;
  }

  Future<List<SyncIndexEntry>> selectSyncIndexByUserIdAndStudyCardIds({
    required String userId,
    required Set<String> studyCardIds,
  }) => guard(
    () async {
      final response = await client
          .from(tableName)
          .select('id, updated_at, study_cards_id')
          .eq('user_id', userId);
      return List<Map<String, dynamic>>.from(response)
          .where(
            (row) => studyCardIds.contains(row['study_cards_id'] as String?),
          )
          .map(
            (row) => SyncIndexEntry(
              id: row['id'] as String,
              updatedAt: DateTime.parse(row['updated_at'] as String),
            ),
          )
          .toList(growable: false);
    },
    action:
        'selectSyncIndexByUserIdAndStudyCardIds($userId, ${studyCardIds.length} studyCardIds)',
  );

  FsrsCard _fsrsCardFromMap(Map<String, dynamic> map) {
    final values = Map<String, dynamic>.from(map);
    values['study_card_id'] ??= values['study_cards_id'];
    values['study_card'] ??= values['study_cards'];
    return FsrsCardMapper.fromMap(values);
  }
}

const _fsrsCardWithRelationsSelect =
    '*, study_cards:study_cards(*, deck:decks(*), template:card_templates(*, tags(*), options:multiple_choice_options(*), segments:fill_in_the_blank_segments(*), pairs:match_madness_pairs!match_madness_pairs_template_id_fkey(*)), personal_tags:tags(*))';

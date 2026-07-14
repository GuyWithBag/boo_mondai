// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_card_service.dart
// PURPOSE: Supabase CRUD for deck cards and their content nodes
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show SupabaseRemoteDB, StudyCard, StudyCardMapper, SyncIndexEntry;

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

  Future<List<StudyCard>> selectManyByDeckId(String deckId) =>
      selectMany(filters: {'deck_id': deckId});

  Future<List<StudyCard>> selectManyByDeckIds(List<String> deckIds) async {
    final cards = <StudyCard>[];
    for (final deckId in deckIds) {
      cards.addAll(await selectManyByDeckId(deckId));
    }
    return cards;
  }

  Future<List<StudyCard>> selectManyByIds(List<String> ids) async {
    final cards = <StudyCard>[];
    for (final id in ids) {
      final card = await selectOne(filters: {'id': id});
      if (card != null) cards.add(card);
    }
    return cards;
  }

  Future<List<SyncIndexEntry>> selectSyncIndexByDeckIds(List<String> deckIds) =>
      guard(() async {
        if (deckIds.isEmpty) return const <SyncIndexEntry>[];

        final response = await client
            .from(tableName)
            .select('id, updated_at')
            .inFilter('deck_id', deckIds);
        return List<Map<String, dynamic>>.from(response)
            .map(
              (row) => SyncIndexEntry(
                id: row['id'] as String,
                updatedAt: DateTime.parse(row['updated_at'] as String),
              ),
            )
            .toList(growable: false);
      }, action: 'selectSyncIndexByDeckIds(${deckIds.length} deckIds)');

  Future<List<SyncIndexEntry>> selectSyncIndexByDeckId(String deckId) =>
      guard(() async {
        final response = await client
            .from(tableName)
            .select('id, updated_at')
            .eq('deck_id', deckId);
        return List<Map<String, dynamic>>.from(response)
            .map(
              (row) => SyncIndexEntry(
                id: row['id'] as String,
                updatedAt: DateTime.parse(row['updated_at'] as String),
              ),
            )
            .toList(growable: false);
      }, action: 'selectSyncIndexByDeckId($deckId)');
}

const _studyCardWithRelationsSelect =
    '*, deck:decks(*), template:card_templates(*, tags(*), options:multiple_choice_options(*), segments:fill_in_the_blank_segments(*), pairs:match_madness_pairs!match_madness_pairs_template_id_fkey(*)), personal_tags:tags(*)';

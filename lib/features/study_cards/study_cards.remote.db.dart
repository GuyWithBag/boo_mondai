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
  bool get supportsSoftDelete => true;

  @override
  String get defaultSelect => _studyCardWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {
    'template',
    'deck',
    'personalTags',
    'personal_tags',
  };

  Future<List<StudyCard>> selectManyByDeckId(
    String deckId, {
    bool includeDeleted = false,
  }) =>
      selectMany(filters: {'deck_id': deckId}, includeDeleted: includeDeleted);

  Future<List<StudyCard>> selectManyByDeckIds(
    List<String> deckIds, {
    bool includeDeleted = false,
  }) async {
    final cards = <StudyCard>[];
    for (final deckId in deckIds) {
      cards.addAll(
        await selectManyByDeckId(deckId, includeDeleted: includeDeleted),
      );
    }
    return cards;
  }

  Future<List<StudyCard>> selectManyByIds(
    List<String> ids, {
    bool includeDeleted = false,
  }) async {
    final cards = <StudyCard>[];
    for (final id in ids) {
      final card = await selectOne(
        filters: {'id': id},
        includeDeleted: includeDeleted,
      );
      if (card != null) cards.add(card);
    }
    return cards;
  }

  Future<List<SyncIndexEntry>> selectSyncIndexByDeckIds(List<String> deckIds) =>
      deckIds.isEmpty
      ? Future.value(const <SyncIndexEntry>[])
      : selectSyncIndex(
          applyQuery: (query) => query.inFilter('deck_id', deckIds),
          action: 'selectSyncIndexByDeckIds(${deckIds.length} deckIds)',
        );

  Future<List<SyncIndexEntry>> selectSyncIndexByDeckId(String deckId) =>
      selectSyncIndex(
        applyQuery: (query) => query.eq('deck_id', deckId),
        action: 'selectSyncIndexByDeckId($deckId)',
      );
}

const _studyCardWithRelationsSelect =
    '*, deck:decks(*), template:card_templates(*, tags(*), options:multiple_choice_options(*), segments:fill_in_the_blank_segments(*), pairs:match_madness_pairs!match_madness_pairs_template_id_fkey(*)), personal_tags:tags(*)';

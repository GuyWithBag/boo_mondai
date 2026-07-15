// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_fsrs_service.dart
// PURPOSE: Supabase sync for FSRS card states and review logs
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show SupabaseRemoteDB, FsrsCard, StudyCardMapper, SyncIndexEntry;
import 'package:fsrs/fsrs.dart' as fsrs;

class FsrsCardsRemoteDB extends SupabaseRemoteDB<FsrsCard> {
  @override
  String get tableName => 'fsrs_cards';

  @override
  FsrsCard Function(Map<String, dynamic>) get fromMap => _fsrsCardFromMap;

  @override
  Map<String, dynamic> toMap(FsrsCard item) {
    return {
      'id': item.id,
      'created_at': item.createdAt.toIso8601String(),
      'updated_at': item.updatedAt.toIso8601String(),
      'user_id': item.userId,
      'study_cards_id': item.studyCardId,
      'state': item.state.toMap(),
    };
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
    final studyCard = map['study_card'] ?? map['study_cards'];

    return FsrsCard(
      id: map['id'] as String,
      createdAt: _dateTimeFromMap(map, 'created_at'),
      updatedAt: _dateTimeFromMap(map, 'updated_at'),
      userId: map['user_id'] as String,
      studyCardId: (map['study_card_id'] ?? map['study_cards_id']) as String,
      state: _stateFromMap(map['state']),
      studyCard: studyCard == null
          ? null
          : StudyCardMapper.fromMap(
              Map<String, dynamic>.from(studyCard as Map),
            ),
    );
  }

  DateTime _dateTimeFromMap(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is DateTime) return value;
    return DateTime.parse(value as String);
  }

  fsrs.Card _stateFromMap(Object? value) {
    if (value is fsrs.Card) return value;
    final map = Map<String, dynamic>.from(value as Map);
    return fsrs.Card.fromMap(map);
  }
}

const _fsrsCardWithRelationsSelect =
    '*, study_cards:study_cards(*, deck:decks(*), template:card_templates(*, tags(*), options:multiple_choice_options(*), segments:fill_in_the_blank_segments(*), pairs:match_madness_pairs!match_madness_pairs_template_id_fkey(*)), personal_tags:tags(*))';

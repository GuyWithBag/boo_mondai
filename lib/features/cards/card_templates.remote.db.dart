// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/card_template_tag_remote_db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show CardTemplate, SupabaseRemoteDB, CardTemplateMapper, SyncIndexEntry;

class CardTemplatesRemoteDB extends SupabaseRemoteDB<CardTemplate> {
  @override
  String get tableName => 'card_templates';

  @override
  CardTemplate Function(Map<String, dynamic>) get fromMap =>
      CardTemplateMapper.fromMap;

  @override
  Map<String, dynamic> toMap(CardTemplate item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(CardTemplate item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';

  @override
  bool get supportsSoftDelete => true;

  @override
  String get defaultSelect => _cardTemplateWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {
    'tags',
    'options',
    'segments',
    'pairs',
  };

  Future<List<CardTemplate>> selectManyByDeckId(
    String deckId, {
    bool includeDeleted = false,
  }) =>
      selectMany(filters: {'deck_id': deckId}, includeDeleted: includeDeleted);

  Future<List<CardTemplate>> selectManyByDeckIds(
    List<String> deckIds, {
    bool includeDeleted = false,
  }) async {
    final templates = <CardTemplate>[];
    for (final deckId in deckIds) {
      templates.addAll(
        await selectManyByDeckId(deckId, includeDeleted: includeDeleted),
      );
    }
    return templates;
  }

  Future<List<CardTemplate>> selectManyByIds(
    List<String> ids, {
    bool includeDeleted = false,
  }) async {
    final templates = <CardTemplate>[];
    for (final id in ids) {
      final template = await selectOne(
        filters: {'id': id},
        includeDeleted: includeDeleted,
      );
      if (template != null) templates.add(template);
    }
    return templates;
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

const _cardTemplateWithRelationsSelect =
    '*, tags(*), options:multiple_choice_options(*), segments:fill_in_the_blank_segments(*), pairs:match_madness_pairs!match_madness_pairs_template_id_fkey(*)';

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
  String get defaultSelect => _cardTemplateWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {
    'tags',
    'options',
    'segments',
    'pairs',
  };

  Future<List<CardTemplate>> selectManyByDeckId(String deckId) =>
      selectMany(filters: {'deck_id': deckId});

  Future<List<CardTemplate>> selectManyByDeckIds(List<String> deckIds) async {
    final templates = <CardTemplate>[];
    for (final deckId in deckIds) {
      templates.addAll(await selectManyByDeckId(deckId));
    }
    return templates;
  }

  Future<List<CardTemplate>> selectManyByIds(List<String> ids) async {
    final templates = <CardTemplate>[];
    for (final id in ids) {
      final template = await selectOne(filters: {'id': id});
      if (template != null) templates.add(template);
    }
    return templates;
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

const _cardTemplateWithRelationsSelect =
    '*, tags(*), options:multiple_choice_options(*), segments:fill_in_the_blank_segments(*), pairs:match_madness_pairs!match_madness_pairs_template_id_fkey(*)';

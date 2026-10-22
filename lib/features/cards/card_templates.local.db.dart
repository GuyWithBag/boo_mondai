// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/deck_card_repository.dart
// PURPOSE: Hive CRUD for CardTemplate — source of truth for cards belonging to a deck
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show CardTemplate, HiveLocalDB, SyncIndexEntry;

class CardTemplatesLocalDB extends HiveLocalDB<CardTemplate> {
  @override
  String get boxName => 'card_templates';

  @override
  Map<String, Object?> primaryKeyFromItem(CardTemplate item) => {'id': item.id};

  @override
  DateTime? getDeletedAt(CardTemplate item) => item.deletedAt;

  List<CardTemplate> getByDeckId(String deckId) => guardSync(
    () => selectMany(where: (c) => c.deckId == deckId),
    action: 'getByDeckId($deckId)',
  );

  List<CardTemplate> selectManyByDeckIds(Set<String> deckIds) => guardSync(
    () => selectMany(where: (template) => deckIds.contains(template.deckId)),
    action: 'selectManyByDeckIds(${deckIds.length} deckIds)',
  );

  List<SyncIndexEntry> selectSyncIndexByDeckIds(Set<String> deckIds) =>
      selectSyncIndexWhere(
        where: (template) => deckIds.contains(template.deckId),
        getId: (template) => template.id,
        getUpdatedAt: (template) => template.updatedAt,
        action: 'selectSyncIndexByDeckIds(${deckIds.length} deckIds)',
      );

  List<CardTemplate> selectManyByIds(List<String> ids) => guardSync(
    () => [
      for (final id in ids) ?selectByPk({'id': id}, includeDeleted: true),
    ],
    action: 'selectManyByIds(${ids.length} ids)',
  );

  Future<void> deleteByDeckId(String deckId) => guard(() async {
    final keys = box.values
        .where((c) => c.deckId == deckId)
        .map((c) => primaryKeyFromItem(c))
        .toList();
    await box.deleteAll(keys.map(encodePrimaryKey));
  }, action: 'deleteByDeckId($deckId)');
}

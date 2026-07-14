// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/deck_card_repository.dart
// PURPOSE: Hive CRUD for StudyCard — source of truth for cards belonging to a deck
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show StudyCard, HiveLocalDB, SyncIndexEntry;

class StudyCardsLocalDB extends HiveLocalDB<StudyCard> {
  @override
  String get boxName => 'study_cards';

  @override
  Map<String, Object?> primaryKeyFromItem(StudyCard item) => {'id': item.id};

  List<StudyCard> getByDeckId(String deckId) => guardSync(
    () => box.values.where((c) => c.deckId == deckId).toList(),
    action: 'getByDeckId($deckId)',
  );

  List<StudyCard> selectManyByDeckIds(Set<String> deckIds) => guardSync(
    () => selectMany(where: (card) => deckIds.contains(card.deckId)),
    action: 'selectManyByDeckIds(${deckIds.length} deckIds)',
  );

  List<SyncIndexEntry> selectSyncIndexByDeckIds(Set<String> deckIds) =>
      guardSync(
        () => selectManyByDeckIds(deckIds)
            .map(
              (card) => SyncIndexEntry(id: card.id, updatedAt: card.updatedAt),
            )
            .toList(growable: false),
        action: 'selectSyncIndexByDeckIds(${deckIds.length} deckIds)',
      );

  List<StudyCard> selectManyByIds(List<String> ids) => guardSync(
    () => [
      for (final id in ids) ?selectByPk({'id': id}),
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

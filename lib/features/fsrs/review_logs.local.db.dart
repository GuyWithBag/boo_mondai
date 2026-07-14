// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/review_log_repository.dart
// PURPOSE: Hive CRUD for FsrsReviewLog — append-only log of every card review event
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';

class ReviewLogsLocalDB extends HiveLocalDB<FsrsReviewLog> {
  @override
  String get boxName => 'review_logs';

  @override
  Map<String, Object?> primaryKeyFromItem(FsrsReviewLog item) => {
    'id': item.id,
  };

  List<FsrsReviewLog> getByCardId(String cardId) => guardSync(
    () => box.values.where((e) => e.fsrsCardId == cardId).toList(),
    action: 'getByCardId($cardId)',
  );

  List<FsrsReviewLog> selectManyByFsrsCardIds(Set<String> fsrsCardIds) =>
      guardSync(
        () => selectMany(where: (log) => fsrsCardIds.contains(log.fsrsCardId)),
        action: 'selectManyByFsrsCardIds(${fsrsCardIds.length} fsrsCardIds)',
      );

  List<SyncIndexEntry> selectSyncIndexByFsrsCardIds(Set<String> fsrsCardIds) =>
      guardSync(
        () => selectManyByFsrsCardIds(fsrsCardIds)
            .map((log) => SyncIndexEntry(id: log.id, updatedAt: log.createdAt))
            .toList(growable: false),
        action:
            'selectSyncIndexByFsrsCardIds(${fsrsCardIds.length} fsrsCardIds)',
      );

  List<FsrsReviewLog> selectManyByIds(List<String> ids) => guardSync(
    () => [
      for (final id in ids) ?selectByPk({'id': id}),
    ],
    action: 'selectManyByIds(${ids.length} ids)',
  );

  List<DateTime> activityDates() => guardSync(
    () => box.values.map((e) => e.createdAt).toList(),
    action: 'activityDates',
  );
}

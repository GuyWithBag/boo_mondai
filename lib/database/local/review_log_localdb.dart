// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/review_log_repository.dart
// PURPOSE: Hive CRUD for FsrsReviewLog — append-only log of every card review event
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';

class ReviewLogLocalDB extends HiveLocalDB<FsrsReviewLog> {
  @override
  String get boxName => 'review_logs';

  @override
  Map<String, Object?> primaryKeyFromItem(FsrsReviewLog item) => {
    'id': item.id,
  };

  List<FsrsReviewLog> getByCardId(String cardId) => guardSync(
    () => box.values.where((e) => e.log.cardId.toString() == cardId).toList(),
    action: 'getByCardId($cardId)',
  );
}

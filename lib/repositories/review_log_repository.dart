// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/review_log_repository.dart
// PURPOSE: Hive CRUD for FsrsReviewLog — append-only log of every card review event
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';

class ReviewLogRepository extends HiveRepository<FsrsReviewLog> {
  @override
  String get boxName => 'review_log_box';

  @override
  String getId(FsrsReviewLog item) => item.log.cardId.toString();

  List<FsrsReviewLog> getByCardId(String cardId) =>
      box.values.where((e) => e.log.cardId.toString() == cardId).toList();
}

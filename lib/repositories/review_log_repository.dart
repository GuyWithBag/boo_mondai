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
  String getId(FsrsReviewLog item) => item.state.cardId.toString();

  List<FsrsReviewLog> getByCardId(String cardId) =>
      box.values.where((e) => e.state.cardId.toString() == cardId).toList();
}

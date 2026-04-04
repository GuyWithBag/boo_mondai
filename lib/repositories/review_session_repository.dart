// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/drill_session_repository.dart
// PURPOSE: Hive CRUD for DrillSession only
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'hive_repository.dart';

class ReviewSessionRepository extends HiveRepository<ReviewSession> {
  @override
  String get boxName => 'review_session_box';

  @override
  String getId(ReviewSession item) => item.id;

  List<ReviewSession> getRecent(int count) {
    final sorted = box.values.toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return sorted.take(count).toList();
  }
}

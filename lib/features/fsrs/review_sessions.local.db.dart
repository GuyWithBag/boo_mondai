// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/drill_session_repository.dart
// PURPOSE: Hive CRUD for DrillSession only
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show HiveLocalDB, ReviewSession;

class ReviewSessionsLocalDB extends HiveLocalDB<ReviewSession> {
  @override
  String get boxName => 'review_sessions';

  @override
  Map<String, Object?> primaryKeyFromItem(ReviewSession item) => {
    'id': item.id,
  };

  List<ReviewSession> getRecent(int count) => guardSync(() {
    final sorted = box.values.toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return sorted.take(count).toList();
  }, action: 'getRecent($count)');
}

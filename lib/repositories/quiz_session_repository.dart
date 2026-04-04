// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/quiz_session_repository.dart
// PURPOSE: Hive CRUD for DrillSession only
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'hive_repository.dart';

class DrillSessionRepository extends HiveRepository<DrillSession> {
  @override
  String get boxName => 'quiz_session_box';

  @override
  String getId(DrillSession item) => item.id;

  List<DrillSession> getRecent(int count) {
    final sorted = box.values.toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return sorted.take(count).toList();
  }
}

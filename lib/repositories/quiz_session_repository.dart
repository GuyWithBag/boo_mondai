// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/quiz_session_repository.dart
// PURPOSE: Hive CRUD for QuizSession only
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'hive_repository.dart';

class QuizSessionRepository extends HiveRepository<QuizSession> {
  @override
  String get boxName => 'quiz_session_box';

  @override
  String getId(QuizSession item) => item.id;

  List<QuizSession> getRecent(int count) {
    final sorted = box.values.toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return sorted.take(count).toList();
  }
}

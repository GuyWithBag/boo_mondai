// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/quiz_answer_repository.dart
// PURPOSE: Dedicated Hive CRUD for permanent QuizAnswer storage
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'hive_repository.dart';

class QuizAnswerRepository extends HiveRepository<QuizAnswer> {
  @override
  String get boxName => 'quiz_answer_box';

  @override
  String getId(QuizAnswer item) => item.id;

  // ── Domain Specific Queries ────────────────────────────────

  /// Fetches all answers submitted during a specific session
  List<QuizAnswer> getBySessionId(String sessionId) {
    return box.values.where((a) => a.sessionId == sessionId).toList();
  }

  /// Fetches the history of a specific card (useful for future stats screens!)
  List<QuizAnswer> getByReviewCardId(String reviewCardId) {
    return box.values.where((a) => a.cardId == reviewCardId).toList();
  }
}

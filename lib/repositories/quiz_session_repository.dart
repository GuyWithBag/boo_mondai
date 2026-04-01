// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/quiz_session_repository.dart
// PURPOSE: Hive CRUD for QuizSession and QuizAnswer — persists quiz history and per-session answers
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:hive_ce/hive.dart';
import '../models/quiz_session.dart';
import '../models/quiz_answer.dart';
import 'hive_repository.dart';

class QuizSessionRepository extends HiveRepository<QuizSession> {
  static const String answersBoxName = 'quiz_answer_box';

  @override
  String get boxName => 'quiz_session_box';

  @override
  String getId(QuizSession item) => item.id;

  Box<QuizAnswer> get _answersBox => Hive.box<QuizAnswer>(answersBoxName);

  List<QuizSession> getRecent(int count) {
    final sorted = box.values.toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return sorted.take(count).toList();
  }

  Future<void> saveAnswers(List<QuizAnswer> answers) async {
    final map = {for (final a in answers) a.id: a};
    await _answersBox.putAll(map);
  }

  List<QuizAnswer> getAnswersBySessionId(String sessionId) =>
      _answersBox.values.where((a) => a.sessionId == sessionId).toList();
}

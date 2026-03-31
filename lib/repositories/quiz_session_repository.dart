// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/quiz_session_repository.dart
// PURPOSE: Hive CRUD for QuizSession and QuizAnswer — persists quiz history and per-session answers
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:hive_ce/hive.dart';
import '../models/quiz_session.dart';
import '../models/quiz_answer.dart';

class QuizSessionRepository {
  static const String boxName = 'quiz_session_box';
  static const String answersBoxName = 'quiz_answer_box';

  Box<QuizSession> get _box => Hive.box<QuizSession>(boxName);
  Box<QuizAnswer> get _answersBox => Hive.box<QuizAnswer>(answersBoxName);

  List<QuizSession> getAll() => _box.values.toList();

  QuizSession? getById(String id) => _box.get(id);

  List<QuizSession> getRecent(int count) {
    final sorted = _box.values.toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return sorted.take(count).toList();
  }

  Future<void> save(QuizSession session) => _box.put(session.id, session);

  Future<void> saveAll(List<QuizSession> sessions) async {
    final map = {for (final s in sessions) s.id: s};
    await _box.putAll(map);
  }

  Future<void> delete(String id) => _box.delete(id);

  Future<void> clear() => _box.clear();

  Future<void> saveAnswers(List<QuizAnswer> answers) async {
    final map = {for (final a in answers) a.id: a};
    await _answersBox.putAll(map);
  }

  List<QuizAnswer> getAnswersBySessionId(String sessionId) =>
      _answersBox.values.where((a) => a.sessionId == sessionId).toList();
}

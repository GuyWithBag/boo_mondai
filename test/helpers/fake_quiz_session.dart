import 'package:boo_mondai/models/models.dart';
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/helpers/fake_quiz_session.dart
// PURPOSE: Provides fake QuizSession instances for unit and widget tests
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

QuizSession fakeQuizSession({String? id, bool? completed}) => QuizSession(
      id: id ?? '00000000-0000-0000-0000-000000000040',
      userId: '00000000-0000-0000-0000-000000000002',
      deckId: '00000000-0000-0000-0000-000000000010',
      previewed: true,
      totalQuestions: 3,
      correctCount: 2,
      startedAt: DateTime(2026, 1, 1),
      completedAt: completed == true ? DateTime(2026, 1, 1, 0, 10) : null,
    );

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/vocabulary_test_result.dart
// PURPOSE: Multiple-choice vocabulary test result (A/B/C/D, 30 items)
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'vocabulary_test_result.mapper.dart';

@MappableClass()
class VocabularyTestResult with VocabularyTestResultMappable {
  final String id;
  final String userId;
  final String testSet; // 'A' or 'B'
  final int score; // out of 30
  final Map<String, dynamic> answers; // {question_id: selected_option}
  final DateTime submittedAt;

  const VocabularyTestResult({
    required this.id,
    required this.userId,
    required this.testSet,
    required this.score,
    required this.answers,
    required this.submittedAt,
  });

  double get scorePercent => score / 30;
}

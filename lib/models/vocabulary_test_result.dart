// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/vocabulary_test_result.dart
// PURPOSE: Multiple-choice vocabulary test result (A/B/C/D, 30 items)
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class VocabularyTestResult {
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

  factory VocabularyTestResult.fromJson(Map<String, dynamic> json) =>
      VocabularyTestResult(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        testSet: json['test_set'] as String,
        score: json['score'] as int,
        answers: Map<String, dynamic>.from(json['answers'] as Map),
        submittedAt: DateTime.parse(json['submitted_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'test_set': testSet,
        'score': score,
        'answers': answers,
        'submitted_at': submittedAt.toIso8601String(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabularyTestResult &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'VocabularyTestResult(testSet: $testSet, score: $score/30)';
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_result/answer_result_tile.dart
// PURPOSE: List tile showing a single quiz answer result with rating chip
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class AnswerResultTile extends StatelessWidget {
  const AnswerResultTile({
    super.key,
    required this.userAnswer,
    required this.isCorrect,
    this.selfRating,
    this.isEjected = false,
  });

  final String userAnswer;
  final bool isCorrect;
  final int? selfRating;
  final bool isEjected;

  String get _ratingLabel => switch (selfRating) {
    1 => 'Again',
    2 => 'Hard',
    3 => 'Good',
    4 => 'Easy',
    _ => '',
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          isCorrect ? Icons.check_circle : Icons.cancel,
          color: isCorrect ? AppColors.correct : AppColors.incorrect,
        ),
        title: Text(userAnswer.isEmpty ? '(no answer)' : userAnswer),
        trailing: isEjected
            ? Tooltip(
                message: 'This card was moved to FSRS review',
                child: Chip(
                  label: const Text('Review Later'),
                  backgroundColor: AppColors.hard.withValues(alpha: 0.12),
                  labelStyle: const TextStyle(
                    color: AppColors.hard,
                    fontSize: 11,
                  ),
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                ),
              )
            : selfRating != null
            ? Chip(label: Text(_ratingLabel))
            : null,
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/drill_result/answer_result_tile.dart
// PURPOSE: List tile showing a single drill answer result with rating chip
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart'; // <-- Import to access StudyRating
import 'package:boo_mondai/shared/shared.barrel.dart';

class AnswerResultTile extends StatelessWidget {
  const AnswerResultTile({
    super.key,
    required this.userAnswer,
    required this.type, // <-- Replaced `isCorrect` and `selfRating`
    this.isEjected = false,
  });

  final String userAnswer;
  final StudyRating type; // <-- The clean enum
  final bool isEjected;

  // Helper to determine pass/fail for the leading icon
  bool get _isCorrect => type != StudyRating.incorrect;

  // Helper to grab the correct display text based on the enum
  String get _ratingLabel => switch (type) {
    StudyRating.again => 'Again',
    StudyRating.hard => 'Hard',
    StudyRating.good => 'Good',
    StudyRating.easy => 'Easy',
    StudyRating.incorrect => '',
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          _isCorrect ? Icons.check_circle : Icons.cancel,
          color: _isCorrect ? AppColors.correct : AppColors.incorrect,
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
            // If it's correct (not a typo), show the FSRS rating they gave it
            : type != StudyRating.incorrect
            ? Chip(label: Text(_ratingLabel))
            : null,
      ),
    );
  }
}

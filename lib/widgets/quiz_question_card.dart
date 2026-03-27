// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/quiz_question_card.dart
// PURPOSE: Reusable question display card for quiz and review contexts
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.dart';

class QuizQuestionCard extends StatelessWidget {
  final String question;
  final String? imageUrl;

  const QuizQuestionCard({
    super.key,
    required this.question,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageUrl != null) ...[
                Image.network(imageUrl!, height: 120),
                const SizedBox(height: AppSpacing.md),
              ],
              Text(
                question,
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

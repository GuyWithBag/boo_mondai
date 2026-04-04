// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/drill_question_card.dart
// PURPOSE: Reusable question display card for drill and review contexts
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class DrillQuestionCard extends StatelessWidget {
  final String question;
  final String? imageUrl;

  const DrillQuestionCard({super.key, required this.question, this.imageUrl});

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

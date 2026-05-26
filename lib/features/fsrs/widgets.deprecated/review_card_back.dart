// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/review/study_cards_back.dart
// PURPOSE: Back side of the review flip card showing the answer
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show AppSpacing;
import 'package:flutter/material.dart';

class StudyCardBack extends StatelessWidget {
  const StudyCardBack({super.key, required this.answer, this.imageUrl});

  final String answer;
  final String? imageUrl;

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
                answer,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

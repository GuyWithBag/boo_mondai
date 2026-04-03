// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/rating_area.dart
// PURPOSE: Shared rating area shown after answering, with optional feedback
// PROVIDERS: QuizSessionPageController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

// Custom intents for the keyboard shortcuts
class RateIntent extends Intent {
  final QuizAnswerType type;
  const RateIntent(this.type);
}

class RatingArea extends StatelessWidget {
  const RatingArea({
    super.key,
    required this.template,
    required this.isReversed,
    required this.controller,
    required this.answer,
  });

  final CardTemplate template;
  final bool isReversed;
  final QuizSessionPageController controller;
  final String answer;

  @override
  Widget build(BuildContext context) {
    void onTap(QuizAnswerType type) {
      controller.submitAnswer(answer, type);
    }

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.digit1): RateIntent(
          QuizAnswerType.again,
        ),
        SingleActivator(LogicalKeyboardKey.digit2): RateIntent(
          QuizAnswerType.hard,
        ),
        SingleActivator(LogicalKeyboardKey.digit3): RateIntent(
          QuizAnswerType.good,
        ),
        SingleActivator(LogicalKeyboardKey.digit4): RateIntent(
          QuizAnswerType.easy,
        ),
        // Numpad support
        SingleActivator(LogicalKeyboardKey.numpad1): RateIntent(
          QuizAnswerType.again,
        ),
        SingleActivator(LogicalKeyboardKey.numpad2): RateIntent(
          QuizAnswerType.hard,
        ),
        SingleActivator(LogicalKeyboardKey.numpad3): RateIntent(
          QuizAnswerType.good,
        ),
        SingleActivator(LogicalKeyboardKey.numpad4): RateIntent(
          QuizAnswerType.easy,
        ),
      },
      child: Actions(
        actions: {
          RateIntent: CallbackAction<RateIntent>(
            onInvoke: (intent) {
              onTap(intent.type);
              return null;
            },
          ),
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'How well did you know it?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                RatingButton(
                  QuizAnswerType.again,
                  onTap: () => onTap(QuizAnswerType.again),
                ),
                const SizedBox(width: AppSpacing.sm),
                RatingButton(
                  QuizAnswerType.hard,
                  onTap: () => onTap(QuizAnswerType.hard),
                ),
                const SizedBox(width: AppSpacing.sm),
                RatingButton(
                  QuizAnswerType.good,
                  onTap: () => onTap(QuizAnswerType.good),
                ),
                const SizedBox(width: AppSpacing.sm),
                RatingButton(
                  QuizAnswerType.easy,
                  onTap: () => onTap(QuizAnswerType.easy),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

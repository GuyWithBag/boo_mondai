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
import 'package:flutter_hooks/flutter_hooks.dart';

// Custom intents for the keyboard shortcuts
class RateIntent extends Intent {
  final QuizAnswerType type;
  const RateIntent(this.type);
}

enum SubmissionStyle { showAnswer, submitAnswer, none }

class RatingArea extends HookWidget {
  const RatingArea({
    super.key,
    required this.controller,
    required this.answer,
    required this.isRevealed,
    required this.onSubmit,
    required this.submissionStyle,
  });

  final SessionController controller;
  final String? answer;
  final bool isRevealed;
  final VoidCallback? onSubmit;
  final SubmissionStyle submissionStyle;

  @override
  Widget build(BuildContext context) {
    void onTap(QuizAnswerType type) {
      if (answer == null) {
        print("ERROR");
        return;
      }
      controller.submitAnswer(answer!, type);
    }

    if (!isRevealed || submissionStyle == SubmissionStyle.none) {
      return Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        child: Actions(
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                if (onSubmit == null) return;
                onSubmit!();
                return null;
              },
            ),
          },
          child: SizedBox(
            width: double.infinity,
            child: submissionStyle == SubmissionStyle.showAnswer
                ? FilledButton.icon(
                    onPressed: onSubmit,
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('Show Answer'),
                  )
                : FilledButton.icon(
                    onPressed: onSubmit,
                    icon: const Icon(Icons.check),
                    label: const Text('Submit'),
                  ),
          ),
        ),
      );
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
                  ctrl: controller,
                  onTap: () => onTap(QuizAnswerType.again),
                ),
                const SizedBox(width: AppSpacing.sm),
                RatingButton(
                  QuizAnswerType.hard,
                  ctrl: controller,
                  onTap: () => onTap(QuizAnswerType.hard),
                ),
                const SizedBox(width: AppSpacing.sm),
                RatingButton(
                  ctrl: controller,
                  QuizAnswerType.good,
                  onTap: () => onTap(QuizAnswerType.good),
                ),
                const SizedBox(width: AppSpacing.sm),
                RatingButton(
                  QuizAnswerType.easy,
                  ctrl: controller,
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

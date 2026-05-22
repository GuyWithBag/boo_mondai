// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/drill_session/rating_area.dart
// PURPOSE: Shared rating area shown after answering, with optional feedback
// PROVIDERS: DrillSessionController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/services/services.barrel.dart';
import 'package:boo_mondai/variant_styles/variant_styles.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

// Custom intents for the keyboard shortcuts
class RateIntent extends Intent {
  final StudyRating type;
  const RateIntent(this.type);
}

enum SubmissionStyle { showAnswer, submitAnswer, none }

class RatingArea extends HookWidget {
  const RatingArea({
    required this.studySessionController,
    required this.interactionsController,
    super.key,
  });

  final StudySessionController studySessionController;
  final StudySessionCardStageController interactionsController;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    final bool isRevealed = interactionsController.isRevealed;
    final SubmissionStyle submissionStyle =
        StudySessionService.getSubmissionStyle(
          studySessionController.currentTemplate!,
        );
    final String? answer = interactionsController.answer;

    void onSubmit() {
      if (!interactionsController.canReveal) {
        return;
      }

      final template = studySessionController.currentTemplate!;
      if (answer != null &&
          StudySessionService.isAutoGraded(template) &&
          !StudySessionService.isAnswerCorrect(template, answer)) {
        interactionsController.reveal(
          studySessionController,
          pendingRating: StudyRating.incorrect,
        );
        return;
      }

      interactionsController.reveal(studySessionController);
    }

    void onContinue() {
      final pendingRating = interactionsController.pendingRating;
      if (answer == null || pendingRating == null) {
        return;
      }

      studySessionController.submitAnswer(answer, pendingRating);
    }

    void onRatingTap(StudyRating type) {
      if (answer == null) {
        return;
      }

      final template = studySessionController.currentTemplate!;
      final effectiveType =
          StudySessionService.isAutoGraded(template) &&
              !StudySessionService.isAnswerCorrect(template, answer)
          ? StudyRating.incorrect
          : type;

      studySessionController.submitAnswer(answer, effectiveType);
    }

    Widget getWidget() {
      if (!isRevealed) {
        return Shortcuts(
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          },
          child: Actions(
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  onSubmit();
                  return null;
                },
              ),
            },
            child: SizedBox(
              width: double.infinity,
              child: submissionStyle == SubmissionStyle.none
                  ? const SizedBox(height: 54)
                  : submissionStyle == SubmissionStyle.showAnswer
                  ? TactileButton(
                      onPressed: interactionsController.canReveal
                          ? onSubmit
                          : null,
                      leading: const Icon(Icons.visibility_outlined),
                      child: const Text('Show Answer'),
                    )
                  : TactileButton(
                      onPressed: interactionsController.canReveal
                          ? onSubmit
                          : null,
                      leading: const Icon(Icons.check),
                      child: const Text('Submit'),
                    ),
            ),
          ),
        );
      }

      if (interactionsController.pendingRating != null) {
        return Shortcuts(
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          },
          child: Actions(
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  onContinue();
                  return null;
                },
              ),
            },
            child: SizedBox(
              width: double.infinity,
              child: TactileButton(
                onPressed: onContinue,
                leading: const Icon(Icons.arrow_forward),
                child: const Text('Continue'),
              ),
            ),
          ),
        );
      }

      return Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.digit1): RateIntent(
            StudyRating.again,
          ),
          SingleActivator(LogicalKeyboardKey.digit2): RateIntent(
            StudyRating.hard,
          ),
          SingleActivator(LogicalKeyboardKey.digit3): RateIntent(
            StudyRating.good,
          ),
          SingleActivator(LogicalKeyboardKey.digit4): RateIntent(
            StudyRating.easy,
          ),
          // Numpad support
          SingleActivator(LogicalKeyboardKey.numpad1): RateIntent(
            StudyRating.again,
          ),
          SingleActivator(LogicalKeyboardKey.numpad2): RateIntent(
            StudyRating.hard,
          ),
          SingleActivator(LogicalKeyboardKey.numpad3): RateIntent(
            StudyRating.good,
          ),
          SingleActivator(LogicalKeyboardKey.numpad4): RateIntent(
            StudyRating.easy,
          ),
        },
        child: Actions(
          actions: {
            RateIntent: CallbackAction<RateIntent>(
              onInvoke: (intent) {
                onRatingTap(intent.type);
                return null;
              },
            ),
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'How well did you know it?',
                style: appTextStyle.resolve(tokens, [
                  TextSize.labelSmall,
                  TextWeight.heavy,
                  TextTone.muted,
                ]),
              ),
              // const SizedBox(height: AppSpacing.sm),
              SizedBox(height: 16.h),
              Row(
                children: [
                  RatingButton(
                    StudyRating.again,
                    ctrl: studySessionController,
                    onTap: () => onRatingTap(StudyRating.again),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  RatingButton(
                    StudyRating.hard,
                    ctrl: studySessionController,
                    onTap: () => onRatingTap(StudyRating.hard),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  RatingButton(
                    ctrl: studySessionController,
                    StudyRating.good,
                    onTap: () => onRatingTap(StudyRating.good),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  RatingButton(
                    StudyRating.easy,
                    ctrl: studySessionController,
                    onTap: () => onRatingTap(StudyRating.easy),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: Offset(0, 5.h / 80),
          end: Offset.zero,
        ).animate(animation);

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
      child: getWidget(),
    );
  }
}

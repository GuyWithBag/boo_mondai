import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        StudyRating,
        AppTokens,
        Button,
        ButtonColor,
        RatingButton,
        SubmissionStyle,
        ViewStudySessionController;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

// Custom intents for the keyboard shortcuts
class RateIntent extends Intent {
  final StudyRating type;
  const RateIntent(this.type);
}

class RatingArea extends SignalHookWidget {
  const RatingArea({required this.controller, super.key});

  final ViewStudySessionController controller;

  static const double preferredHeight = 130.0;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final studySessionController = controller.sessionController;
    final cardStageController = controller.cardStageController;

    final bool isRevealed = cardStageController.isRevealed.value;
    final template = studySessionController.currentTemplate.value;
    if (template == null) {
      return controller.isCompleting.value
          ? const Center(child: CircularProgressIndicator())
          : const SizedBox.shrink();
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
                  controller.submitCurrentAnswer();
                  return null;
                },
              ),
            },
            child: SizedBox(
              width: double.infinity,
              child: controller.submissionStyle == SubmissionStyle.none
                  ? const SizedBox(height: 54)
                  : controller.submissionStyle == SubmissionStyle.showAnswer
                  ? Button(
                      onPressed: cardStageController.canReveal.value
                          ? controller.submitCurrentAnswer
                          : null,
                      leading: const Icon(Icons.visibility_outlined),
                      child: const Text('Show Answer'),
                    )
                  : Button(
                      onPressed: cardStageController.canReveal.value
                          ? controller.submitCurrentAnswer
                          : null,
                      leading: const Icon(Icons.check),
                      variants: const [ButtonColor.primary],
                      child: const Text('Submit'),
                    ),
            ),
          ),
        );
      }

      if (cardStageController.pendingRating.value != null) {
        return Shortcuts(
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          },
          child: Actions(
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  controller.continuePendingRating();
                  return null;
                },
              ),
            },
            child: SizedBox(
              width: double.infinity,
              child: Button(
                onPressed: controller.continuePendingRating,
                leading: const Icon(Icons.arrow_forward),
                variants: [ButtonColor.primary],
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
                controller.rateCurrentAnswer(intent.type);
                return null;
              },
            ),
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: tokens.spaceLayoutGapMd,
            children: [
              SectionEyebrow('How well did you know it?', isUpperCase: false),
              Row(
                spacing: tokens.spaceLayoutGapSm,
                children: [
                  RatingButton(
                    StudyRating.again,
                    ctrl: studySessionController,
                    onTap: () => controller.rateCurrentAnswer(
                      StudyRating.again,
                      playSound: false,
                    ),
                  ),
                  RatingButton(
                    StudyRating.hard,
                    ctrl: studySessionController,
                    onTap: () => controller.rateCurrentAnswer(
                      StudyRating.hard,
                      playSound: false,
                    ),
                  ),
                  RatingButton(
                    ctrl: studySessionController,
                    StudyRating.good,
                    onTap: () => controller.rateCurrentAnswer(
                      StudyRating.good,
                      playSound: false,
                    ),
                  ),
                  RatingButton(
                    StudyRating.easy,
                    ctrl: studySessionController,
                    onTap: () => controller.rateCurrentAnswer(
                      StudyRating.easy,
                      playSound: false,
                    ),
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

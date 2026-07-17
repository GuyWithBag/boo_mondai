// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/session_page.dart
// PURPOSE: Unified session interface for both Drill and Review modes
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppSpacing,
        AppTokens,
        BottomNavBar,
        Button,
        ErrorState,
        ErrorText,
        FlashcardTemplate,
        ProgressBar,
        RatingArea,
        MessageSessionStep,
        Scaffold,
        SessionException,
        SessionMode,
        StudySessionCardStage,
        StudySessionController,
        TextColor,
        TextSize,
        TextWeight,
        ViewStudyCardsController,
        textStyle,
        useDrillSessionController,
        useReviewSessionController,
        useStudySessionPageController,
        useStudySessionCardStageController;
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, HookWidget;
import 'package:provider/provider.dart' show ReadContext;
import 'package:theme_variants/theme_variants.dart';

class ViewStudySessionPage extends HookWidget {
  const ViewStudySessionPage({
    super.key,
    required this.deckId,
    required this.mode,
  });

  // Drill sessions always require a deckId
  // Nullable becauase: Review sessions can be global (null = all due cards)
  final String? deckId;
  final SessionMode mode;

  @override
  Widget build(BuildContext context) {
    if (deckId == null && mode == SessionMode.drill) {
      throw SessionException;
    }

    final ViewStudyCardsController? dashboardController =
        mode == SessionMode.review
        ? context.read<ViewStudyCardsController>()
        : null;
    final StudySessionController controller;
    final tokens = context.themeTokens<AppTokens>();

    if (mode == SessionMode.drill) {
      controller = useDrillSessionController(deckId: deckId!);
    } else {
      controller = useReviewSessionController(
        deckId: deckId,
        filter: dashboardController!.dueFilter,
      );
    }

    final studySessionPageController = useStudySessionPageController(
      context: context,
      mode: mode,
      sessionController: controller,
      dashboardController: dashboardController,
    );

    useEffect(() {
      studySessionPageController.onCompletion();
      return null;
    }, [controller.isComplete, controller.session?.id]);

    // 1. Handle Loading (Review only has isLoading, Drill uses null session or missing template)

    // 2. Handle Errors
    if (controller.error != null) {
      return ErrorState(exception: controller.error);
    }

    // 3. Handle Completion
    if (controller.isComplete) {
      if (mode == SessionMode.drill) {
        return const Scaffold(body: SizedBox.shrink());
      } else {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome, size: 80, color: Colors.orange),
                const SizedBox(height: AppSpacing.lg),
                const Text('Deck Review Finished!'),
                const SizedBox(height: AppSpacing.lg),
                Button(
                  onPressed: studySessionPageController.onReviewCompletePressed,
                  leading: const Icon(Icons.arrow_back),
                  child: const Text('Back to Dashboard'),
                ),
              ],
            ),
          ),
        );
      }
    }

    final step = controller.currentStep;
    if (step is MessageSessionStep) {
      return Scaffold(
        scrollable: false,
        appBar: AppBar(
          onPop: studySessionPageController.onSessionPop,
          child: ProgressBar(value: controller.getProgressPercentage()),
        ),
        bottomNavBar: BottomNavBar(
          child: Button(
            onPressed: controller.advancePresentationStep,
            child: const Text('Continue'),
          ),
        ),
        inheritMainBottomNavBarHeight: false,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                step.title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(step.message, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    // 4. Extract card data
    final template = controller.currentTemplate;
    final studyCard = controller.currentStudyCard;

    if (template == null || studyCard == null) {
      return ErrorText(controller.error);
    }

    final interactionsController = useStudySessionCardStageController(
      cardId: studyCard.id,
      cardIndex: controller.currentIndex,
      canReveal: template is FlashcardTemplate,
      initialAnswer: template is FlashcardTemplate
          ? template.getAnswer(isReversed: studyCard.isReversed)
          : null,
    );

    return Scaffold(
      scrollable: false,
      appBar: AppBar(
        onPop: studySessionPageController.onSessionPop,
        child: Row(
          spacing: tokens.spaceLayoutGapMd,
          children: [
            Expanded(
              child: ProgressBar(value: controller.getProgressPercentage()),
            ),
            Text(
              '${controller.currentIndex + 1} / ${controller.totalStepCount}',
              style: textStyle.resolve(tokens, [
                TextSize.labelSmall,
                TextWeight.heavy,
                TextColor.muted,
              ]),
            ),
          ],
        ),
      ),
      bottomNavBar: BottomNavBar(
        preferredHeight: 130,
        child: RatingArea(
          studySessionController: controller,
          interactionsController: interactionsController,
        ),
      ),
      inheritMainBottomNavBarHeight: false,
      body: StudySessionCardStage(
        studySessionController: controller,
        interactionsController: interactionsController,
      ),
    );
  }
}

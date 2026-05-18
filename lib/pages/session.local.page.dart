// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/session_page.dart
// PURPOSE: Unified session interface for both Drill and Review modes
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

enum SessionMode { drill, review }

class SessionPage extends HookWidget {
  const SessionPage({super.key, required this.deckId, required this.mode});

  // Drill sessions always require a deckId
  // Nullable becauase: Review sessions can be global (null = all due cards)
  final String? deckId;
  final SessionMode mode;

  @override
  Widget build(BuildContext context) {
    if (deckId == null && mode == SessionMode.drill) {
      throw SessionException;
    }

    final StudySessionController controller;
    final ViewReviewsController? dashboardController;

    if (mode == SessionMode.drill) {
      controller = context.watch<DrillSessionController>();
      dashboardController = null;
    } else {
      controller = context.watch<ReviewSessionController>();
      dashboardController = context.read<ViewReviewsController>();
    }

    final shakeController = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );

    // ── KICK OFF THE SESSION ──────────────────────────────
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mode == SessionMode.drill) {
          final drillCtrl = controller as DrillSessionController;
          if (drillCtrl.session == null) {
            drillCtrl.startSession(deckId!);
          }
        } else {
          final reviewCtrl = controller as ReviewSessionController;
          reviewCtrl.startSession(
            deckId: deckId,
            filter: dashboardController!.dueFilter,
          );
        }
      });
      return null;
    }, [deckId, mode]);

    // ── RECORD STREAK ON REVIEW COMPLETION ───────────────
    useEffect(() {
      if (controller.isComplete && mode == SessionMode.review) {
        context.read<StreakController>().recordActivity(DateTime.now());
      }
      return null;
    }, [controller.isComplete]);

    // 1. Handle Loading (Review only has isLoading, Drill uses null session or missing template)

    // 2. Handle Errors
    if (controller.error != null) {
      return ErrorState(exception: controller.error);
    }

    // 3. Handle Completion
    if (controller.isComplete) {
      if (mode == SessionMode.drill) {
        final drillCtrl = controller as DrillSessionController;
        context.go('/drill/${drillCtrl.session?.id}/result');
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
                FilledButton.icon(
                  onPressed: () {
                    controller.reset();
                    dashboardController?.load();
                    context.pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Dashboard'),
                ),
              ],
            ),
          ),
        );
      }
    }

    // 4. Extract card data
    final template = controller.currentTemplate;
    final reviewCard = controller.currentReviewCard;

    if (template == null || reviewCard == null) {
      return ErrorText(controller.error);
    }

    // 5. The Main UI
    final String appBarTitle = mode == SessionMode.drill
        ? 'Drill Session'
        : '${(controller as ReviewSessionController).remainingCount} remaining';

    SubmissionStyle getSubmissionStyle() {
      if (template is FlashcardTemplate) {
        return SubmissionStyle.showAnswer;
      } else if (template is MultipleChoiceTemplate) {
        return SubmissionStyle.none;
      }

      return SubmissionStyle.submitAnswer;
    }

    return ChangeNotifierProvider(
      key: ValueKey(reviewCard.id),
      create: (_) => SessionInteractionsController(),
      child: HookBuilder(
        builder: (context) {
          final interactionsController = context
              .watch<SessionInteractionsController>();
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: mode == SessionMode.drill
                  ? LinearProgressIndicator(value: controller.progress)
                  : Text(appBarTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    controller.reset();
                    if (mode == SessionMode.review) {
                      dashboardController?.load();
                    }
                    context.pop();
                  },
                ),
              ],
            ),
            bottomNavigationBar: RatingArea(
              answer: interactionsController.answer,
              controller: controller,
              isRevealed: interactionsController.isRevealed,
              submissionStyle: getSubmissionStyle(),
              onSubmit: () => interactionsController.tryAnswer(),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  if (mode == SessionMode.review)
                    LinearProgressIndicator(
                      value: controller.progress,
                      backgroundColor: AppColors.textSecondary.withValues(
                        alpha: 0.1,
                      ),
                    ),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: SessionInteraction(
                            template: template,
                            reviewCard: reviewCard,
                            controller: controller,
                            interactionsController: interactionsController,
                            shakeController: shakeController,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/session_page.dart
// PURPOSE: Unified session interface for both Drill and Review modes
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/pages/drill_result_page.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

enum SessionMode { drill, review }

class SessionPage extends HookWidget {
  const SessionPage({super.key, required this.deckId, required this.mode});

  final String? deckId;
  final SessionMode mode;

  @override
  Widget build(BuildContext context) {
    // Drill sessions always require a deckId; review sessions can be global (null = all due cards)
    if (deckId == null && mode == SessionMode.drill) {
      return const ErrorState(message: 'Deck Id not found');
    }

    final StudySessionController ctrl;
    final ReviewDashboardController? dashboardController;

    if (mode == SessionMode.drill) {
      ctrl = context.watch<DrillSessionController>();
      dashboardController = null;
    } else {
      ctrl = context.watch<ReviewSessionController>();
      dashboardController = context.read<ReviewDashboardController>();
    }

    final shakeController = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );

    // ── KICK OFF THE SESSION ──────────────────────────────
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mode == SessionMode.drill) {
          final drillCtrl = ctrl as DrillSessionController;
          if (drillCtrl.session == null) {
            drillCtrl.startSession(deckId!);
          }
        } else {
          final reviewCtrl = ctrl as ReviewSessionController;
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
      if (ctrl.isComplete && mode == SessionMode.review) {
        final userId = context.read<AuthProvider>().userProfile?.id;
        if (userId != null) {
          context.read<StreakProvider>().recordActivity(userId);
        }
      }
      return null;
    }, [ctrl.isComplete]);

    // 1. Handle Loading (Review only has isLoading, Drill uses null session or missing template)

    // 2. Handle Errors
    if (ctrl.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: AppSpacing.md),
                Text(ctrl.error!, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: () {
                    if (mode == SessionMode.review) {
                      dashboardController?.load();
                    }
                    context.pop();
                  },
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 3. Handle Completion
    if (ctrl.isComplete) {
      if (mode == SessionMode.drill) {
        final drillCtrl = ctrl as DrillSessionController;
        if (drillCtrl.session != null) {
          return DrillResultPage(sessionId: drillCtrl.session!.id);
        }
      } else {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome, size: 80, color: Colors.orange),
                const SizedBox(height: AppSpacing.lg),
                const Text('Deck Finished!'),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: () {
                    ctrl.reset();
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
    final template = ctrl.currentTemplate;
    final reviewCard = ctrl.currentReviewCard;

    if (template == null || reviewCard == null) {
      return ErrorState(message: 'CardTemplate or ReviewCard is null');
    }

    // 5. The Main UI
    final String appBarTitle = mode == SessionMode.drill
        ? 'Drill Session'
        : '${(ctrl as ReviewSessionController).remainingCount} remaining';

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
                  ? LinearProgressIndicator(value: ctrl.progress)
                  : Text(appBarTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    ctrl.reset();
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
              controller: ctrl,
              isRevealed: interactionsController.isRevealed,
              submissionStyle: getSubmissionStyle(),
              onSubmit: () => interactionsController.tryAnswer(),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  if (mode == SessionMode.review)
                    LinearProgressIndicator(
                      value: ctrl.progress,
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
                            controller: ctrl,
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

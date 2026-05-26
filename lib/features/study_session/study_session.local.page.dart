// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/session_page.dart
// PURPOSE: Unified session interface for both Drill and Review modes
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class StudySessionPage extends HookWidget {
  const StudySessionPage({super.key, required this.deckId, required this.mode});

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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          context.go('/drill/${drillCtrl.session?.id}/result');
        });
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
                  onPressed: () {
                    controller.reset();
                    dashboardController?.load();
                    context.pop();
                  },
                  leading: const Icon(Icons.arrow_back),
                  child: const Text('Back to Dashboard'),
                ),
              ],
            ),
          ),
        );
      }
    }

    // 4. Extract card data
    final template = controller.currentTemplate;
    final studyCard = controller.currentStudyCard;

    if (template == null || studyCard == null) {
      return ErrorText(controller.error);
    }

    void closeSession() {
      controller.reset();
      if (mode == SessionMode.review) {
        dashboardController?.load();
      }
      context.pop();
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: SafeArea(
          bottom: false,
          child: StudySessionAppbar(
            controller: controller,
            onClose: closeSession,
          ),
        ),
      ),
      bottomNavigationBar: StudySessionBottomNavBar(
        studySessionController: controller,
        interactionsController: interactionsController,
      ),
      body: SafeArea(
        child: StudySessionCardStage(
          studySessionController: controller,
          interactionsController: interactionsController,
        ),
      ),
    );
  }
}

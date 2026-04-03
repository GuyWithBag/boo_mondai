// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/review_session_page.dart
// PURPOSE: Main FSRS study interface using interactive templates
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class ReviewSessionPage extends HookWidget {
  final String? deckId;
  const ReviewSessionPage({super.key, this.deckId});

  @override
  Widget build(BuildContext context) {
    if (deckId == null) {
      return ErrorState(message: 'Deck Id Not Found');
    }
    final ctrl = context.watch<ReviewSessionController>();
    final shakeController = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );

    // Initialize session on mount
    useEffect(() {
      Future.microtask(() => ctrl.startSession(deckId: deckId));
      return null;
    }, [deckId]);

    if (ctrl.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (ctrl.error != null) {
      return Scaffold(
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
                  onPressed: () => context.pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ── Completion View ──────────────────────────────
    if (ctrl.isComplete) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, size: 80, color: Colors.orange),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Deck Finished!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Your memory has been updated.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton.icon(
                onPressed: () {
                  ctrl.reset();
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

    final currentTemplate = ctrl.currentTemplate;
    final currentReviewCard = ctrl.currentReviewCard;

    if (currentTemplate == null || currentReviewCard == null) {
      return const Scaffold(body: Center(child: Text('Card Data Missing')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${ctrl.remainingCount} remaining'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Linear Progress Indicator
            LinearProgressIndicator(
              value: ctrl.remainingCount == 0
                  ? 1.0
                  : 1 - (ctrl.remainingCount / 100), // Placeholder logic
              backgroundColor: AppColors.textSecondary.withValues(alpha: 0.1),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: QuizInteraction(
                template: currentTemplate,
                reviewCard: currentReviewCard,
                controller: ctrl,
                shakeController: shakeController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

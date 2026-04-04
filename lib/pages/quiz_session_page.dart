// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session_page.dart
// PURPOSE: Main quiz loop shell, progress tracking, and error handling
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/pages/quiz_result_page.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class QuizSessionPage extends HookWidget {
  const QuizSessionPage({super.key, required this.deckId});

  final String? deckId;

  @override
  Widget build(BuildContext context) {
    if (deckId == null) {
      return ErrorState(message: 'Deck Id not found');
    }
    final ctrl = context.watch<QuizSessionPageController>();

    final shakeController = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );

    // ── KICK OFF THE SESSION ──────────────────────────────
    useEffect(() {
      // We use context.read here because we only want to call this once,
      // not every time the controller updates.
      // We wrap it in a post-frame callback to avoid "setState() or markNeedsBuild()
      // called during build" errors from Provider.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ctrl.session == null) {
          ctrl.startSession(deckId!);
        }
      });

      return null;
    }, [deckId]); // Re-run if the route changes to a completely different deck

    // 1. Handle Errors
    if (ctrl.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(ctrl.error!)),
      );
    }

    // 2. Handle Completion (Redirects to Result Page inline)
    if (ctrl.isComplete && ctrl.session != null) {
      return QuizResultPage(sessionId: ctrl.session!.id);
    }

    // 3. Extract our decoupled data
    final template = ctrl.currentTemplate;
    final reviewCard = ctrl.currentReviewCard;

    // 4. Handle Loading State
    if (template == null || reviewCard == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 5. The Main UI
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: LinearProgressIndicator(value: ctrl.progress),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ctrl.reset();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  // You can add your Anki counters (new, learning, due) here!
                  const SizedBox(height: AppSpacing.md),

                  // The interaction router
                  Expanded(
                    child: QuizInteraction(
                      template: template,
                      reviewCard: reviewCard,
                      controller: ctrl,
                      shakeController: shakeController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

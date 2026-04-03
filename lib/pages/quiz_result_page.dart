// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_result_page.dart
// PURPOSE: Display quiz results with score animation and FSRS review prompt
// PROVIDERS: QuizSessionPageController
// HOOKS: useAnimationController, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class QuizResultPage extends HookWidget {
  const QuizResultPage({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<QuizSessionPageController>();
    final session = ctrl.session;

    final scoreAnim = useAnimationController(
      duration: const Duration(milliseconds: 600),
    );

    useEffect(() {
      scoreAnim.forward();
      return null;
    }, const []);

    if (session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Results')),
        body: const Center(child: Text('No session data')),
      );
    }

    void goHome() {
      ctrl.reset();
      context.go('/');
    }

    // 1. Enrolled Count: FSRS now takes everything except auto-graded typos
    final enrolledCount = ctrl.answers
        .where((a) => a.type != QuizAnswerType.incorrect)
        .length;

    // 2. Calculate the detailed breakdown of answers by their type
    final breakdown = <QuizAnswerType, int>{
      for (final type in QuizAnswerType.values) type: 0,
    };
    for (final a in ctrl.answers) {
      breakdown[a.type] = (breakdown[a.type] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.xl),

                  // The new animated breakdown widget
                  ScoreReveal(
                    animation: scoreAnim,
                    breakdown: breakdown,
                    total: session.totalQuestions,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // The list of individual answers
                  if (ctrl.answers.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                        itemCount: ctrl.answers.length,
                        separatorBuilder: (context, i) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, i) {
                          final a = ctrl.answers[i];

                          return AnswerResultTile(
                            userAnswer: a.userAnswer,
                            type: a.type,
                            isEjected: false,
                          );
                        },
                      ),
                    )
                  else
                    const Expanded(
                      child: Center(child: Text('No answers recorded')),
                    ),
                  const SizedBox(height: AppSpacing.md),

                  // The action buttons at the bottom
                  if (enrolledCount > 0)
                    ReviewPrompt(
                      deckId: session.deckId,
                      reviewableNow: 0,
                      reviewLater: enrolledCount,
                      onReviewNow: null,
                      onMaybeLater: goHome,
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: goHome,
                        child: const Text('Done'),
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

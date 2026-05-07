// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_result_page.dart
// PURPOSE: Display quiz results with score animation and FSRS review prompt
// PROVIDERS: DrillSessionController
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

class DrillResultPage extends HookWidget {
  const DrillResultPage({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DrillSessionController>();
    final session = controller.session!;

    final scoreAnim = useAnimationController(
      duration: const Duration(milliseconds: 600),
    );

    useEffect(() {
      scoreAnim.forward();
      return null;
    }, const []);

    void goHome() {
      controller.reset();
      context.go('/');
    }

    // 1. Enrolled Count: FSRS now takes everything except auto-graded typos
    final enrolledCount = controller.answers
        .where((a) => a.type != StudyRating.incorrect)
        .length;

    // 2. Calculate the detailed breakdown of answers by their type
    final breakdown = <StudyRating, int>{
      for (final type in StudyRating.values) type: 0,
    };
    for (final a in controller.answers) {
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
                  if (controller.answers.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                        itemCount: controller.answers.length,
                        separatorBuilder: (context, i) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, i) {
                          final a = controller.answers[i];

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
                      deckId: session.deckId!,
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

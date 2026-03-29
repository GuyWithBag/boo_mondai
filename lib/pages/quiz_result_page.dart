// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_result_page.dart
// PURPOSE: Display quiz results with score animation and FSRS review prompt
// PROVIDERS: QuizProvider
// HOOKS: useAnimationController, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class QuizResultPage extends HookWidget {
  const QuizResultPage({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final session = quiz.session;
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
      quiz.reset();
      context.go('/');
    }

    void goReview() {
      context.go('/review');
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
                  ScoreReveal(
                    animation: scoreAnim,
                    correct: session.correctCount,
                    total: session.totalQuestions,
                    percent: session.scorePercent,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (quiz.answers.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                        itemCount: quiz.answers.length,
                        separatorBuilder: (context, i) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, i) {
                          final a = quiz.answers[i];
                          return AnswerResultTile(
                            userAnswer: a.userAnswer,
                            isCorrect: a.isCorrect,
                            selfRating: a.selfRating,
                            isEjected: quiz.ejectedCardIds.contains(a.cardId),
                          );
                        },
                      ),
                    )
                  else
                    const Expanded(
                      child: Center(child: Text('No answers recorded')),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  if (quiz.enrolledCards.isNotEmpty)
                    ReviewPrompt(
                      deckId: session.deckId,
                      reviewableNow: quiz.reviewableNowCount,
                      reviewLater: quiz.reviewLaterCount,
                      onReviewNow: quiz.reviewableNowCount > 0
                          ? goReview
                          : null,
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

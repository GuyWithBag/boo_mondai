// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_result_page.dart
// PURPOSE: Display quiz results with score animation and answer breakdown
// PROVIDERS: QuizProvider
// HOOKS: useAnimationController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/quiz_provider.dart';
import 'package:boo_mondai/shared/app_spacing.dart';
import 'package:boo_mondai/shared/theme_constants.dart';

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

    final scorePercent = session.scorePercent;
    final answers = quiz.answers;

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
                    percent: scorePercent,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (answers.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                        itemCount: answers.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, i) {
                          final a = answers[i];
                          return AnswerResultTile(
                            userAnswer: a.userAnswer,
                            isCorrect: a.isCorrect,
                            selfRating: a.selfRating,
                          );
                        },
                      ),
                    )
                  else
                    const Expanded(
                      child: Center(child: Text('No answers recorded')),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        quiz.reset();
                        context.go('/');
                      },
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

class ScoreReveal extends StatelessWidget {
  final Animation<double> animation;
  final int correct;
  final int total;
  final double percent;

  const ScoreReveal({
    super.key,
    required this.animation,
    required this.correct,
    required this.total,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final scale = 1.0 + (1.2 - 1.0) * Curves.elasticOut.transform(animation.value);
        final displayCount = (correct * animation.value).round();
        return Transform.scale(
          scale: animation.value < 1.0 ? scale : 1.0,
          child: Column(
            children: [
              Text(
                '$displayCount / $total',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: percent >= 0.7
                          ? AppColors.correct
                          : percent >= 0.4
                              ? AppColors.hard
                              : AppColors.incorrect,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${(percent * 100).round()}% correct',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        );
      },
    );
  }
}

class AnswerResultTile extends StatelessWidget {
  final String userAnswer;
  final bool isCorrect;
  final int? selfRating;

  const AnswerResultTile({
    super.key,
    required this.userAnswer,
    required this.isCorrect,
    this.selfRating,
  });

  String get _ratingLabel {
    switch (selfRating) {
      case 1:
        return 'Again';
      case 2:
        return 'Hard';
      case 3:
        return 'Good';
      case 4:
        return 'Easy';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          isCorrect ? Icons.check_circle : Icons.cancel,
          color: isCorrect ? AppColors.correct : AppColors.incorrect,
        ),
        title: Text(userAnswer),
        trailing: selfRating != null
            ? Chip(label: Text(_ratingLabel))
            : null,
      ),
    );
  }
}

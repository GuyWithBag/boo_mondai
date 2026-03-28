// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_result_page.dart
// PURPOSE: Display quiz results with score animation and FSRS review prompt
// PROVIDERS: QuizProvider, DeckProvider
// HOOKS: useAnimationController, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';

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
                            isEjected:
                                quiz.ejectedCardIds.contains(a.cardId),
                          );
                        },
                      ),
                    )
                  else
                    const Expanded(
                        child: Center(child: Text('No answers recorded'))),
                  const SizedBox(height: AppSpacing.md),
                  if (quiz.enrolledCards.isNotEmpty)
                    _ReviewPrompt(
                      deckId: session.deckId,
                      reviewableNow: quiz.reviewableNowCount,
                      reviewLater: quiz.reviewLaterCount,
                      onReviewNow: quiz.reviewableNowCount > 0 ? goReview : null,
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

// ── Review prompt ─────────────────────────────────────────────────────────────

class _ReviewPrompt extends StatelessWidget {
  const _ReviewPrompt({
    required this.deckId,
    required this.reviewableNow,
    required this.reviewLater,
    required this.onReviewNow,
    required this.onMaybeLater,
  });

  final String deckId;
  final int reviewableNow;
  final int reviewLater;
  final VoidCallback? onReviewNow;
  final VoidCallback onMaybeLater;

  @override
  Widget build(BuildContext context) {
    final deckProvider = context.read<DeckProvider>();
    final deck = [
      ...deckProvider.decks,
      ...deckProvider.userDecks,
    ].where((d) => d.id == deckId).firstOrNull;
    final deckTitle = deck?.title ?? 'Your deck';

    return Card(
      color: AppColors.primary.withValues(alpha: 0.06),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              const Icon(Icons.schedule, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'Cards enrolled in FSRS',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.primary),
              ),
            ]),
            const SizedBox(height: AppSpacing.sm),
            _DeckReviewRow(
              deckTitle: deckTitle,
              reviewableNow: reviewableNow,
              reviewLater: reviewLater,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onMaybeLater,
                  child: const Text('Maybe Later'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onReviewNow,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Review Now'),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _DeckReviewRow extends StatelessWidget {
  const _DeckReviewRow({
    required this.deckTitle,
    required this.reviewableNow,
    required this.reviewLater,
  });

  final String deckTitle;
  final int reviewableNow;
  final int reviewLater;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            deckTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        if (reviewableNow > 0)
          _ReviewBadge(
            label: '$reviewableNow ready',
            color: AppColors.correct,
          ),
        if (reviewableNow > 0 && reviewLater > 0)
          const SizedBox(width: 4),
        if (reviewLater > 0)
          Tooltip(
            message: 'These cards were moved to FSRS review',
            child: _ReviewBadge(
              label: '$reviewLater later',
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }
}

class _ReviewBadge extends StatelessWidget {
  const _ReviewBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadii.badge),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ── Score reveal ──────────────────────────────────────────────────────────────

class ScoreReveal extends StatelessWidget {
  const ScoreReveal({
    super.key,
    required this.animation,
    required this.correct,
    required this.total,
    required this.percent,
  });

  final Animation<double> animation;
  final int correct;
  final int total;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final scale =
            1.0 + (1.2 - 1.0) * Curves.elasticOut.transform(animation.value);
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

// ── Answer result tile ────────────────────────────────────────────────────────

class AnswerResultTile extends StatelessWidget {
  const AnswerResultTile({
    super.key,
    required this.userAnswer,
    required this.isCorrect,
    this.selfRating,
    this.isEjected = false,
  });

  final String userAnswer;
  final bool isCorrect;
  final int? selfRating;
  final bool isEjected;

  String get _ratingLabel => switch (selfRating) {
        1 => 'Again',
        2 => 'Hard',
        3 => 'Good',
        4 => 'Easy',
        _ => '',
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          isCorrect ? Icons.check_circle : Icons.cancel,
          color: isCorrect ? AppColors.correct : AppColors.incorrect,
        ),
        title: Text(userAnswer.isEmpty ? '(no answer)' : userAnswer),
        trailing: isEjected
            ? Tooltip(
                message: 'This card was moved to FSRS review',
                child: Chip(
                  label: const Text('Review Later'),
                  backgroundColor:
                      AppColors.hard.withValues(alpha: 0.12),
                  labelStyle: const TextStyle(
                      color: AppColors.hard, fontSize: 11),
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                ),
              )
            : selfRating != null
                ? Chip(label: Text(_ratingLabel))
                : null,
      ),
    );
  }
}

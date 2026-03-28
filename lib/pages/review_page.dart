// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/review_page.dart
// PURPOSE: FSRS review session — flip cards, rate recall, upcoming card countdown
// PROVIDERS: FsrsProvider, StreakProvider, AuthProvider
// HOOKS: useAnimationController, useEffect, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/widgets/widgets.dart';

class ReviewPage extends HookWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final fsrs = context.watch<FsrsProvider>();
    final userId = auth.userProfile?.id;

    final flipController =
        useAnimationController(duration: const Duration(milliseconds: 400));
    final isFlipped = useState(false);
    // Ticker increments every second to drive countdown re-renders.
    final tick = useState(0);

    useEffect(() {
      if (userId != null) {
        Future.microtask(() {
          if (context.mounted) {
            context.read<FsrsProvider>().fetchDueCards(userId);
          }
        });
      }
      return null;
    }, [userId]);

    // Start ticker only when there are upcoming cards to count down.
    useEffect(() {
      if (fsrs.upcomingCards.isEmpty) return null;
      final timer =
          Timer.periodic(const Duration(seconds: 1), (_) => tick.value++);
      return timer.cancel;
    }, [fsrs.upcomingCards.length]);

    if (fsrs.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (fsrs.isReviewComplete && fsrs.upcomingCards.isEmpty) {
      return const _AllCaughtUp();
    }

    if (fsrs.isReviewComplete && fsrs.upcomingCards.isNotEmpty) {
      return _UpcomingOnlyView(
          upcomingCards: fsrs.upcomingCards, tick: tick.value);
    }

    final deckCard = fsrs.currentDeckCard;
    final fsrsCard = fsrs.currentReviewCard;
    if (deckCard == null || fsrsCard == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    void flip() {
      if (isFlipped.value) {
        flipController.reverse();
      } else {
        flipController.forward();
      }
      isFlipped.value = !isFlipped.value;
    }

    Future<void> rate(int rating) async {
      isFlipped.value = false;
      flipController.reset();
      final fsrsProvider = context.read<FsrsProvider>();
      final streakProvider = context.read<StreakProvider>();
      await fsrsProvider.submitReview(rating);
      if (userId != null) {
        await streakProvider.recordActivity(userId);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Review (${fsrs.dueCount} remaining)'),
      ),
      body: SafeArea(
        child: Shortcuts(
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.space): ActivateIntent()
          },
          child: Actions(
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(
                  onInvoke: (_) => flip()),
            },
            child: Focus(
              autofocus: true,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _FsrsStateBadge(state: fsrsCard.state),
                        const SizedBox(height: AppSpacing.sm),
                        Expanded(
                          child: GestureDetector(
                            onTap: flip,
                            child: _FlipCard(
                              controller: flipController,
                              deckCard: deckCard,
                            ),
                          ),
                        ),
                        if (isFlipped.value) ...[
                          const SizedBox(height: AppSpacing.md),
                          SelfRatingButtons(onRate: rate),
                        ] else
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Text(
                              'Tap to reveal • Space',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: AppColors.textSecondary),
                            ),
                          ),
                        if (fsrs.upcomingCards.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.sm),
                          _UpcomingCount(count: fsrs.upcomingCards.length),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Flip card ─────────────────────────────────────────────────────────────────

class _FlipCard extends StatelessWidget {
  const _FlipCard({required this.controller, required this.deckCard});

  final AnimationController controller;
  final DeckCard deckCard;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final angle = controller.value * pi;
        final isFront = angle < pi / 2;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: isFront
              ? QuizQuestionCard(
                  question: deckCard.question,
                  imageUrl: deckCard.questionImageUrl,
                )
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: ReviewCardBack(
                    answer: deckCard.answer,
                    imageUrl: deckCard.answerImageUrl,
                  ),
                ),
        );
      },
    );
  }
}

// ── FSRS state badge ──────────────────────────────────────────────────────────

class _FsrsStateBadge extends StatelessWidget {
  const _FsrsStateBadge({required this.state});

  final int state;

  Color get _color => switch (state) {
        0 => AppColors.easy,
        2 => AppColors.correct,
        _ => AppColors.incorrect,
      };

  String get _label => switch (state) {
        0 => 'New',
        1 => 'Learning',
        2 => 'Review',
        3 => 'Relearning',
        _ => '',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadii.badge),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Text(
        _label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: _color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ── Upcoming count pill ───────────────────────────────────────────────────────

class _UpcomingCount extends StatelessWidget {
  const _UpcomingCount({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$count more card${count == 1 ? '' : 's'} coming later',
      style: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(color: AppColors.textSecondary),
    );
  }
}

// ── All-caught-up state ───────────────────────────────────────────────────────

class _AllCaughtUp extends StatelessWidget {
  const _AllCaughtUp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 64, color: AppColors.correct),
            const SizedBox(height: AppSpacing.md),
            Text("You're all caught up!",
                style: Theme.of(context).textTheme.headlineMedium),
            Text('No cards due for review',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

// ── Upcoming-only view (all reviewable done, locked cards remain) ─────────────

class _UpcomingOnlyView extends StatelessWidget {
  const _UpcomingOnlyView(
      {required this.upcomingCards, required this.tick});

  final List<FsrsCardState> upcomingCards;
  final int tick; // causes rebuild every second for live countdown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _AllDoneHeader(),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Coming up',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: ListView.separated(
                      itemCount: upcomingCards.length,
                      separatorBuilder: (context, i) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, i) {
                        final card = upcomingCards[i];
                        return _UpcomingCardTile(
                            fsrsCard: card, tick: tick);
                      },
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

class _AllDoneHeader extends StatelessWidget {
  const _AllDoneHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle,
            size: 28, color: AppColors.correct),
        const SizedBox(width: AppSpacing.sm),
        Text(
          "All caught up for now!",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: AppColors.correct),
        ),
      ],
    );
  }
}

class _UpcomingCardTile extends StatelessWidget {
  const _UpcomingCardTile({required this.fsrsCard, required this.tick});

  final FsrsCardState fsrsCard;
  final int tick; // unused value but causes rebuild

  String _formatDue(DateTime due) {
    final now = DateTime.now();
    final diff = due.difference(now);
    if (diff.isNegative) return 'Overdue since ${_fmt(diff.abs())}';
    return 'Due in ${_fmt(diff)}';
  }

  String _fmt(Duration d) {
    final days = d.inDays;
    final hours = d.inHours.remainder(24);
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: _FsrsStateBadge(state: fsrsCard.state),
        title: Text(
          fsrsCard.cardId,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textSecondary),
        ),
        trailing: Text(
          _formatDue(fsrsCard.due),
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

// ── Review card back ──────────────────────────────────────────────────────────

class ReviewCardBack extends StatelessWidget {
  const ReviewCardBack({super.key, required this.answer, this.imageUrl});

  final String answer;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageUrl != null) ...[
                Image.network(imageUrl!, height: 120),
                const SizedBox(height: AppSpacing.md),
              ],
              Text(
                answer,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/review_page.dart
// PURPOSE: FSRS review session — flip cards, rate recall, upcoming card countdown
// PROVIDERS: FsrsProvider, StreakProvider, AuthProvider
// HOOKS: useAnimationController, useEffect, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/widgets/widgets.dart';
import 'package:boo_mondai/pages/review/flip_card.dart';
import 'package:boo_mondai/pages/review/upcoming_count.dart';
import 'package:boo_mondai/pages/review/all_caught_up.dart';
import 'package:boo_mondai/pages/review/upcoming_only_view.dart';

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
      return const AllCaughtUp();
    }

    if (fsrs.isReviewComplete && fsrs.upcomingCards.isNotEmpty) {
      return UpcomingOnlyView(
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
                        StatusBadge.fsrsState(state: fsrsCard.state),
                        const SizedBox(height: AppSpacing.sm),
                        Expanded(
                          child: GestureDetector(
                            onTap: flip,
                            child: FlipCard(
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
                          UpcomingCount(count: fsrs.upcomingCards.length),
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

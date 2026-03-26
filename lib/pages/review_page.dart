// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/review_page.dart
// PURPOSE: FSRS review session — flip cards and rate recall
// PROVIDERS: FsrsProvider, StreakProvider, AuthProvider
// HOOKS: useAnimationController, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/auth_provider.dart';
import 'package:boo_mondai/providers/fsrs_provider.dart';
import 'package:boo_mondai/providers/streak_provider.dart';
import 'package:boo_mondai/shared/app_spacing.dart';
import 'package:boo_mondai/shared/theme_constants.dart';
import 'package:boo_mondai/widgets/quiz_question_card.dart';
import 'package:boo_mondai/widgets/self_rating_bottom_sheet.dart';

class ReviewPage extends HookWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final fsrs = context.watch<FsrsProvider>();
    final userId = auth.userProfile?.id;
    final flipController = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );
    final isFlipped = useState(false);

    useEffect(() {
      if (userId != null) {
        Future.microtask(() {
          context.read<FsrsProvider>().fetchDueCards(userId);
        });
      }
      return null;
    }, [userId]);

    if (fsrs.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (fsrs.isReviewComplete || fsrs.dueCount == 0) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 64, color: AppColors.correct),
              const SizedBox(height: AppSpacing.md),
              Text(
                "You're all caught up!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'No cards due for review',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    final deckCard = fsrs.currentDeckCard;
    if (deckCard == null) {
      return const Scaffold(
        body: Center(child: Text('Loading card...')),
      );
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
      await context.read<FsrsProvider>().submitReview(rating);
      if (userId != null) {
        await context.read<StreakProvider>().recordActivity(userId);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Review (${fsrs.dueCount} remaining)'),
      ),
      body: SafeArea(
        child: Shortcuts(
          shortcuts: {
            const SingleActivator(LogicalKeyboardKey.space): const ActivateIntent(),
          },
          child: Actions(
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) => flip(),
              ),
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
                        Expanded(
                          child: GestureDetector(
                            onTap: flip,
                            child: AnimatedBuilder(
                              animation: flipController,
                              builder: (context, child) {
                                final angle = flipController.value * pi;
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
                                          transform: Matrix4.identity()
                                            ..rotateY(pi),
                                          child: ReviewCardBack(
                                            answer: deckCard.answer,
                                            imageUrl: deckCard.answerImageUrl,
                                          ),
                                        ),
                                );
                              },
                            ),
                          ),
                        ),
                        if (isFlipped.value) ...[
                          const SizedBox(height: AppSpacing.md),
                          SelfRatingButtons(onRate: (r) => rate(r)),
                        ] else
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Text(
                              'Tap to reveal',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
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

class ReviewCardBack extends StatelessWidget {
  final String answer;
  final String? imageUrl;
  const ReviewCardBack({super.key, required this.answer, this.imageUrl});

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


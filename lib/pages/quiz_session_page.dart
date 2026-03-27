// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session_page.dart
// PURPOSE: Active quiz session — answer input, correctness check, self-rating
// PROVIDERS: QuizProvider, CardProvider, AuthProvider
// HOOKS: useTextEditingController, useAnimationController, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/widgets/widgets.dart';

class QuizSessionPage extends HookWidget {
  const QuizSessionPage({super.key, required this.deckId});

  final String deckId;

  @override
  Widget build(BuildContext context) {
    final answerController = useTextEditingController();
    final quiz = context.watch<QuizProvider>();
    final cardProvider = context.read<CardProvider>();
    final auth = context.read<AuthProvider>();
    final shakeController = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );
    final cardTransition = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    // Start session if not already started
    useEffect(() {
      if (quiz.session == null && !quiz.isLoading) {
        final userId = auth.userProfile?.id;
        if (userId != null) {
          Future.microtask(() {
            context.read<QuizProvider>().startSession(
                  deckId,
                  userId,
                  cardProvider.cards,
                  false,
                );
          });
        }
      }
      return null;
    }, const []);

    // Navigate to results when complete
    useEffect(() {
      if (quiz.isComplete && quiz.session != null) {
        Future.microtask(() {
          if (context.mounted) {
            context.go('/quiz/${quiz.session!.id}/result');
          }
        });
      }
      return null;
    }, [quiz.isComplete]);

    if (quiz.isLoading && quiz.currentCard == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final card = quiz.currentCard;
    if (card == null) {
      return const Scaffold(
        body: Center(child: Text('No cards')),
      );
    }

    void submitAnswer() {
      final answer = answerController.text.trim();
      if (answer.isEmpty) return;

      final isCorrect = card.checkAnswer(answer);
      if (!isCorrect) {
        shakeController.forward(from: 0);
      }
      context.read<QuizProvider>().submitAnswer(answer);
      answerController.clear();
    }

    void submitRating(int rating) {
      cardTransition.forward(from: 0);
      context.read<QuizProvider>().submitSelfRating(rating);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz (${quiz.queueLength} left)'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            quiz.reset();
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  LinearProgressIndicator(value: quiz.progress),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: shakeController,
                      builder: (context, child) {
                        final dx = sin(shakeController.value * pi * 3) * 4;
                        return Transform.translate(
                          offset: Offset(dx, 0),
                          child: child,
                        );
                      },
                      child: QuizQuestionCard(
                        question: card.question,
                        imageUrl: card.questionImageUrl,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (quiz.awaitingRating)
                    SelfRatingButtons(
                      onRate: submitRating,
                      promptText: 'Correct! How well did you know it?',
                    )
                  else
                    AnswerInput(
                      controller: answerController,
                      onSubmit: submitAnswer,
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

class AnswerInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const AnswerInput({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        const SingleActivator(LogicalKeyboardKey.enter): const ActivateIntent(),
      },
      child: Actions(
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) => onSubmit(),
          ),
        },
        child: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Type your answer...',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: onSubmit,
            ),
          ),
          onSubmitted: (_) => onSubmit(),
        ),
      ),
    );
  }
}


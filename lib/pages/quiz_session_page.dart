// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session_page.dart
// PURPOSE: Active quiz session — 6 question type UIs, 3-strike tracking, Anki counter
// PROVIDERS: QuizProvider, CardProvider, AuthProvider
// HOOKS: useAnimationController, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/widgets/widgets.dart';
import 'package:boo_mondai/pages/quiz_session/anki_counter.dart';
import 'package:boo_mondai/pages/quiz_session/strike_chip.dart';
import 'package:boo_mondai/pages/quiz_session/quiz_interaction.dart';
import 'package:boo_mondai/pages/quiz_session/first_pass_screen.dart';

class QuizSessionPage extends HookWidget {
  const QuizSessionPage({super.key, required this.deckId});

  final String deckId;

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final cardProvider = context.read<CardProvider>();
    final auth = context.read<AuthProvider>();
    final shakeController =
        useAnimationController(duration: const Duration(milliseconds: 400));

    useEffect(() {
      if (quiz.session == null && !quiz.isLoading) {
        final userId = auth.userProfile?.id;
        if (userId != null) {
          Future.microtask(() {
                if (context.mounted) {
                  context.read<QuizProvider>().startSession(
                        deckId,
                        userId,
                        cardProvider.cards,
                        false,
                      );
                }
              });
        }
      }
      return null;
    }, const []);

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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (quiz.showingFirstPassComplete) {
      return FirstPassScreen(
        incorrectCount: quiz.queueLength,
        onContinue: () => context.read<QuizProvider>().acknowledgeFirstPass(),
      );
    }

    final card = quiz.currentCard;
    if (card == null) {
      return const Scaffold(body: Center(child: Text('No cards')));
    }

    Future<bool> confirmDiscard() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Discard Current Session?'),
          content: const Text(
              'Your progress will be lost. Are you sure you want to quit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Keep Going'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(ctx).colorScheme.error),
              child: const Text('Discard'),
            ),
          ],
        ),
      );
      return confirmed ?? false;
    }

    void onDiscard() async {
      final discard = await confirmDiscard();
      if (discard && context.mounted) {
        context.read<QuizProvider>().reset();
        context.go('/');
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        onDiscard();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Quit quiz',
              onPressed: onDiscard),
          title: AnkiCounter(
            newCount: quiz.newCount,
            learningCount: quiz.learningCount,
            reviewCount: quiz.reviewCount,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(value: quiz.progress),
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
                    if (quiz.currentCardStrikeCount > 0)
                      StrikeChip(
                          strikes: quiz.currentCardStrikeCount,
                          max: 3),
                    const SizedBox(height: AppSpacing.sm),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: shakeController,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(
                              sin(shakeController.value * pi * 3) * 4, 0),
                          child: child,
                        ),
                        child: QuizQuestionCard(
                          question: card.question,
                          imageUrl: card.questionImageUrl,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    QuizInteraction(
                      card: card,
                      quiz: quiz,
                      shakeController: shakeController,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

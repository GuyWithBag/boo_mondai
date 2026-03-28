// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session_page.dart
// PURPOSE: Active quiz session — 6 question type UIs, 3-strike tracking, Anki counter
// PROVIDERS: QuizProvider, CardProvider, AuthProvider
// HOOKS: useAnimationController, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/widgets/widgets.dart';

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
      return _FirstPassScreen(
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
          title: _AnkiCounter(
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
                      _StrikeChip(
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
                    _QuizInteraction(
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

// ── Anki-style FSRS counter ──────────────────────────────────────────────────

class _AnkiCounter extends StatelessWidget {
  const _AnkiCounter({
    required this.newCount,
    required this.learningCount,
    required this.reviewCount,
  });

  final int newCount;
  final int learningCount;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CountBadge(label: '$newCount', color: AppColors.easy),
        const SizedBox(width: AppSpacing.sm),
        _CountBadge(label: '$learningCount', color: AppColors.incorrect),
        const SizedBox(width: AppSpacing.sm),
        _CountBadge(label: '$reviewCount', color: AppColors.correct),
      ],
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
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

// ── Strike chip ──────────────────────────────────────────────────────────────

class _StrikeChip extends StatelessWidget {
  const _StrikeChip({required this.strikes, required this.max});

  final int strikes;
  final int max;

  @override
  Widget build(BuildContext context) {
    final isLast = strikes >= max - 1;
    final color = isLast ? AppColors.incorrect : AppColors.hard;
    return Chip(
      label: Text('Attempt ${strikes + 1} / $max'),
      labelStyle: Theme.of(context)
          .textTheme
          .labelSmall
          ?.copyWith(color: color, fontWeight: FontWeight.bold),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
      visualDensity: VisualDensity.compact,
    );
  }
}

// ── Interaction dispatcher ────────────────────────────────────────────────────

class _QuizInteraction extends StatelessWidget {
  const _QuizInteraction({
    required this.card,
    required this.quiz,
    required this.shakeController,
  });

  final DeckCard card;
  final QuizProvider quiz;
  final AnimationController shakeController;

  @override
  Widget build(BuildContext context) {
    if (quiz.awaitingRating) {
      return _RatingArea(card: card, quiz: quiz);
    }
    return switch (card.questionType) {
      QuestionType.flashcard => _FlashcardInteraction(
          card: card, quiz: quiz),
      QuestionType.identification => _IdentificationInteraction(
          card: card, quiz: quiz, shakeController: shakeController),
      QuestionType.multipleChoice => _MultipleChoiceInteraction(
          card: card, quiz: quiz, shakeController: shakeController),
      QuestionType.fillInTheBlanks => _FitbInteraction(
          card: card, quiz: quiz, shakeController: shakeController),
      QuestionType.wordScramble => _WordScrambleInteraction(
          card: card, quiz: quiz, shakeController: shakeController),
      QuestionType.matchMadness => _MatchMadnessInteraction(
          card: card, quiz: quiz),
    };
  }
}

// ── Shared rating area ────────────────────────────────────────────────────────

class _RatingArea extends StatelessWidget {
  const _RatingArea({required this.card, required this.quiz});

  final DeckCard card;
  final QuizProvider quiz;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (card.questionType == QuestionType.identification) ...[
          _IdentificationFeedback(card: card, quiz: quiz),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (card.questionType == QuestionType.flashcard)
          _FlashcardAnswer(card: card),
        SelfRatingButtons(
          promptText: 'How well did you know it?',
          onRate: (r) => context.read<QuizProvider>().submitSelfRating(r),
        ),
      ],
    );
  }
}

class _FlashcardAnswer extends StatelessWidget {
  const _FlashcardAnswer({required this.card});
  final DeckCard card;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.correct.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text(
          card.answer,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: AppColors.correct),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _IdentificationFeedback extends StatelessWidget {
  const _IdentificationFeedback({required this.card, required this.quiz});
  final DeckCard card;
  final QuizProvider quiz;

  @override
  Widget build(BuildContext context) {
    final wrong = quiz.lastAnswerWrong;
    final color = wrong ? AppColors.incorrect : AppColors.correct;
    return Card(
      color: color.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              Icon(wrong ? Icons.close : Icons.check, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                wrong ? 'Incorrect' : 'Correct!',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: color),
              ),
            ]),
            if (wrong) ...[
              const SizedBox(height: 4),
              Text(
                'Accepted: ${card.acceptedIdentificationAnswers.join(', ')}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Flashcard ─────────────────────────────────────────────────────────────────

class _FlashcardInteraction extends StatelessWidget {
  const _FlashcardInteraction({required this.card, required this.quiz});
  final DeckCard card;
  final QuizProvider quiz;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: const {SingleActivator(LogicalKeyboardKey.space): ActivateIntent()},
      child: Actions(
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) =>
                  context.read<QuizProvider>().revealAnswer()),
        },
        child: SizedBox(
          width: double.infinity,
          child: Tooltip(
            message: 'Press Space',
            child: FilledButton.icon(
              onPressed: () => context.read<QuizProvider>().revealAnswer(),
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('Show Answer'),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Identification ────────────────────────────────────────────────────────────

class _IdentificationInteraction extends HookWidget {
  const _IdentificationInteraction({
    required this.card,
    required this.quiz,
    required this.shakeController,
  });
  final DeckCard card;
  final QuizProvider quiz;
  final AnimationController shakeController;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    void submit() {
      final answer = controller.text.trim();
      if (answer.isEmpty) return;
      final isCorrect = card.checkAnswer(answer);
      if (!isCorrect) shakeController.forward(from: 0);
      context.read<QuizProvider>().submitIdentificationAnswer(answer);
      controller.clear();
    }

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent()
      },
      child: Actions(
        actions: {
          ActivateIntent:
              CallbackAction<ActivateIntent>(onInvoke: (_) => submit()),
        },
        child: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Type your answer...',
            suffixIcon:
                IconButton(icon: const Icon(Icons.send), onPressed: submit),
          ),
          onSubmitted: (_) => submit(),
        ),
      ),
    );
  }
}

// ── Multiple Choice ───────────────────────────────────────────────────────────

class _MultipleChoiceInteraction extends HookWidget {
  const _MultipleChoiceInteraction({
    required this.card,
    required this.quiz,
    required this.shakeController,
  });
  final DeckCard card;
  final QuizProvider quiz;
  final AnimationController shakeController;

  @override
  Widget build(BuildContext context) {
    final selected = useState<String?>(null);

    void onTap(MultipleChoiceOption option) async {
      if (selected.value != null) return;
      selected.value = option.id;
      if (!option.isCorrect) shakeController.forward(from: 0);
      await Future<void>.delayed(const Duration(milliseconds: 800));
      if (context.mounted) {
        await context.read<QuizProvider>().submitAnswer(option.optionText);
        selected.value = null;
      }
    }

    final options = card.options;
    final correctId =
        options.firstWhere((o) => o.isCorrect, orElse: () => options.first).id;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: options.map((option) {
        final isSelected = selected.value == option.id;
        final hasSelection = selected.value != null;

        Color? bg;
        if (hasSelection) {
          if (option.id == correctId) {
            bg = AppColors.correct.withValues(alpha: 0.15);
          } else if (isSelected) {
            bg = AppColors.incorrect.withValues(alpha: 0.15);
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: hasSelection ? null : () => onTap(option),
              style: FilledButton.styleFrom(
                backgroundColor: bg ?? AppColors.surfaceVariant,
                foregroundColor: AppColors.textPrimary,
                disabledBackgroundColor: bg ?? AppColors.surfaceVariant,
                disabledForegroundColor: hasSelection && option.id == correctId
                    ? AppColors.correct
                    : hasSelection && isSelected
                        ? AppColors.incorrect
                        : AppColors.textSecondary,
              ),
              child: Text(option.optionText),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Fill in the Blanks ────────────────────────────────────────────────────────

class _FitbInteraction extends HookWidget {
  const _FitbInteraction({
    required this.card,
    required this.quiz,
    required this.shakeController,
  });
  final DeckCard card;
  final QuizProvider quiz;
  final AnimationController shakeController;

  @override
  Widget build(BuildContext context) {
    final segments = card.segments;
    final controllers = useMemoized(
      () => List.generate(segments.length, (_) => TextEditingController()),
      [card.id],
    );
    useEffect(() {
      return () {
        for (final c in controllers) {
          c.dispose();
        }
      };
    }, [controllers]);

    void submit() {
      final answers = controllers.map((c) => c.text.trim()).toList();
      if (answers.any((a) => a.isEmpty)) return;
      final allOk = List.generate(
        segments.length,
        (i) => segments[i].checkAnswer(answers[i]),
      ).every((ok) => ok);
      if (!allOk) shakeController.forward(from: 0);
      context.read<QuizProvider>().submitFitbAnswers(answers);
      for (final c in controllers) {
        c.clear();
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(segments.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: TextField(
              controller: controllers[i],
              autofocus: i == 0,
              decoration: InputDecoration(
                hintText: segments[i].displayText,
                labelText: 'Blank ${i + 1}',
              ),
              onSubmitted: (_) {
                if (i < segments.length - 1) {
                  controllers[i + 1].selection = TextSelection.fromPosition(
                    TextPosition(
                        offset: controllers[i + 1].text.length),
                  );
                } else {
                  submit();
                }
              },
            ),
          );
        }),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: submit,
            icon: const Icon(Icons.check),
            label: const Text('Submit'),
          ),
        ),
      ],
    );
  }
}

// ── Word Scramble ─────────────────────────────────────────────────────────────

class _WordScrambleInteraction extends HookWidget {
  const _WordScrambleInteraction({
    required this.card,
    required this.quiz,
    required this.shakeController,
  });
  final DeckCard card;
  final QuizProvider quiz;
  final AnimationController shakeController;

  @override
  Widget build(BuildContext context) {
    final shuffled = useMemoized(
      () {
        final words = card.question.split(' ');
        words.shuffle(Random());
        return words;
      },
      [card.id],
    );
    final placed = useState<List<String>>([]);
    final remaining = useState<List<String>>(List.from(shuffled));

    void tapRemaining(int index) {
      final word = remaining.value[index];
      remaining.value = List.from(remaining.value)..removeAt(index);
      placed.value = [...placed.value, word];
    }

    void tapPlaced(int index) {
      final word = placed.value[index];
      placed.value = List.from(placed.value)..removeAt(index);
      remaining.value = [...remaining.value, word];
    }

    void submit() {
      final answer = placed.value.join(' ');
      if (placed.value.isEmpty) return;
      final isCorrect = card.checkAnswer(answer);
      if (!isCorrect) shakeController.forward(from: 0);
      context.read<QuizProvider>().submitAnswer(answer);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WordChipArea(
          label: 'Your answer',
          chips: placed.value,
          onTap: tapPlaced,
          minHeight: 48,
        ),
        const SizedBox(height: AppSpacing.sm),
        _WordChipArea(
          label: 'Word bank',
          chips: remaining.value,
          onTap: tapRemaining,
          chipColor: AppColors.surfaceVariant,
          minHeight: 48,
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: placed.value.isEmpty ? null : submit,
            icon: const Icon(Icons.check),
            label: const Text('Submit'),
          ),
        ),
      ],
    );
  }
}

class _WordChipArea extends StatelessWidget {
  const _WordChipArea({
    required this.label,
    required this.chips,
    required this.onTap,
    this.chipColor,
    this.minHeight = 40,
  });

  final String label;
  final List<String> chips;
  final void Function(int index) onTap;
  final Color? chipColor;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(AppRadii.input),
            ),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: List.generate(
                chips.length,
                (i) => GestureDetector(
                  onTap: () => onTap(i),
                  child: Chip(
                    label: Text(chips[i]),
                    backgroundColor:
                        chipColor ?? AppColors.primary.withValues(alpha: 0.12),
                    side: BorderSide.none,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Match Madness ─────────────────────────────────────────────────────────────

class _MatchMadnessInteraction extends HookWidget {
  const _MatchMadnessInteraction({required this.card, required this.quiz});
  final DeckCard card;
  final QuizProvider quiz;

  @override
  Widget build(BuildContext context) {
    final pairs = card.pairs;
    final selectedTerm = useState<String?>(null);
    final matched = useState<Set<String>>({});

    void onTermTap(String pairId) {
      if (matched.value.contains(pairId)) return;
      selectedTerm.value = pairId;
    }

    void onMatchTap(String pairId) {
      if (matched.value.contains(pairId)) return;
      if (selectedTerm.value == pairId) {
        matched.value = {...matched.value, pairId};
        selectedTerm.value = null;
        if (matched.value.length == pairs.length) {
          context.read<QuizProvider>().revealAnswer();
        }
      } else {
        selectedTerm.value = null;
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Match all pairs',
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...pairs.map((pair) {
          final isMatched = matched.value.contains(pair.id);
          final isSelected = selectedTerm.value == pair.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: _MatchTile(
                    label: pair.term,
                    isMatched: isMatched,
                    isSelected: isSelected,
                    onTap: () => onTermTap(pair.id),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  isMatched ? Icons.link : Icons.link_off,
                  color: isMatched
                      ? AppColors.correct
                      : AppColors.textSecondary.withValues(alpha: 0.3),
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _MatchTile(
                    label: pair.match,
                    isMatched: isMatched,
                    isSelected: isSelected,
                    onTap: () => onMatchTap(pair.id),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _MatchTile extends StatelessWidget {
  const _MatchTile({
    required this.label,
    required this.isMatched,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isMatched;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color;
    if (isMatched) {
      color = AppColors.correct;
    } else if (isSelected) {
      color = AppColors.primary;
    } else {
      color = AppColors.textSecondary;
    }

    return GestureDetector(
      onTap: isMatched ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(AppRadii.button),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: color),
        ),
      ),
    );
  }
}

// ── First-pass complete ───────────────────────────────────────────────────────

class _FirstPassScreen extends StatelessWidget {
  const _FirstPassScreen(
      {required this.incorrectCount, required this.onContinue});

  final int incorrectCount;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events_outlined,
                    size: 72, color: theme.colorScheme.primary),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Nice try!',
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  "You've seen every card once.\nNow let's review the "
                  '$incorrectCount card${incorrectCount == 1 ? '' : 's'} '
                  'you missed until you get them right.',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton.icon(
                  onPressed: onContinue,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Keep Going'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

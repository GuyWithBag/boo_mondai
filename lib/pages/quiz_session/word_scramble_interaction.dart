// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/word_scramble_interaction.dart
// PURPOSE: Word scramble interaction with drag-to-order word chips
// PROVIDERS: QuizProvider
// HOOKS: useMemoized, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/pages/quiz_session/word_chip_area.dart';

class WordScrambleInteraction extends HookWidget {
  const WordScrambleInteraction({
    super.key,
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
        WordChipArea(
          label: 'Your answer',
          chips: placed.value,
          onTap: tapPlaced,
          minHeight: 48,
        ),
        const SizedBox(height: AppSpacing.sm),
        WordChipArea(
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

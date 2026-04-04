// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/word_scramble_interaction.dart
// PURPOSE: Word scramble interaction with drag-to-order word chips
// PROVIDERS: QuizSessionPageController
// HOOKS: useMemoized, useState, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class WordScrambleInteraction extends HookWidget {
  const WordScrambleInteraction({
    super.key,
    required this.template, // <-- NEW: Specific template
    required this.controller,
    required this.shakeController,
  });

  final WordScrambleTemplate template;
  final SessionInteractionsController controller;
  final AnimationController shakeController;

  @override
  Widget build(BuildContext context) {
    // Generate the shuffled array based on the template's sentence
    final shuffled = useMemoized(() {
      final words = template.sentenceToScramble.split(' ');
      words.shuffle(Random());
      return words;
    }, []);

    final placed = useState<List<String>>([]);
    String getAnswer() => placed.value.join(' ');
    final remaining = useState<List<String>>(List.from(shuffled));

    void evaluateAnswer() {
      if (placed.value.isEmpty) {
        shakeController.forward(from: 0);
        return;
      }

      final answer = getAnswer();
      final isCorrect = template.checkAnswer(answer);

      if (!isCorrect) {
        shakeController.forward(from: 0);
        return;
      }
      controller.answer = answer;
      controller.canReveal = true;
    }

    // Initiates once rendered
    useEffect(() {
      placed.value = [];
      remaining.value = List.from(shuffled);

      return null;
    }, []);

    useEffect(() {
      evaluateAnswer();
      return null;
    }, [placed.value]);

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
          textColor: AppColors.backgroundDark,
          minHeight: 48,
        ),
      ],
    );
  }
}

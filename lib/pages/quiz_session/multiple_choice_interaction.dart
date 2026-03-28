// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/multiple_choice_interaction.dart
// PURPOSE: Multiple choice option buttons with correct/incorrect highlighting
// PROVIDERS: QuizProvider
// HOOKS: useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';

class MultipleChoiceInteraction extends HookWidget {
  const MultipleChoiceInteraction({
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

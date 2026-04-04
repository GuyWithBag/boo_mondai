// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/multiple_choice_interaction.dart
// PURPOSE: Multiple choice option buttons with correct/incorrect highlighting
// PROVIDERS: QuizSessionPageController
// HOOKS: useState, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class MultipleChoiceInteraction extends HookWidget {
  const MultipleChoiceInteraction({
    super.key,
    required this.template, // <-- NEW: Specific template
    required this.controller,
    required this.shakeController,
  });

  final MultipleChoiceTemplate template;
  final SessionInteractionsController controller;
  final AnimationController shakeController;

  @override
  Widget build(BuildContext context) {
    final selected = useState<String?>(null);

    // Reset selection when the active template changes
    useEffect(() {
      selected.value = null;
      return null;
    }, [template.id]);

    void onTap(MultipleChoiceOption option) async {
      if (selected.value != null) return;
      selected.value = option.id;

      if (!option.isCorrect) shakeController.forward(from: 0);

      await Future<void>.delayed(const Duration(milliseconds: 300));

      if (context.mounted) {
        return;
      }

      controller.answer = option.optionText;
      controller.canReveal = option.isCorrect;
      if (controller.canReveal) {
        controller.isRevealed = true;
      }
    }

    final options = template.options;
    final correctId = options
        .firstWhere((o) => o.isCorrect, orElse: () => options.first)
        .id;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Display the question prompt!
        Text(
          template.questionPrompt,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.xl),

        ...options.map((option) {
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
                  disabledForegroundColor:
                      hasSelection && option.id == correctId
                      ? AppColors.correct
                      : hasSelection && isSelected
                      ? AppColors.incorrect
                      : AppColors.textSecondary,
                ),
                child: Text(option.optionText),
              ),
            ),
          );
        }),
      ],
    );
  }
}

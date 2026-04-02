// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/deck_editor/mc_row.dart
// PURPOSE: Single row for a multiple choice option with correct toggle
// PROVIDERS: none
// HOOKS: useTextEditingController, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

/// A single row representing a multiple-choice option within the [McPanel].
class McRow extends HookWidget {
  const McRow({
    super.key,
    required this.index,
    required this.option,
    required this.canRemove,
    required this.onRemove,
    required this.onChanged,
  });

  /// The position of this option in the list.
  final int index;

  /// The raw data for this multiple-choice option.
  final MultipleChoiceOptionData option;

  /// Whether this option can be removed from the list (usually requires at least 2 options).
  final bool canRemove;

  /// Callback to remove this option.
  final VoidCallback onRemove;

  /// Callback when the option text or "correct" status changes.
  final void Function(MultipleChoiceOptionData updatedOption) onChanged;

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController(text: option.text);

    // Sync controller if the option text changes externally.
    useEffect(() {
      if (textController.text != option.text) {
        textController.text = option.text;
        textController.selection = TextSelection.collapsed(
          offset: option.text.length,
        );
      }
      return null;
    }, [option.text]);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          // Correct answer toggle (Circle indicator).
          Tooltip(
            message: option.isCorrect ? 'Correct answer' : 'Mark as correct',
            child: GestureDetector(
              onTap: () =>
                  onChanged((text: option.text, isCorrect: !option.isCorrect)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: option.isCorrect
                      ? AppColors.correct.withValues(alpha: 0.15)
                      : Colors.transparent,
                  border: Border.all(
                    color: option.isCorrect
                        ? AppColors.correct
                        : AppColors.textSecondary.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: option.isCorrect
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: AppColors.correct,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Option text input field.
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(hintText: 'Option ${index + 1}'),
                onChanged: (value) =>
                    onChanged((text: value, isCorrect: option.isCorrect)),
              ),
            ),
          ),

          if (canRemove)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onRemove,
              tooltip: 'Remove option',
              color: AppColors.textSecondary,
              visualDensity: VisualDensity.compact,
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }
}

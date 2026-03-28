// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/mc_row.dart
// PURPOSE: Single row for a multiple choice option with correct toggle
// PROVIDERS: none
// HOOKS: useTextEditingController, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/pages/deck_editor/editor_types.dart';

class McRow extends HookWidget {
  const McRow({
    super.key,
    required this.index,
    required this.option,
    required this.canRemove,
    required this.onRemove,
    required this.onChanged,
  });

  final int index;
  final McOpt option;
  final bool canRemove;
  final VoidCallback onRemove;
  final void Function(McOpt) onChanged;

  @override
  Widget build(BuildContext context) {
    final ctrl = useTextEditingController(text: option.text);
    useEffect(() {
      if (ctrl.text != option.text) {
        ctrl.text = option.text;
        ctrl.selection =
            TextSelection.collapsed(offset: option.text.length);
      }
      return null;
    }, [option.text]);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Tooltip(
            message:
                option.isCorrect ? 'Correct answer' : 'Mark as correct',
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
                    ? const Icon(Icons.check,
                        size: 16, color: AppColors.correct)
                    : null,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
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
                controller: ctrl,
                decoration:
                    InputDecoration(hintText: 'Option ${index + 1}'),
                onChanged: (v) =>
                    onChanged((text: v, isCorrect: option.isCorrect)),
              ),
            ),
          ),
          if (canRemove)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onRemove,
              tooltip: 'Remove',
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

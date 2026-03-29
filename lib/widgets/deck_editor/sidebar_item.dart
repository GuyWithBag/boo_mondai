// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/sidebar_item.dart
// PURPOSE: Single card item row in the editor sidebar
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class SidebarItem extends StatelessWidget {
  const SidebarItem({
    super.key,
    required this.card,
    required this.isActive,
    required this.onTap,
  });

  final DeckCard card;
  final bool isActive;
  final VoidCallback onTap;

  static const icons = <QuestionType, IconData>{
    QuestionType.flashcard: Icons.visibility_outlined,
    QuestionType.identification: Icons.border_color_outlined,
    QuestionType.multipleChoice: Icons.checklist_outlined,
    QuestionType.fillInTheBlanks: Icons.edit_note_outlined,
    QuestionType.wordScramble: Icons.shuffle_outlined,
    QuestionType.matchMadness: Icons.compare_arrows_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: isActive ? null : onTap,
      child: Container(
        color: isActive ? scheme.primary.withValues(alpha: 0.08) : null,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        child: Row(
          children: [
            Icon(
              icons[card.questionType] ?? Icons.help_outline,
              size: 15,
              color: isActive ? scheme.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                card.question.isNotEmpty ? card.question : '(empty)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isActive ? scheme.primary : null,
                  fontWeight: isActive ? FontWeight.w600 : null,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/sidebar_item.dart
// PURPOSE: Single template item row in the editor sidebar
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class SidebarItem extends StatelessWidget {
  const SidebarItem({
    super.key,
    required this.template, // <-- CHANGED
    required this.isActive,
    required this.onTap,
  });

  final CardTemplate template; // <-- CHANGED
  final bool isActive;
  final VoidCallback onTap;

  // Pattern matching to grab the right icon!
  IconData _getIcon() {
    return switch (template) {
      FlashcardTemplate _ => Icons.visibility_outlined,
      IdentificationTemplate _ => Icons.border_color_outlined,
      MultipleChoiceTemplate _ => Icons.checklist_outlined,
      FillInTheBlanksTemplate _ => Icons.edit_note_outlined,
      WordScrambleTemplate _ => Icons.shuffle_outlined,
      MatchMadnessTemplate _ => Icons.compare_arrows_outlined,
      _ => Icons.help_outline,
    };
  }

  // Pattern matching to grab the correct text preview!
  String _getPreviewText() {
    final text = switch (template) {
      FlashcardTemplate f => f.frontText,
      IdentificationTemplate i => i.promptText,
      MultipleChoiceTemplate m => m.questionPrompt,
      FillInTheBlanksTemplate fb =>
        fb.segments.isNotEmpty ? fb.segments.first.fullText : '',
      WordScrambleTemplate ws => ws.sentenceToScramble,
      MatchMadnessTemplate mm =>
        mm.pairs.isNotEmpty ? 'Match: ${mm.pairs.first.term}' : 'Match Pairs',
      _ => '',
    };

    return text.trim().isNotEmpty ? text : '(empty)';
  }

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
              _getIcon(), // <-- Use the new icon helper
              size: 15,
              color: isActive ? scheme.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                _getPreviewText(), // <-- Use the new text helper
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

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_detail/card_tile.dart
// PURPOSE: List tile for a template in the deck detail view with selection support
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class CardTile extends StatelessWidget {
  const CardTile({
    super.key,
    required this.template, // <-- CHANGED
    required this.isSelecting,
    required this.isSelected,
    required this.isUneditable,
    required this.onTap,
    required this.onLongPress,
  });

  final CardTemplate template; // <-- CHANGED
  final bool isSelecting;
  final bool isSelected;
  final bool isUneditable;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  // Pattern matching to safely extract a title
  String _getTitle() {
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
    return text.trim().isNotEmpty ? text : '(no question)';
  }

  // Pattern matching to safely extract a subtitle
  String _getSubtitle() {
    final text = switch (template) {
      FlashcardTemplate f => f.backText,
      IdentificationTemplate i => i.acceptedAnswers,
      MultipleChoiceTemplate m => '${m.options.length} options',
      FillInTheBlanksTemplate _ => 'Fill in the blanks',
      WordScrambleTemplate _ => 'Word scramble',
      MatchMadnessTemplate mm => '${mm.pairs.length} pairs',
      _ => '',
    };
    return text.trim().isNotEmpty ? text : '(no answer)';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      color: isSelected ? scheme.primaryContainer : null,
      child: ListTile(
        leading: isSelecting
            ? AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? scheme.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? scheme.primary
                        : AppColors.textSecondary,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 14, color: scheme.onPrimary)
                    : null,
              )
            : null,
        title: Row(
          children: [
            Expanded(
              child: Text(
                _getTitle(), // <-- Extracts specific template title
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isUneditable) ...[
              const SizedBox(width: AppSpacing.xs),
              StatusBadge.uneditable(),
            ],
          ],
        ),
        subtitle: Text(
          _getSubtitle(), // <-- Extracts specific template subtitle
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: isSelecting
            ? null
            : IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: onTap,
              ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}

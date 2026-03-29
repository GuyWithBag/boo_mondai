// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/type_bar.dart
// PURPOSE: Horizontal bar of question type selector buttons
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class TypeBar extends StatelessWidget {
  const TypeBar({super.key, required this.selected, required this.onChanged});

  final QuestionType selected;
  final void Function(QuestionType) onChanged;

  static const _types = [
    (QuestionType.flashcard, 'Flashcard', Icons.visibility_outlined),
    (
      QuestionType.identification,
      'Identification',
      Icons.border_color_outlined,
    ),
    (QuestionType.multipleChoice, 'Multiple Choice', Icons.checklist_outlined),
    (QuestionType.fillInTheBlanks, 'Fill in Blank', Icons.edit_note_outlined),
    (QuestionType.wordScramble, 'Word Scramble', Icons.shuffle_outlined),
    (QuestionType.matchMadness, 'Match Madness', Icons.compare_arrows_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question Type',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _types
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: TypeButton(
                      label: e.$2,
                      icon: e.$3,
                      selected: selected == e.$1,
                      onTap: () => onChanged(e.$1),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/deck_editor/fitb_editor.dart
// PURPOSE: Fill-in-the-blank editor with sentence input, answers input, and live preview
// PROVIDERS: none
// HOOKS: useListenable
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

/// A specialized editor for "Fill in the Blank" cards.
class FitbEditor extends HookWidget {
  const FitbEditor({
    super.key,
    required this.sentenceController,
    required this.answersController,
  });

  /// Controller for the full sentence text field.
  final TextEditingController sentenceController;

  /// Controller for the comma-separated answers text field.
  final TextEditingController answersController;

  @override
  Widget build(BuildContext context) {
    // We listen to the controllers to trigger rebuilds for the live preview.
    useListenable(sentenceController);
    useListenable(answersController);

    final hasContent =
        sentenceController.text.trim().isNotEmpty &&
        answersController.text.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InputCard(
          label: 'FULL SENTENCE',
          child: TextFormField(
            controller: sentenceController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'e.g. 魚 means fish in English',
              helperText:
                  'Write the complete sentence — include the answer word',
            ),
            validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Required' : null,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        InputCard(
          label: 'ANSWERS',
          child: TextFormField(
            controller: answersController,
            decoration: const InputDecoration(
              hintText: 'e.g. fish,dog',
              helperText: 'Separate multiple blanks with commas',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Required';

              final answers = splitFillInTheBlankAnswers(value);
              if (answers.isEmpty) return 'Required';

              final sentence = sentenceController.text.trim().toLowerCase();
              for (final answer in answers) {
                if (!sentence.contains(answer.toLowerCase())) {
                  return '"$answer" not found in the sentence above';
                }
              }
              return null;
            },
          ),
        ),
        if (hasContent) ...[
          const SizedBox(height: AppSpacing.md),
          FitbPreview(
            sentence: sentenceController.text,
            answersRaw: answersController.text,
          ),
        ],
      ],
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/fitb_editor.dart
// PURPOSE: Fill-in-the-blank editor with sentence input, answers input, and live preview
// PROVIDERS: none
// HOOKS: useListenable
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/pages/deck_editor/editor_types.dart';
import 'package:boo_mondai/pages/deck_editor/input_card.dart';
import 'package:boo_mondai/pages/deck_editor/fitb_preview.dart';

class FitbEditor extends HookWidget {
  const FitbEditor({super.key, required this.sentCtrl, required this.ansCtrl});

  final TextEditingController sentCtrl;
  final TextEditingController ansCtrl;

  @override
  Widget build(BuildContext context) {
    useListenable(sentCtrl);
    useListenable(ansCtrl);

    final hasContent =
        sentCtrl.text.trim().isNotEmpty && ansCtrl.text.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InputCard(
          label: 'FULL SENTENCE',
          child: TextFormField(
            controller: sentCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'e.g. 魚 means fish in English',
              helperText:
                  'Write the complete sentence \u2014 include the answer word',
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        InputCard(
          label: 'ANSWERS',
          child: TextFormField(
            controller: ansCtrl,
            decoration: const InputDecoration(
              hintText: 'e.g. fish,dog',
              helperText: 'Separate multiple blanks with commas',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              final answers = splitFitbAnswers(v);
              if (answers.isEmpty) return 'Required';
              final sentence = sentCtrl.text.trim().toLowerCase();
              for (final a in answers) {
                if (!sentence.contains(a.toLowerCase())) {
                  return '"$a" not found in the sentence above';
                }
              }
              return null;
            },
          ),
        ),
        if (hasContent) ...[
          const SizedBox(height: AppSpacing.md),
          FitbPreview(sentence: sentCtrl.text, answersRaw: ansCtrl.text),
        ],
      ],
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/left_panel.dart
// PURPOSE: Front/back input fields panel for flashcard, identification, MC, and word scramble types
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/pages/deck_editor/editor_types.dart';
import 'package:boo_mondai/pages/deck_editor/input_card.dart';
import 'package:boo_mondai/pages/deck_editor/mc_panel.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({
    super.key,
    required this.qType,
    required this.frontCtrl,
    required this.backCtrl,
    required this.identificationAnsCtrl,
    required this.frontFocus,
    required this.mcOpts,
    required this.onMcAdd,
    required this.onMcRemove,
    required this.onMcUpdate,
  });

  final QuestionType qType;
  final TextEditingController frontCtrl;
  final TextEditingController backCtrl;
  final TextEditingController identificationAnsCtrl;
  final FocusNode frontFocus;
  final List<McOpt> mcOpts;
  final VoidCallback onMcAdd;
  final void Function(int) onMcRemove;
  final void Function(int, McOpt) onMcUpdate;

  @override
  Widget build(BuildContext context) {
    final isMc = qType == QuestionType.multipleChoice;
    final isIdentification = qType == QuestionType.identification;
    final isWordScramble = qType == QuestionType.wordScramble;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InputCard(
          label: isWordScramble ? 'SENTENCE' : 'FRONT',
          child: TextFormField(
            controller: frontCtrl,
            focusNode: frontFocus,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: isWordScramble
                  ? 'e.g. The dog barked at the cat'
                  : 'e.g. 犬',
              helperText: isWordScramble
                  ? 'Each word becomes a chip the learner taps to reconstruct this sentence'
                  : null,
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
        ),
        // wordScramble has no back/answer field — the sentence itself is the answer
        if (!isWordScramble) ...[
          const SizedBox(height: AppSpacing.md),
          InputCard(
            label: isIdentification
                ? 'ANSWERS'
                : isMc
                    ? 'HINT (OPTIONAL)'
                    : 'BACK',
            child: TextFormField(
              controller: isIdentification ? identificationAnsCtrl : backCtrl,
              maxLines: isMc ? 2 : 3,
              decoration: InputDecoration(
                hintText: isIdentification
                    ? 'e.g. dog, いぬ, inu'
                    : isMc
                        ? 'Optional hint shown after answering'
                        : 'e.g. dog, いぬ, inu',
                helperText: isIdentification
                    ? 'Separate multiple accepted answers with commas'
                    : isMc
                        ? null
                        : 'Separate multiple accepted answers with commas',
              ),
              validator: (isIdentification || !isMc)
                  ? (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null
                  : null,
            ),
          ),
        ],
        if (isMc) ...[
          const SizedBox(height: AppSpacing.md),
          McPanel(
            options: mcOpts,
            onAdd: onMcAdd,
            onRemove: onMcRemove,
            onUpdate: onMcUpdate,
          ),
        ],
      ],
    );
  }
}

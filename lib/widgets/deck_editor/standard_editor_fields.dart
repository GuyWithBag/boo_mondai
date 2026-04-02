// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/deck_editor/standard_editor_fields.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class StandardEditorFields extends StatelessWidget {
  const StandardEditorFields({
    super.key,
    required this.questionType,
    required this.frontController,
    required this.backController,
    required this.identificationAnswerController,
    required this.frontFocusNode,
    required this.multipleChoiceOptions,
    required this.onMultipleChoiceAdd,
    required this.onMultipleChoiceRemove,
    required this.onMultipleChoiceUpdate,
  });

  final QuestionType questionType;
  final TextEditingController frontController;
  final TextEditingController backController;
  final TextEditingController identificationAnswerController;
  final FocusNode frontFocusNode;
  final List<MultipleChoiceOptionData> multipleChoiceOptions;
  final VoidCallback onMultipleChoiceAdd;
  final void Function(int index) onMultipleChoiceRemove;
  final void Function(int index, MultipleChoiceOptionData updatedOption)
  onMultipleChoiceUpdate;

  @override
  Widget build(BuildContext context) {
    final isMultipleChoice = questionType == QuestionType.multipleChoice;
    final isIdentification = questionType == QuestionType.identification;
    final isWordScramble = questionType == QuestionType.wordScramble;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InputCard(
          label: isWordScramble ? 'SENTENCE' : 'FRONT',
          child: TextFormField(
            controller: frontController,
            focusNode: frontFocusNode,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: isWordScramble
                  ? 'e.g. The dog barked at the cat'
                  : 'e.g. 犬',
              helperText: isWordScramble
                  ? 'Each word becomes a chip the learner taps'
                  : null,
            ),
            validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Required' : null,
          ),
        ),
        if (!isWordScramble) ...[
          const SizedBox(height: AppSpacing.md),
          InputCard(
            label: isIdentification
                ? 'ANSWERS'
                : isMultipleChoice
                ? 'HINT (OPTIONAL)'
                : 'BACK',
            child: TextFormField(
              controller: isIdentification
                  ? identificationAnswerController
                  : backController,
              maxLines: isMultipleChoice ? 2 : 3,
              decoration: InputDecoration(
                hintText: isMultipleChoice
                    ? 'Optional hint shown after answering'
                    : 'e.g. dog, いぬ, inu',
                helperText: isMultipleChoice
                    ? null
                    : 'Separate multiple accepted answers with commas',
              ),
              validator: (isIdentification || !isMultipleChoice)
                  ? (value) => (value == null || value.trim().isEmpty)
                        ? 'Required'
                        : null
                  : null,
            ),
          ),
        ],
        if (isMultipleChoice) ...[
          const SizedBox(height: AppSpacing.md),
          McPanel(
            options: multipleChoiceOptions,
            onOptionAdd: onMultipleChoiceAdd,
            onOptionRemove: onMultipleChoiceRemove,
            onOptionUpdate: onMultipleChoiceUpdate,
          ),
        ],
      ],
    );
  }
}

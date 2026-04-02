// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/editor_main.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class EditorMain extends HookWidget {
  const EditorMain({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DeckEditorPageController>();
    final formState = controller.formState;

    // Auto-listen to changes in the ValueNotifiers
    final qType = useValueListenable(formState.questionType);
    final cType = useValueListenable(formState.cardType);
    final mcOpts = useValueListenable(formState.multipleChoiceOptions);
    final matchPairs = useValueListenable(formState.matchPairs);

    final frontFocus = useFocusNode();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypeBar(
                selected: qType,
                onChanged: (t) {
                  formState.questionType.value = t;
                  if (!t.canBeReversible) {
                    formState.cardType.value = CardType.normal;
                  }
                },
              ),
              if (qType.canBeReversible) ...[
                const SizedBox(height: AppSpacing.lg),
                DirectionBar(
                  selected: cType,
                  onChanged: (ct) => formState.cardType.value = ct,
                ),
              ],
              const SizedBox(height: AppSpacing.xl),

              // Dynamic Content Panels
              if (qType.usesSegments)
                FitbEditor(
                  sentenceController:
                      formState.fillInTheBlankSentenceController,
                  answersController: formState.fillInTheBlankAnswersController,
                )
              else if (qType.usesPairs)
                MatchEditor(
                  matchingPairs: matchPairs,
                  onPairAdd: () => formState.matchPairs.value = [
                    ...matchPairs,
                    (term: '', match: ''),
                  ],
                  onPairRemove: (i) {
                    final l = [...matchPairs];
                    l.removeAt(i);
                    formState.matchPairs.value = l;
                  },
                  onPairUpdate: (i, p) {
                    final l = [...matchPairs];
                    l[i] = p;
                    formState.matchPairs.value = l;
                  },
                )
              else
                StandardEditorFields(
                  questionType: qType,
                  frontController: formState.frontController,
                  backController: formState.backController,
                  identificationAnswerController:
                      formState.identificationAnswerController,
                  frontFocusNode: frontFocus,
                  multipleChoiceOptions: mcOpts,
                  onMultipleChoiceAdd: () =>
                      formState.multipleChoiceOptions.value = [
                        ...mcOpts,
                        (text: '', isCorrect: false),
                      ],
                  onMultipleChoiceRemove: (i) {
                    final l = [...mcOpts];
                    l.removeAt(i);
                    formState.multipleChoiceOptions.value = l;
                  },
                  onMultipleChoiceUpdate: (i, o) {
                    final l = [...mcOpts];
                    l[i] = o;
                    formState.multipleChoiceOptions.value = l;
                  },
                ),

              if (controller.error != null) ...[
                const SizedBox(height: AppSpacing.md),
                ErrorText(controller.error!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

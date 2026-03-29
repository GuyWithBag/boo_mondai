// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/editor_main.dart
// PURPOSE: Main editor content area with type selector, direction bar, and type-specific panels
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class EditorMain extends StatelessWidget {
  const EditorMain({
    super.key,
    required this.qType,
    required this.cType,
    required this.frontCtrl,
    required this.backCtrl,
    required this.identificationAnsCtrl,
    required this.frontFocus,
    required this.mcOpts,
    required this.fitbSentCtrl,
    required this.fitbAnsCtrl,
    required this.matchPairs,
    this.error,
    required this.onTypeChanged,
    required this.onCardTypeChanged,
    required this.onMcAdd,
    required this.onMcRemove,
    required this.onMcUpdate,
    required this.onMatchAdd,
    required this.onMatchRemove,
    required this.onMatchUpdate,
  });

  final QuestionType qType;
  final CardType cType;
  final TextEditingController frontCtrl;
  final TextEditingController backCtrl;
  final TextEditingController identificationAnsCtrl;
  final FocusNode frontFocus;
  final List<McOpt> mcOpts;
  final TextEditingController fitbSentCtrl;
  final TextEditingController fitbAnsCtrl;
  final List<Pair> matchPairs;
  final String? error;
  final void Function(QuestionType) onTypeChanged;
  final void Function(CardType) onCardTypeChanged;
  final VoidCallback onMcAdd;
  final void Function(int) onMcRemove;
  final void Function(int, McOpt) onMcUpdate;
  final VoidCallback onMatchAdd;
  final void Function(int) onMatchRemove;
  final void Function(int, Pair) onMatchUpdate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypeBar(selected: qType, onChanged: onTypeChanged),
              if (qType.canBeReversible) ...[
                const SizedBox(height: AppSpacing.lg),
                DirectionBar(selected: cType, onChanged: onCardTypeChanged),
              ],
              const SizedBox(height: AppSpacing.xl),
              if (qType.usesSegments)
                FitbEditor(sentCtrl: fitbSentCtrl, ansCtrl: fitbAnsCtrl)
              else if (qType.usesPairs)
                MatchEditor(
                  pairs: matchPairs,
                  onAdd: onMatchAdd,
                  onRemove: onMatchRemove,
                  onUpdate: onMatchUpdate,
                )
              else
                LeftPanel(
                  qType: qType,
                  frontCtrl: frontCtrl,
                  backCtrl: backCtrl,
                  identificationAnsCtrl: identificationAnsCtrl,
                  frontFocus: frontFocus,
                  mcOpts: mcOpts,
                  onMcAdd: onMcAdd,
                  onMcRemove: onMcRemove,
                  onMcUpdate: onMcUpdate,
                ),
              if (error != null) ...[
                const SizedBox(height: AppSpacing.md),
                ErrorText(error!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

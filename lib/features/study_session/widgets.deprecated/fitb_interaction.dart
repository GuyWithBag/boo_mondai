// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/drill_session/fitb_interaction.dart
// PURPOSE: Fill-in-the-blanks interaction with multiple text fields
// PROVIDERS: DrillSessionController
// HOOKS: useMemoized, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show FillInTheBlanksTemplate, StudySessionController, AppSpacing;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FitbInteraction extends HookWidget {
  const FitbInteraction({
    super.key,
    required this.template, // <-- Changed from card
    required this.isReversed, // <-- Added flip state
    required this.controller,
    required this.shakeController,
  });

  final FillInTheBlanksTemplate template; // <-- Now uses the specific blueprint
  final bool isReversed;
  final StudySessionController controller;
  final AnimationController shakeController;

  @override
  Widget build(BuildContext context) {
    // 1. Pull segments from the new template
    final segments = template.segments;

    // 2. Tie the memory hook to the template.id
    final controllers = useMemoized(
      () => List.generate(segments.length, (_) => TextEditingController()),
      [template.id],
    );

    useEffect(() {
      return () {
        for (final c in controllers) {
          c.dispose();
        }
      };
    }, [controllers]);

    void submit() {
      final answers = controllers.map((c) => c.text.trim()).toList();
      if (answers.any((a) => a.isEmpty)) return;

      final allOk = List.generate(
        segments.length,
        (i) => segments[i].checkAnswer(answers[i]),
      ).every((ok) => ok);

      if (!allOk) shakeController.forward(from: 0);

      // Map boolean to enum
      // controller.submitAnswer(
      //   answers.join('|'),
      //   allOk ? StudyRating.good : StudyRating.incorrect,
      // );

      for (final c in controllers) {
        c.clear();
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(segments.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: TextField(
              controller: controllers[i],
              autofocus: i == 0,
              decoration: InputDecoration(
                hintText: segments[i].displayText,
                labelText: 'Blank ${i + 1}',
              ),
              onSubmitted: (_) {
                if (i < segments.length - 1) {
                  controllers[i + 1].selection = TextSelection.fromPosition(
                    TextPosition(offset: controllers[i + 1].text.length),
                  );
                } else {
                  submit();
                }
              },
            ),
          );
        }),
      ],
    );
  }
}

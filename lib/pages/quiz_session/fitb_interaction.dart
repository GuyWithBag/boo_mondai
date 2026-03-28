// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/fitb_interaction.dart
// PURPOSE: Fill-in-the-blanks interaction with multiple text fields
// PROVIDERS: QuizProvider
// HOOKS: useMemoized, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';

class FitbInteraction extends HookWidget {
  const FitbInteraction({
    super.key,
    required this.card,
    required this.quiz,
    required this.shakeController,
  });
  final DeckCard card;
  final QuizProvider quiz;
  final AnimationController shakeController;

  @override
  Widget build(BuildContext context) {
    final segments = card.segments;
    final controllers = useMemoized(
      () => List.generate(segments.length, (_) => TextEditingController()),
      [card.id],
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
      context.read<QuizProvider>().submitFitbAnswers(answers);
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
                    TextPosition(
                        offset: controllers[i + 1].text.length),
                  );
                } else {
                  submit();
                }
              },
            ),
          );
        }),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: submit,
            icon: const Icon(Icons.check),
            label: const Text('Submit'),
          ),
        ),
      ],
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/identification_interaction.dart
// PURPOSE: Text input interaction for identification question type
// PROVIDERS: QuizSessionPageController
// HOOKS: useTextEditingController, useEffect, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:provider/provider.dart';

class IdentificationInteraction extends HookWidget {
  const IdentificationInteraction({
    super.key,
    required this.template,
    required this.isReversed,
    required this.controller,
    required this.shakeController,
  });

  final IdentificationTemplate template;
  final bool isReversed;
  final SessionController controller;
  final AnimationController shakeController;

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final isRevealed = useState(false);

    // 1. Reset state whenever the active template changes
    useEffect(() {
      isRevealed.value = false;
      textController.clear();
      return null;
    }, [template.id]);

    // 2. The action triggered by the button or Enter key
    Future<void> handleReveal() async {
      if (isRevealed.value) return;
      if (textController.text.trim().isEmpty) {
        return;
      } // Optional: prevent blank submissions

      // Pre-calculate the FSRS intervals for the RatingArea UI
      // await controller.calculateNextIntervals();

      // Update local state to show the Rating Area
      isRevealed.value = true;
    }

    // 3. If revealed, swap out the text field for the Rating Area
    if (isRevealed.value) {
      return RatingArea(
        template: template,
        isReversed: isReversed,
        controller: controller,
        answer: textController.text.trim(), // Pass the user's typed text!
      );
    }

    // 4. The initial Text Field state
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          template.promptText,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.xl),

        Shortcuts(
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          },
          child: Actions(
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  handleReveal();
                  return null;
                },
              ),
            },
            child: TextField(
              controller: textController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Type your answer...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: handleReveal,
                ),
              ),
              onSubmitted: (_) => handleReveal(),
            ),
          ),
        ),
      ],
    );
  }
}

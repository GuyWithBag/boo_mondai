// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/identification_interaction.dart
// PURPOSE: Text input interaction for identification question type
// PROVIDERS: QuizSessionPageController
// HOOKS: useTextEditingController, useEffect, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class IdentificationInteraction extends HookWidget {
  const IdentificationInteraction({
    super.key,
    required this.template,
    required this.controller,
    required this.shakeController,
  });

  final IdentificationTemplate template;
  final SessionInteractionsController controller;
  final AnimationController shakeController;

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();

    void onSubmit() {
      final text = textController.text;
      if (text.trim().isEmpty || !template.checkAnswer(text)) return;

      controller.answer = text;
      controller.canReveal = true;
      controller.tryAnswer();
    }

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
                  onSubmit();
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
                  onPressed: onSubmit,
                ),
              ),
              onSubmitted: (_) => onSubmit(),
            ),
          ),
        ),
      ],
    );
  }
}

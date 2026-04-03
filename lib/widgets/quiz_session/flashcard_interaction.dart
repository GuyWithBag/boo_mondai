// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/flashcard_interaction.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class FlashcardInteraction extends HookWidget {
  const FlashcardInteraction({
    super.key,
    required this.template, // <-- Changed from card
    required this.isReversed, // <-- Added flip state
    required this.controller,
  });

  final FlashcardTemplate template;
  final bool isReversed;
  final SessionController controller;

  @override
  Widget build(BuildContext context) {
    final isRevealed = useState(false);

    // Reset flip state when the template changes
    useEffect(() {
      isRevealed.value = false;
      return null;
    }, [template.id]);

    Future<void> handleReveal() async {
      if (isRevealed.value) return;

      // Calculate intervals using the tracking ID!
      await controller.calculateNextIntervals();

      isRevealed.value = true;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Use our smart getters! They automatically show the right text.
        Text(
          template.getQuestion(isReversed: isReversed),
          style: Theme.of(context).textTheme.headlineMedium,
        ),

        const Spacer(),

        if (isRevealed.value) ...[
          // Notice we pass the template and flip state into the RatingArea too!
          RatingArea(
            template: template,
            isReversed: isReversed,
            // TODO: Replace This
            answer: 'Replace This',
            controller: controller,
          ),
        ] else ...[
          Shortcuts(
            shortcuts: const {
              SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
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
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: handleReveal,
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('Show Answer'),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

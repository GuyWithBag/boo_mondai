import 'package:boo_mondai/lib.barrel.dart'
    show
        BottomNavBar,
        Button,
        Scaffold,
        ViewCardsListView,
        AppTokens,
        ViewStudySessionDrillOnboardingController,
        ButtonColor;
import 'package:flutter/material.dart' hide Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, useMemoized;
import 'package:go_router/go_router.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewStudySessionDrillOnboardingPage extends SignalHookWidget {
  const ViewStudySessionDrillOnboardingPage({super.key, required this.deckId});

  final String deckId;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(
      () => ViewStudySessionDrillOnboardingController(deckId: deckId),
      [deckId],
    );
    useEffect(() => controller.dispose, [controller]);

    final tokens = context.themeTokens<AppTokens>();
    final canContinue = controller.cardsController.templates.value.isNotEmpty;

    return Scaffold(
      body: Column(
        children: [
          const Text('Review cards before starting the session.'),
          ViewCardsListView(controller: controller.cardsController),
        ],
      ),
      bottomNavBar: BottomNavBar(
        child: Row(
          spacing: tokens.spaceLayoutGapSm,
          children: [
            Expanded(
              child: Button(
                onPressed: () => context.pop(),
                child: const Text('Back'),
              ),
            ),
            Expanded(
              child: Button(
                variants: [ButtonColor.primary],
                onPressed: canContinue
                    ? () => context.push(controller.sessionPath)
                    : null,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

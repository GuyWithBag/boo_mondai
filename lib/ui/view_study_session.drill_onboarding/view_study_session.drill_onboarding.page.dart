import 'package:boo_mondai/lib.barrel.dart'
    show
        BottomNavBar,
        Button,
        Scaffold,
        ViewCardsController,
        ViewCardsListView,
        AppTokens,
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
      () => ViewCardsController(queryParameters: {'deckId': deckId})..load(),
      [deckId],
    );
    useEffect(() => controller.dispose, [controller]);

    final tokens = context.themeTokens<AppTokens>();

    return Scaffold(
      scrollable: false,
      body: Column(
        children: [
          const Text('Review cards before starting the session.'),
          Expanded(child: ViewCardsListView(controller: controller)),
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
                onPressed: () => context.push('/drill/$deckId/session'),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

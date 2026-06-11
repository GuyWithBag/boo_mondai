import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, LocalDB, DrillService, ButtonTone, Button;
import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        Text,
        EdgeInsets,
        Expanded,
        Tooltip,
        Row,
        SafeArea,
        SizedBox;
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

class ViewDeckLocalBottomNavbar extends StatelessWidget {
  const ViewDeckLocalBottomNavbar({super.key, required this.deckId});

  final String deckId;
  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    final deck = LocalDB.deck.selectByPk({'id': deckId});
    final userId = LocalDB.profile.getOrCreate().id;
    final eligibleCards = DrillService.getEligibleDrillCards(deckId, userId);
    final canDrill = eligibleCards.isNotEmpty;
    return SizedBox(
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.all(tokens.spacePanelPadding),
        child: Row(
          spacing: tokens.spacePanelGapMd,
          children: [
            Expanded(
              child: Button(
                tone: ButtonTone.ghost,
                onPressed: () => context.push('/decks-local/$deckId/edit'),
                child: const Text('VIEW CARDS'),
              ),
            ),
            Expanded(
              child: Tooltip(
                message: deck!.cardCount == 0
                    ? 'No cards yet'
                    : canDrill
                    ? '$eligibleCards.length cards ready'
                    : 'Completed',
                child: Button(
                  tone: ButtonTone.filled,
                  onPressed: canDrill
                      ? () => context.push('/drill/$deckId/session')
                      : null,
                  child: const Text('Study'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

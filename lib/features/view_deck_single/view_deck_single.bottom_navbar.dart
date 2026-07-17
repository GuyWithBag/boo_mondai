import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, Button, ButtonColor, Deck, DrillStudySessionHelper, LocalDB;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

class ViewDeckSingleBottomNavBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ViewDeckSingleBottomNavBar({super.key, required this.deck});

  final Deck deck;

  @override
  Size get preferredSize => Size(0, BottomNavBar.preferredHeightDefault);

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    final userId = LocalDB.profile.getOrCreate().id;
    final eligibleCards = DrillStudySessionHelper.getEligibleDrillCards(
      deck.id,
      userId,
    );
    final canDrill = eligibleCards.isNotEmpty;

    return BottomNavBar(
      variants: const [SurfaceShape.roundedSm],
      child: Row(
        spacing: tokens.spaceLayoutGapMd,
        children: [
          Expanded(
            child: Button(
              onPressed: () => context.push(
                '/view-cards?deckId=${Uri.encodeQueryComponent(deck.id)}',
              ),
              child: const Text('Cards'),
            ),
          ),
          Expanded(
            child: Tooltip(
              message: deck.cardCount == 0
                  ? 'No cards yet'
                  : canDrill
                  ? '$eligibleCards.length cards ready'
                  : 'Completed',
              child: Button(
                variants: const [ButtonColor.primary],
                onPressed: canDrill
                    ? () => context.push('/drill/${deck.id}/session')
                    : null,
                child: const Text('Study'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

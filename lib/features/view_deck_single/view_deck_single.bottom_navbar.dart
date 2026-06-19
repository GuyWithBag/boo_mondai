import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, LocalDB, DrillService, ButtonColor, Button, Deck;
import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        Text,
        Expanded,
        Tooltip,
        Row,
        EdgeInsets,
        Padding,
        MediaQuery,
        View;
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

class ViewDeckSingleBottomNavbar extends StatelessWidget {
  const ViewDeckSingleBottomNavbar({super.key, required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    final userId = LocalDB.profile.getOrCreate().id;
    final eligibleCards = DrillService.getEligibleDrillCards(deck.id, userId);
    final canDrill = eligibleCards.isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(
        bottom: _bottomSystemInset(context) + tokens.spaceLayoutGapSm,
        right: tokens.spaceScaffoldPadding,
        left: tokens.spaceScaffoldPadding,
      ),
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

double _bottomSystemInset(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final view = View.of(context);
  final devicePixelRatio = view.devicePixelRatio;
  final viewPaddingBottom = view.viewPadding.bottom / devicePixelRatio;
  final gestureInsetBottom = view.systemGestureInsets.bottom / devicePixelRatio;

  return [
    mediaQuery.padding.bottom,
    mediaQuery.viewPadding.bottom,
    mediaQuery.systemGestureInsets.bottom,
    viewPaddingBottom,
    gestureInsetBottom,
  ].reduce((max, value) => value > max ? value : max);
}

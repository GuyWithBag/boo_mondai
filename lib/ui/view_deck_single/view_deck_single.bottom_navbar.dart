import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        Deck,
        LocalDB,
        ViewDeckSingleSheetController;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

BottomNavBar viewDeckSingleBottomNavBar({
  required BuildContext context,
  required Deck deck,
  required ViewDeckSingleSheetController controller,
}) {
  final tokens = context.themeTokens<AppTokens>();

  final profileId = LocalDB.currentProfile.getOrCreate().id;
  final eligibleCards = LocalDB.studyCard.getEligibleDrillCards(
    deck.id,
    profileId,
  );
  final canDrill = eligibleCards.isNotEmpty;

  return BottomNavBar(
    variants: const [SurfaceShape.roundedSm],
    child: Row(
      spacing: tokens.spaceLayoutGapSm,
      children: [
        // Expanded(
        //   child: Button(
        //     onPressed: () => context.push(
        //       '/view-cards?deckId=${Uri.encodeQueryComponent(deck.id)}',
        //     ),
        //     child: const Text('Cards'),
        //   ),
        // ),
        Expanded(
          child: Button(
            onPressed: controller.canEdit.value
                ? () => controller.onEditPressed(context)
                : null,
            child: const Text('Edit Cards'),
          ),
        ),
        Expanded(
          child: Tooltip(
            message: deck.cardTemplatesCount == 0
                ? 'No cards yet'
                : canDrill
                ? '${eligibleCards.length} cards ready'
                : 'Completed',
            child: Button(
              variants: const [ButtonColor.primary],
              onPressed: canDrill
                  ? () => context.push('/drill/${deck.id}/onboarding')
                  : null,
              child: const Text('Study'),
            ),
          ),
        ),
      ],
    ),
  );
}

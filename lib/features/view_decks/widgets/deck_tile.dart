// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/deck_card_widget.dart
// PURPOSE: Reusable deck card for grid/list display with title, count, language, premade badge, selection mode
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        BackgroundImagePicked,
        CardTemplate,
        CardTemplateMapper,
        Deck,
        AppTokens,
        ScaleHelper,
        useCubeController,
        PhysicalCardController,
        PhysicalCard,
        PhysicalDeck,
        ViewCardsTile;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

enum DeckTileState { defaultView, bare, spread }

class DeckTile extends HookWidget {
  final Deck? deck;

  /// When non-null, a delete option appears in the card's popup menu.
  final VoidCallback? onDelete;

  /// When non-null, a "Push changes" option appears in the popup menu.
  final VoidCallback? onPush;

  /// Shows a small "unsynced" badge on the card when true.
  final bool isDirty;

  /// Shows a spinner badge instead of the cloud icon while push is in progress.
  final bool isPushing;

  /// Whether this specific card is selected.
  final bool isSelected;

  /// Controls the deck tile layout. Hover does not mutate this state.
  final DeckTileState state;

  /// Shows deck tags on the default tile's front cover.
  final bool hasTags;

  final bool isImageEditable;
  final BackgroundImagePicked? onImagePicked;

  final double? width;

  const DeckTile({
    super.key,
    this.deck,
    this.onDelete,
    this.onPush,
    this.isDirty = false,
    this.isPushing = false,
    this.isSelected = false,
    this.state = DeckTileState.defaultView,
    this.hasTags = false,
    this.isImageEditable = false,
    this.onImagePicked,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    const stackedCardCount = 3;
    final studyCardAspectRatio = tokens.studyCardAspectRatio;
    final cardWidth = width ?? tokens.studyCardWidth;
    final cardHeight = ScaleHelper.getSizeFromWidthAndAspectRatio(
      width: cardWidth,
      aspectRatio: studyCardAspectRatio,
    ).height;
    final animationScale = cardWidth / tokens.studyCardWidth;
    final deckDepth = 50.0 * animationScale;
    final effectiveOnImagePicked = isImageEditable ? onImagePicked : null;
    final featuredCards = _featuredCardTemplates(deck).take(3).toList();
    // final scale = 1.3;
    final cardControllers = useMemoized(
      () => List.generate(
        stackedCardCount,
        (_) =>
            PhysicalCardController(context, width: cardWidth, perspective: 0),
      ),
      [cardWidth],
    );
    useEffect(() {
      return () {
        for (final controller in cardControllers) {
          controller.dispose();
        }
      };
    }, [cardControllers]);

    final physicalDeckController = useCubeController(
      width: cardWidth,
      height: cardHeight,
      depth: deckDepth,
      perspective: 0,
    );

    void applyTileState() {
      final positionX = -80.0 * animationScale;
      final positionY = -30.0 * animationScale;
      final stackSpreadX = 20.0 * animationScale;
      final stackSpreadY = 10.0 * animationScale;
      final (roll, pitch, yaw) = (0.20, 0.30, -0.10);

      for (final controller in cardControllers) {
        controller.resetRotation();
        controller.resetPosition();
      }
      physicalDeckController.resetRotation();
      physicalDeckController.resetPosition();

      if (state != DeckTileState.spread) {
        return;
      }

      for (var i = 0; i < cardControllers.length; i++) {
        final controller = cardControllers[i];
        controller.setPosition(
          x: positionX + i * stackSpreadX,
          y: positionY + i * stackSpreadY,
        );
        controller.setRotation(roll: -roll, pitch: -pitch, yaw: 0);
      }
      physicalDeckController.setPosition(x: -positionX, y: positionY + 10);
      physicalDeckController.setRotation(roll: roll, pitch: pitch, yaw: yaw);
    }

    useEffect(() {
      applyTileState();
      return null;
    }, [state, cardControllers, physicalDeckController, animationScale]);

    return SizedBox(
      width: cardWidth,
      child: Transform.translate(
        offset: state == DeckTileState.spread
            ? Offset(0, 30 * animationScale)
            : Offset.zero,
        child: AspectRatio(
          aspectRatio: studyCardAspectRatio,
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: switch (state) {
              DeckTileState.defaultView => [
                PhysicalDeck(
                  deck: deck,
                  controller: physicalDeckController,
                  hasTags: hasTags,
                  textScaleBaseWidth: cardWidth,
                  isSelected: isSelected,
                ),
              ],
              DeckTileState.bare => [
                PhysicalDeck(
                  deck: deck,
                  controller: physicalDeckController,
                  showInfoCover: false,
                  isCoverImageEditable: effectiveOnImagePicked != null,
                  onCoverImagePicked: effectiveOnImagePicked,
                  textScaleBaseWidth: cardWidth,
                  isSelected: isSelected,
                ),
              ],
              DeckTileState.spread => [
                for (var i = 0; i < cardControllers.length; i++)
                  if (i < featuredCards.length)
                    ViewCardsTile.template(
                      template: featuredCards[i],
                      width: cardWidth,
                      allowFlip: false,
                      controller: cardControllers[i],
                    )
                  else
                    PhysicalCard(controller: cardControllers[i]),
                PhysicalDeck(
                  deck: deck,
                  controller: physicalDeckController,
                  showInfoCover: false,
                  textScaleBaseWidth: cardWidth,
                  isSelected: isSelected,
                ),
              ],
            },
          ),
        ),
      ),
    );
  }
}

List<CardTemplate> _featuredCardTemplates(Deck? deck) {
  final featuredCards = deck?.listing?.featuredCards ?? const [];
  return featuredCards
      .map(_decodeFeaturedCard)
      .nonNulls
      .toList(growable: false);
}

CardTemplate? _decodeFeaturedCard(Map<String, dynamic> card) {
  try {
    return CardTemplateMapper.fromMap(card);
  } catch (_) {
    return null;
  }
}

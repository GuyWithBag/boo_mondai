import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, CardTemplate, StudyCard, ViewCardsTile, ViewCardsTileSide;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewCardsByPairTile extends StatelessWidget {
  const ViewCardsByPairTile.template({
    required this.template,
    this.tileWidth = 260,
    super.key,
  }) : frontCard = null,
       backCard = null;

  const ViewCardsByPairTile.studyCards({
    required this.frontCard,
    required this.backCard,
    this.tileWidth = 260,
    super.key,
  }) : template = null;

  final CardTemplate? template;
  final StudyCard? frontCard;
  final StudyCard? backCard;
  final double tileWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(tokens.spaceLayoutPadding),
      decoration: BoxDecoration(
        color: tokens.colorMuted,
        borderRadius: BorderRadius.circular(tokens.radiusSurfaceXsm),
      ),
      child: Wrap(
        spacing: tokens.spaceLayoutGapLg,
        runSpacing: tokens.spaceLayoutGapLg,
        alignment: WrapAlignment.center,
        children: [
          if (template != null) ...[
            ViewCardsTile.template(
              template: template!,
              width: tileWidth,
              initialSide: ViewCardsTileSide.front,
              allowFlip: false,
            ),
            ViewCardsTile.template(
              template: template!,
              width: tileWidth,
              initialSide: ViewCardsTileSide.back,
              allowFlip: false,
            ),
          ] else ...[
            ViewCardsTile.studyCard(
              studyCard: frontCard!,
              width: tileWidth,
              initialSide: ViewCardsTileSide.front,
              allowFlip: false,
            ),
            ViewCardsTile.studyCard(
              studyCard: backCard!,
              width: tileWidth,
              initialSide: ViewCardsTileSide.back,
              allowFlip: false,
            ),
          ],
        ],
      ),
    );
  }
}

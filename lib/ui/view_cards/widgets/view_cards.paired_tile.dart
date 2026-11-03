import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        CardTemplate,
        ViewCardsTile,
        ViewCardsTileSide,
        ThemeController;
import 'package:flutter/material.dart';

class ViewCardsPairedTile extends StatelessWidget {
  const ViewCardsPairedTile.template({
    required this.template,
    this.tileWidth = 260,
    super.key,
  });

  final CardTemplate template;
  final double tileWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeController.tokens;

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
          ViewCardsTile.template(
            template: template,
            width: tileWidth,
            initialSide: ViewCardsTileSide.front,
            flippable: false,
          ),
          ViewCardsTile.template(
            template: template,
            width: tileWidth,
            initialSide: ViewCardsTileSide.back,
            flippable: false,
          ),
        ],
      ),
    );
  }
}

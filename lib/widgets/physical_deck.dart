import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/theme/theme.barrel.dart';
import 'package:boo_mondai/variant_styles/variant_styles.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class PhysicalDeck extends StatelessWidget {
  const PhysicalDeck({
    super.key,
    this.deck,
    required this.controller,
    this.textScaleBaseWidth = 300,
  });

  final Deck? deck;
  final CubeController controller;
  final double textScaleBaseWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final textScale = (controller.width / textScaleBaseWidth).clamp(0.6, 1.4);
    final titleStyle = appTextStyle
        .resolve(tokens, const [TextSize.labelLarge, TextWeight.heavy])
        .scaledBy(textScale);
    final descriptionStyle = appTextStyle
        .resolve(tokens, const [TextSize.labelSmall, TextWeight.body])
        .scaledBy(textScale);
    final coverImageUrl = _coverImageUrl(deck);

    return Cube(
      controller: controller,
      right: Surface(
        style: surfaceStyle.resolve(tokens, const [SurfaceShape.sharp]),
        child: SizedBox.shrink(),
      ),
      left: Surface(
        style: surfaceStyle.resolve(tokens, const [SurfaceShape.sharp]),
        child: SizedBox.shrink(),
      ),
      top: Surface(
        style: surfaceStyle.resolve(tokens, const [SurfaceShape.sharp]),
        child: SizedBox.shrink(),
      ),
      bottom: Surface(
        style: surfaceStyle.resolve(tokens, const [SurfaceShape.sharp]),
        child: SizedBox.shrink(),
      ),
      front: Surface(
        style: surfaceStyle.resolve(tokens, const [
          SurfaceShape.sharp,
          SurfacePadding.none,
        ]),
        child: Stack(
          fit: StackFit.expand,
          // alignment: Alignment.center,
          children: [
            Image.network(coverImageUrl, fit: BoxFit.cover),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // SizedBox.expand(),
                  const Spacer(),
                  Surface(
                    style: surfaceStyle.resolve(tokens, const [
                      SurfaceShape.sharp,
                      SurfacePadding.text,
                    ]),
                    child: Column(
                      children: [
                        Text(
                          deck?.title ?? 'Untitled deck',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: titleStyle,
                        ),
                        Text(
                          deck?.shortDescription ?? 'No description yet',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: descriptionStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _coverImageUrl(Deck? deck) {
    final coverImageUrl = deck?.coverImageUrl;
    if (coverImageUrl == null || coverImageUrl.trim().isEmpty) {
      return _fallbackDeckImageUrl;
    }

    return coverImageUrl;
  }
}

const _fallbackDeckImageUrl =
    "https://w0.peakpx.com/wallpaper/314/133/HD-wallpaper-world-of-warcraft-clans-game-wow.jpg";

extension on TextStyle {
  TextStyle scaledBy(double scale) {
    final fontSize = this.fontSize;

    if (fontSize == null) {
      return this;
    }

    return copyWith(fontSize: fontSize * scale);
  }
}

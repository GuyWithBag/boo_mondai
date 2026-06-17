import 'package:boo_mondai/core/widgets/background_image_surface.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        CubeController,
        Deck,
        AppTokens,
        textStyle,
        TextSize,
        TextWeight,
        SurfaceBorder,
        surfaceStyle,
        SurfaceShape,
        SurfacePadding,
        SurfaceColor,
        Cube,
        studyCardWidth;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class PhysicalDeck extends StatelessWidget {
  const PhysicalDeck({
    super.key,
    this.deck,
    required this.controller,
    this.hasTags = false,
    this.showInfoCover = true,
    this.textScaleBaseWidth,
  });

  final Deck? deck;
  final CubeController controller;
  final bool hasTags;
  final bool showInfoCover;
  final double? textScaleBaseWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final effectiveTextScaleBaseWidth = tokens.studyCardWidth;
    final textScale = (controller.width / effectiveTextScaleBaseWidth).clamp(
      0.6,
      1.4,
    );
    final titleStyle = textStyle
        .resolve(tokens, const [TextSize.labelLarge, TextWeight.heavy])
        .scaledBy(textScale);
    final tagStyle = textStyle
        .resolve(tokens, const [TextSize.labelSmall, TextWeight.heavy])
        .scaledBy(textScale);
    final descriptionStyle = textStyle
        .resolve(tokens, const [TextSize.labelSmall, TextWeight.body])
        .scaledBy(textScale);
    final coverImage = backgroundImageProviderFromSource(deck?.coverImageUrl);
    final visibleTags = deck?.tags.take(8).toList() ?? const [];

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
      front: BackgroundImageSurface(
        image: coverImage,
        clipBehavior: Clip.none,
        style: surfaceStyle.resolve(tokens, const [
          SurfaceShape.sharp,
          SurfacePadding.none,
        ]),
        child: showInfoCover
            ? Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: -controller.width * 0.06,
                    right: -controller.width * 0.06,
                    bottom: -controller.height * 0.08,
                    child: Surface(
                      style: surfaceStyle.resolve(tokens, const [
                        SurfaceColor.muted,
                        SurfaceShape.sharp,
                        SurfacePadding.text,
                      ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            deck?.title ?? 'Untitled deck',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: titleStyle,
                          ),
                          if (hasTags && visibleTags.isNotEmpty) ...[
                            SizedBox(height: controller.height * 0.025),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: controller.width * 0.025,
                              runSpacing: controller.height * 0.015,
                              children: [
                                for (final tag in visibleTags)
                                  Surface(
                                    style: surfaceStyle.resolve(tokens, const [
                                      SurfaceShape.cardShape,
                                      SurfacePadding.none,
                                      SurfaceBorder.normal,
                                    ]),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: controller.width * 0.035,
                                        vertical: controller.height * 0.01,
                                      ),
                                      child: Text(
                                        tag.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: tagStyle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                          if ((deck?.shortDescription ?? '')
                              .trim()
                              .isNotEmpty) ...[
                            SizedBox(height: controller.height * 0.025),
                            Text(
                              deck!.shortDescription,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: descriptionStyle,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}

extension on TextStyle {
  TextStyle scaledBy(double scale) {
    final fontSize = this.fontSize;

    if (fontSize == null) {
      return this;
    }

    return copyWith(fontSize: fontSize * scale);
  }
}

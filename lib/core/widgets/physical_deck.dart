import 'package:boo_mondai/core/widgets/background_image_surface.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        BackgroundImagePicked,
        CubeController,
        Deck,
        AppTokens,
        ImageHelper,
        LocalImageResolverHelper,
        textStyle,
        TextSize,
        TextWeight,
        SurfaceBorder,
        SurfaceBorderColor,
        surfaceStyle,
        SurfaceShape,
        SurfacePadding,
        SurfaceColor,
        ScaleHelper,
        Cube;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class PhysicalDeck extends StatelessWidget {
  const PhysicalDeck({
    super.key,
    this.deck,
    required this.controller,
    this.hasTags = false,
    this.showInfoCover = true,
    this.isCoverImageEditable = false,
    this.textScaleBaseWidth,
    this.onCoverImagePicked,
    this.isSelected = false,
  });

  final Deck? deck;
  final CubeController controller;
  final bool hasTags;
  final bool showInfoCover;
  final bool isCoverImageEditable;
  final double? textScaleBaseWidth;
  final BackgroundImagePicked? onCoverImagePicked;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final effectiveTextScaleBaseWidth =
        textScaleBaseWidth ?? tokens.studyCardWidth;
    final textScale = ScaleHelper.getClampedSizeRatio(
      current: controller.width,
      base: effectiveTextScaleBaseWidth,
      min: 0.6,
      max: 1.4,
    );
    final titleStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [TextSize.labelLarge, TextWeight.strong]),
      textScale,
    );
    final tagStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [TextSize.labelSmall, TextWeight.strong]),
      textScale,
    );
    final descriptionStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [TextSize.labelSmall, TextWeight.body]),
      textScale,
    );
    final coverImage = ImageHelper.getImageProviderFromSource(
      deck == null ? null : LocalImageResolverHelper.resolveDeckCover(deck!),
    );
    final visibleTags = deck?.tags.take(8).toList() ?? const [];

    final borderStyle = isSelected
        ? SurfaceBorderColor.selected
        : SurfaceBorderColor.inherit;

    return Cube(
      controller: controller,
      right: Surface(
        style: surfaceStyle.resolve(tokens, [SurfaceShape.sharp, borderStyle]),
        child: SizedBox.shrink(),
      ),
      left: Surface(
        style: surfaceStyle.resolve(tokens, [SurfaceShape.sharp, borderStyle]),
        child: SizedBox.shrink(),
      ),
      top: Surface(
        style: surfaceStyle.resolve(tokens, [SurfaceShape.sharp, borderStyle]),
        child: SizedBox.shrink(),
      ),
      bottom: Surface(
        style: surfaceStyle.resolve(tokens, [SurfaceShape.sharp, borderStyle]),
        child: SizedBox.shrink(),
      ),
      front: LayoutBuilder(
        builder: (context, constraints) {
          return BackgroundImageSurface(
            image: coverImage,
            isEditable: isCoverImageEditable,
            onImagePicked: onCoverImagePicked,
            clipBehavior: Clip.none,
            style: surfaceStyle.resolve(tokens, [
              SurfaceShape.sharp,
              SurfacePadding.none,
              borderStyle,
            ]),
            child: showInfoCover
                ? Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: -controller.width * 0.03,
                        right: -controller.width * 0.03,
                        bottom: -controller.height * 0.03,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight * 0.34,
                          ),
                          child: Surface(
                            style: surfaceStyle.resolve(tokens, [
                              SurfaceColor.muted,
                              SurfaceShape.sharp,
                              SurfacePadding.text,
                              borderStyle,
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
                                          style: surfaceStyle
                                              .resolve(tokens, const [
                                                SurfaceShape.cardShape,
                                                SurfacePadding.none,
                                                SurfaceBorder.baseline,
                                              ]),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  controller.width * 0.035,
                                              vertical:
                                                  controller.height * 0.01,
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
                      ),
                    ],
                  )
                : null,
          );
        },
      ),
    );
  }
}

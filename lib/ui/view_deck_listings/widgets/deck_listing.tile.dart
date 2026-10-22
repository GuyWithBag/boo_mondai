import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        DeckTile,
        DeckTileState,
        HeaderBadge,
        MetaLabel,
        NumberHelper,
        ProfileLabel,
        SurfaceBorder,
        SurfaceColor,
        SurfacePadding,
        SurfaceShape,
        TextColor,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle,
        BackgroundImageSurface,
        DeckListingTileController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class DeckListingTile extends SignalHookWidget {
  const DeckListingTile({super.key, this.onPressed, required this.controller});

  final DeckListingTileController controller;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    useEffect(() {
      final error = controller.error;
      if (error.value == null) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
          ),
        );
        controller.error.value = null;
      });

      return null;
    }, [controller.error]);

    useEffect(() {
      return controller.dispose;
    }, [controller]);

    final deckTileWidth = 90.0;
    final deckTileTopPosition =
        -(deckTileWidth / tokens.studyCardAspectRatio) + 10;

    final tile = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 580.0),
      child: Surface(
        style: surfaceStyle.resolve(tokens, const [
          SurfacePadding.none,
          SurfaceShape.sharp,
        ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: tokens.deckListingFeaturedImagesAspectRatio,
              child: BackgroundImageSurface(
                image: controller.backgroundImage.value,
                style: surfaceStyle.resolve(tokens, const [
                  SurfacePadding.none,
                  SurfaceShape.sharp,
                ]),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: tokens.spaceLayoutGapMd,
                      right: tokens.spaceLayoutGapLg,
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        spacing: tokens.spaceLayoutGapMd,
                        runSpacing: tokens.spaceLayoutGapSm,
                        children: [
                          if (!controller.deck.isPublished)
                            const HeaderBadge(label: 'Unpublished'),
                          MetaLabel(
                            icon: Icons.download_outlined,
                            label: NumberHelper.formatAbbreviatedCount(
                              controller.listing.downloadsCount,
                            ),
                          ),
                          MetaLabel(
                            icon: Icons.call_split_outlined,
                            label: NumberHelper.formatAbbreviatedCount(
                              controller.listing.forksCount,
                            ),
                          ),
                          MetaLabel(
                            icon: Icons.chat_bubble_outline,
                            label: NumberHelper.formatAbbreviatedCount(
                              controller.listing.commentsCount,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: tokens.spaceLayoutGapLg,
                      bottom: tokens.spaceLayoutGapMd,
                      child: ProfileLabel(
                        displayName: controller.profile.username,
                        facingLeft: true,
                        avatar: controller.profileAvatar.value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Surface(
                  style: surfaceStyle.resolve(tokens, const [
                    SurfaceColor.muted,
                    SurfaceShape.sharp,
                    SurfaceBorder.top,
                  ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              controller.title.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textStyle.resolve(tokens, const [
                                TextSize.header,
                                TextWeight.heavy,
                              ]),
                            ),
                          ),
                          SizedBox(width: tokens.spaceLayoutGapMd),
                          _FavoriteButton(
                            count: NumberHelper.formatAbbreviatedCount(
                              controller.listing.favoritesCount,
                            ),
                            isSelected: controller.isFavorite.value,
                            onPressed:
                                controller.isLoading.value ||
                                    !controller.deck.isPublished
                                ? null
                                : () {
                                    controller.toggleFavorite();
                                  },
                          ),
                        ],
                      ),
                      SizedBox(height: tokens.spaceLayoutGapSm),
                      Text(
                        controller.description.value,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle.resolve(tokens, const [
                          TextSize.label,
                          TextWeight.body,
                          TextColor.muted,
                        ]),
                      ),
                      SizedBox(height: tokens.spaceLayoutGapMd),
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: tokens.spaceLayoutGapMd,
                              runSpacing: tokens.spaceLayoutGapSm,
                              children: [
                                MetaLabel(
                                  icon: Icons.style_outlined,
                                  label:
                                      '${controller.deck.cardTemplatesCount} cards',
                                ),
                                MetaLabel(
                                  icon: Icons.new_releases_outlined,
                                  label:
                                      'v${controller.version.value}+${controller.deck.buildNumber}',
                                ),
                              ],
                            ),
                          ),

                          _InlineMetric(
                            icon: Icons.keyboard_arrow_down,
                            label: NumberHelper.formatAbbreviatedCount(
                              controller.listing.downvotesCount,
                            ),
                          ),
                          SizedBox(width: tokens.spaceLayoutGapMd),
                          _InlineMetric(
                            icon: Icons.keyboard_arrow_up,
                            label: NumberHelper.formatAbbreviatedCount(
                              controller.listing.upvotesCount,
                            ),
                          ),
                        ],
                      ),
                      if (controller.tags.value.isNotEmpty) ...[
                        SizedBox(height: tokens.spaceLayoutGapMd),
                        Wrap(
                          spacing: tokens.spaceLayoutGapSm,
                          runSpacing: tokens.spaceLayoutGapSm,
                          children: [
                            for (final tag in controller.tags.value)
                              HeaderBadge(label: tag.name),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Positioned(
                  left: tokens.spaceLayoutPadding,
                  top: deckTileTopPosition,
                  child: DeckTile(
                    deck: controller.deck,
                    width: deckTileWidth,
                    state: DeckTileState.bare,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return MouseRegion(
      cursor: onPressed == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: tile,
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.count,
    required this.isSelected,
    required this.onPressed,
  });

  final String count;
  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final color = isSelected ? tokens.colorPrimary : tokens.colorTextBaseline;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          tooltip: isSelected ? 'Remove favorite' : 'Favorite',
          style: IconButton.styleFrom(
            foregroundColor: color,
            disabledForegroundColor: tokens.colorTextMuted,
          ),
          onPressed: onPressed,
          icon: Icon(isSelected ? Icons.favorite : Icons.favorite_border),
        ),
        Text(
          count,
          style: textStyle
              .resolve(tokens, const [TextSize.label, TextWeight.strong])
              .copyWith(color: color),
        ),
      ],
    );
  }
}

class _InlineMetric extends StatelessWidget {
  const _InlineMetric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: tokens.colorTextBaseline),
        SizedBox(width: tokens.spaceLayoutGapSm / 2),
        Text(
          label,
          style: textStyle
              .resolve(tokens, const [TextSize.label, TextWeight.strong])
              .copyWith(color: tokens.colorTextBaseline),
        ),
      ],
    );
  }
}

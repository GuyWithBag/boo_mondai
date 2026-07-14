import 'package:boo_mondai/core/widgets/background_image_surface.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Deck,
        DecksService,
        DeckTile,
        DeckTileState,
        HeaderBadge,
        ImageHelper,
        StoredMediaHelper,
        StoredMediaService,
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
        useDeckListingInteractionsController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class DeckListingTile extends HookWidget {
  const DeckListingTile({super.key, required this.deck, this.onPressed});

  final Deck deck;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final listing = deck.listing;
    final interactionsEnabled = listing != null && deck.isPublished;
    final interactionsController = useDeckListingInteractionsController(
      deck,
      enabled: interactionsEnabled,
    );
    final AppTokens tokens = context.themeTokens<AppTokens>();
    final tags = deck.tags.take(8).toList();
    final title = deck.title.isEmpty ? 'Untitled deck' : deck.title;
    final description = deck.shortDescription.isEmpty
        ? 'No description yet'
        : deck.shortDescription;
    final version = deck.version.isEmpty ? '1.0.0' : deck.version;
    final backgroundImage = ImageHelper.getImageProviderFromSource(
      DecksService.getListingFeaturedImageSource(deck: deck),
    );
    final creatorName = deck.userProfile?.username ?? 'Unknown creator';

    useEffect(() {
      final error = interactionsController.error;
      if (error == null) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
          ),
        );
        interactionsController.setError(null);
      });

      return null;
    }, [interactionsController.error]);

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
                image: backgroundImage,
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
                          if (!deck.isPublished)
                            const HeaderBadge(label: 'Unpublished'),
                          MetaLabel(
                            icon: Icons.download_outlined,
                            label: NumberHelper.formatAbbreviatedCount(
                              listing?.downloadsCount ?? 0,
                            ),
                          ),
                          MetaLabel(
                            icon: Icons.call_split_outlined,
                            label: NumberHelper.formatAbbreviatedCount(
                              listing?.forksCount ?? 0,
                            ),
                          ),
                          MetaLabel(
                            icon: Icons.chat_bubble_outline,
                            label: NumberHelper.formatAbbreviatedCount(
                              listing?.commentsCount ?? 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: tokens.spaceLayoutGapLg,
                      bottom: tokens.spaceLayoutGapMd,
                      child: ProfileLabel(
                        displayName: creatorName,
                        facingLeft: true,
                        avatarUrl: deck.userProfile == null
                            ? null
                            : StoredMediaService.getLocalPath(
                                    StoredMediaHelper.getSemanticId(
                                      'profile',
                                      deck.userProfile!.id,
                                      'avatar',
                                    ),
                                  ) ??
                                  deck.userProfile!.avatarUrl,
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
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textStyle.resolve(tokens, const [
                                TextSize.header,
                                TextWeight.heavy,
                              ]),
                            ),
                          ),
                          SizedBox(width: tokens.spaceLayoutGapMd),
                          if (listing != null)
                            _FavoriteButton(
                              count: NumberHelper.formatAbbreviatedCount(
                                interactionsController.favoritesCount,
                              ),
                              isSelected: interactionsController.isFavorite,
                              onPressed:
                                  interactionsController.isBusy ||
                                      !interactionsEnabled
                                  ? null
                                  : () {
                                      interactionsController.toggleFavorite();
                                    },
                            ),
                        ],
                      ),
                      SizedBox(height: tokens.spaceLayoutGapSm),
                      Text(
                        description,
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
                                  label: '${deck.cardCount} cards',
                                ),
                                MetaLabel(
                                  icon: Icons.new_releases_outlined,
                                  label: 'v$version+${deck.buildNumber}',
                                ),
                              ],
                            ),
                          ),
                          if (listing != null) ...[
                            _InlineMetric(
                              icon: Icons.keyboard_arrow_down,
                              label: NumberHelper.formatAbbreviatedCount(
                                interactionsController.downvotesCount,
                              ),
                            ),
                            SizedBox(width: tokens.spaceLayoutGapMd),
                            _InlineMetric(
                              icon: Icons.keyboard_arrow_up,
                              label: NumberHelper.formatAbbreviatedCount(
                                interactionsController.upvotesCount,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (tags.isNotEmpty) ...[
                        SizedBox(height: tokens.spaceLayoutGapMd),
                        Wrap(
                          spacing: tokens.spaceLayoutGapSm,
                          runSpacing: tokens.spaceLayoutGapSm,
                          children: [
                            for (final tag in tags)
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
                    deck: deck,
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

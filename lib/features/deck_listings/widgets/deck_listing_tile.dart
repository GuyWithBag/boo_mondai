import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        useDeckListingInteractionsController,
        AppTokens,
        surfaceStyle,
        SurfacePadding,
        SurfaceShape,
        DeckTile,
        MetaLabel,
        appTextStyle,
        TextSize,
        TextWeight,
        TextTone,
        HeaderBadge;
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
    final interactionsController = useDeckListingInteractionsController(
      deck,
      enabled: listing != null,
    );
    final AppTokens tokens = context.themeTokens<AppTokens>();
    final tags = deck.tags.take(8).toList();
    final title = deck.title.isEmpty ? 'Untitled deck' : deck.title;
    final description = deck.shortDescription.isEmpty
        ? 'No description yet'
        : deck.shortDescription;
    final version = deck.version.isEmpty ? '1.0.0' : deck.version;
    final backgroundImageUrl = _listingImageUrl(deck);
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

    final tile = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 580, minWidth: 320),
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
              aspectRatio: 16 / 8.5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(backgroundImageUrl, fit: BoxFit.cover),
                  _HeaderScrim(color: tokens.backgroundSurface),
                  Positioned(
                    top: tokens.spacePanelGapMd,
                    right: tokens.spacePanelGapLg,
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      spacing: tokens.spacePanelGapMd,
                      runSpacing: tokens.spacePanelGapSm,
                      children: [
                        MetaLabel(
                          icon: Icons.download_outlined,
                          label: _formatCount(listing?.downloadsCount ?? 0),
                        ),
                        MetaLabel(
                          icon: Icons.call_split_outlined,
                          label: _formatCount(listing?.forksCount ?? 0),
                        ),
                        MetaLabel(
                          icon: Icons.chat_bubble_outline,
                          label: _formatCount(listing?.commentsCount ?? 0),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: tokens.spacePanelGapLg,
                    bottom: tokens.spacePanelGapMd,
                    child: DeckTile(deck: deck, width: 150),
                  ),
                  Positioned(
                    right: tokens.spacePanelGapLg,
                    bottom: tokens.spacePanelGapMd,
                    child: _CreatorBadge(
                      name: creatorName,
                      avatarUrl: deck.userProfile?.avatarUrl,
                    ),
                  ),
                ],
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(color: tokens.softGray),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  tokens.spacePanelGapLg,
                  tokens.spacePanelGapSm,
                  tokens.spacePanelGapLg,
                  tokens.spacePanelGapMd,
                ),
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
                            style: appTextStyle.resolve(tokens, const [
                              TextSize.header,
                              TextWeight.heavy,
                            ]),
                          ),
                        ),
                        SizedBox(width: tokens.spacePanelGapMd),
                        if (listing != null)
                          _FavoriteButton(
                            count: _formatCount(
                              interactionsController.favoritesCount,
                            ),
                            isSelected: interactionsController.isFavorite,
                            onPressed: interactionsController.isBusy
                                ? null
                                : () {
                                    interactionsController.toggleFavorite();
                                  },
                          ),
                      ],
                    ),
                    SizedBox(height: tokens.spacePanelGapSm),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appTextStyle.resolve(tokens, const [
                        TextSize.label,
                        TextWeight.body,
                        TextTone.secondary,
                      ]),
                    ),
                    SizedBox(height: tokens.spacePanelGapMd),
                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: tokens.spacePanelGapMd,
                            runSpacing: tokens.spacePanelGapSm,
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
                            label: _formatCount(
                              interactionsController.downvotesCount,
                            ),
                          ),
                          SizedBox(width: tokens.spacePanelGapMd),
                          _InlineMetric(
                            icon: Icons.keyboard_arrow_up,
                            label: _formatCount(
                              interactionsController.upvotesCount,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (tags.isNotEmpty) ...[
                      SizedBox(height: tokens.spacePanelGapMd),
                      Wrap(
                        spacing: tokens.spacePanelGapSm,
                        runSpacing: tokens.spacePanelGapSm,
                        children: [
                          for (final tag in tags) HeaderBadge(label: tag.name),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
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

  String _listingImageUrl(Deck deck) {
    final featuredImageUrl = _firstNonEmpty(deck.listing?.featuredImages);

    return featuredImageUrl ??
        _nonEmptyOrNull(deck.coverImageUrl) ??
        _fallbackImageUrl;
  }

  String? _firstNonEmpty(List<String>? values) {
    if (values == null) return null;

    for (final value in values) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) return trimmed;
    }

    return null;
  }

  String? _nonEmptyOrNull(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    return value;
  }

  String _formatCount(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}m';
    }

    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }

    return value.toString();
  }
}

const _fallbackImageUrl = "https://i.redd.it/jvu7xrv8qug11.jpg";

class _HeaderScrim extends StatelessWidget {
  const _HeaderScrim({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withValues(alpha: 0),
                color.withValues(alpha: 0.08),
                color.withValues(alpha: 0.74),
              ],
              stops: const [0, 0.56, 1],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                color.withValues(alpha: 0.42),
                color.withValues(alpha: 0.08),
                color.withValues(alpha: 0.34),
              ],
              stops: const [0, 0.48, 1],
            ),
          ),
        ),
      ],
    );
  }
}

class _CreatorBadge extends StatelessWidget {
  const _CreatorBadge({required this.name, required this.avatarUrl});

  final String name;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final trimmedName = name.trim().isEmpty ? 'Unknown creator' : name.trim();
    final trimmedAvatarUrl = avatarUrl?.trim();
    final hasAvatar = trimmedAvatarUrl != null && trimmedAvatarUrl.isNotEmpty;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'By',
              style: appTextStyle.resolve(tokens, const [
                TextSize.labelSmall,
                TextTone.secondary,
              ]),
            ),
            Text(
              trimmedName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appTextStyle.resolve(tokens, const [
                TextSize.label,
                TextWeight.strong,
              ]),
            ),
          ],
        ),
        SizedBox(width: tokens.spacePanelGapSm),
        CircleAvatar(
          radius: 28,
          backgroundColor: tokens.primarySoft,
          foregroundColor: tokens.primary,
          backgroundImage: hasAvatar ? NetworkImage(trimmedAvatarUrl) : null,
          child: hasAvatar ? null : const Icon(Icons.person_outline),
        ),
      ],
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
    final color = isSelected ? tokens.primary : tokens.textPrimary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          tooltip: isSelected ? 'Remove favorite' : 'Favorite',
          style: IconButton.styleFrom(
            foregroundColor: color,
            disabledForegroundColor: tokens.textMuted,
          ),
          onPressed: onPressed,
          icon: Icon(isSelected ? Icons.favorite : Icons.favorite_border),
        ),
        Text(
          count,
          style: appTextStyle
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
        Icon(icon, color: tokens.textPrimary),
        SizedBox(width: tokens.spacePanelGapSm / 2),
        Text(
          label,
          style: appTextStyle
              .resolve(tokens, const [TextSize.label, TextWeight.strong])
              .copyWith(color: tokens.textPrimary),
        ),
      ],
    );
  }
}

// class _Metric extends StatelessWidget {
//   const _Metric({required this.icon, required this.label});

//   final IconData icon;
//   final String label;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 16, color: AppColors.textSecondary),
//         const SizedBox(width: AppSpacing.xs),
//         Text(
//           label,
//           style: Theme.of(
//             context,
//           ).textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
//         ),
//       ],
//     );
//   }
// }

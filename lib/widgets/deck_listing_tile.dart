import 'package:boo_mondai/hooks/hooks.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/shared/theme/theme.barrel.dart';
import 'package:boo_mondai/variant_styles/variant_styles.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
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
    final tags = deck.tags.take(4).toList();
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

    final tile = SizedBox(
      height: 300,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Surface(
          style: surfaceStyle.resolve(tokens, const [
            SurfacePadding.none,
            SurfaceShape.sharp,
          ]),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(backgroundImageUrl, fit: BoxFit.cover),
              _ImageGradientOverlay(color: tokens.backgroundSurface),
              Padding(
                padding: EdgeInsets.all(tokens.spacePanelGapMd),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: DeckTile(deck: deck, width: 150),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(tokens.spacePanelGapMd),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.end,
                        spacing: tokens.spacePanelGapSm,
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
                            icon: Icons.rate_review_outlined,
                            label: _formatCount(listing?.reviewsCount ?? 0),
                          ),
                          MetaLabel(
                            icon: Icons.chat_bubble_outline,
                            label: _formatCount(listing?.commentsCount ?? 0),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Wrap(
                        alignment: WrapAlignment.end,
                        spacing: tokens.spacePanelGapSm,
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
                          MetaLabel(
                            icon: Icons.person_outline,
                            label: creatorName,
                          ),
                        ],
                      ),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: appTextStyle.resolve(tokens, const [
                          TextSize.header,
                          TextWeight.heavy,
                        ]),
                      ),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: appTextStyle.resolve(tokens, const [
                          TextSize.label,
                          TextWeight.body,
                          TextTone.secondary,
                        ]),
                      ),
                      SizedBox(height: tokens.spacePanelGapSm),

                      if (tags.isNotEmpty) ...[
                        SizedBox(height: tokens.spacePanelGapSm),
                        Wrap(
                          alignment: WrapAlignment.end,
                          spacing: tokens.spacePanelGapSm,
                          runSpacing: tokens.spacePanelGapSm,
                          children: [
                            for (final tag in tags)
                              HeaderBadge(label: tag.name),
                          ],
                        ),
                      ],
                      if (listing != null) ...[
                        SizedBox(height: tokens.spacePanelGapSm),
                        Wrap(
                          alignment: WrapAlignment.end,
                          spacing: tokens.spacePanelGapSm,
                          runSpacing: tokens.spacePanelGapSm,
                          children: [
                            _InteractionButton(
                              icon: interactionsController.voteValue == 1
                                  ? Icons.arrow_circle_up
                                  : Icons.arrow_circle_up_outlined,
                              label: _formatCount(
                                interactionsController.upvotesCount,
                              ),
                              isSelected: interactionsController.voteValue == 1,
                              onPressed: interactionsController.isBusy
                                  ? null
                                  : () {
                                      interactionsController.toggleUpvote();
                                    },
                            ),
                            _InteractionButton(
                              icon: interactionsController.voteValue == -1
                                  ? Icons.arrow_circle_down
                                  : Icons.arrow_circle_down_outlined,
                              label: _formatCount(
                                interactionsController.downvotesCount,
                              ),
                              isSelected:
                                  interactionsController.voteValue == -1,
                              onPressed: interactionsController.isBusy
                                  ? null
                                  : () {
                                      interactionsController.toggleDownvote();
                                    },
                            ),
                            _InteractionButton(
                              icon: interactionsController.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              label: _formatCount(
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
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
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

class _ImageGradientOverlay extends StatelessWidget {
  const _ImageGradientOverlay({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                color.withValues(alpha: 0.98),
                color.withValues(alpha: 0.82),
                color.withValues(alpha: 0.28),
                color.withValues(alpha: 0),
              ],
              stops: const [0, 0.34, 0.68, 1],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.55, 0),
              radius: 1.12,
              colors: [
                color.withValues(alpha: 0),
                color.withValues(alpha: 0),
                color.withValues(alpha: 0.72),
                color.withValues(alpha: 0.96),
              ],
              stops: const [0, 0.34, 0.72, 1],
            ),
          ),
        ),
      ],
    );
  }
}

class _InteractionButton extends StatelessWidget {
  const _InteractionButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final color = isSelected ? tokens.primary : tokens.textMuted;

    return IconButton(
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        foregroundColor: color,
        disabledForegroundColor: tokens.textMuted,
      ),
      tooltip: label,
      onPressed: onPressed,
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          SizedBox(width: tokens.spacePanelGapSm / 2),
          Text(
            label,
            style: appTextStyle
                .resolve(tokens, const [TextSize.labelSmall, TextWeight.strong])
                .copyWith(color: color),
          ),
        ],
      ),
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

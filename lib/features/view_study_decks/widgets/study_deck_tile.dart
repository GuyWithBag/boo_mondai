import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonVariant,
        Deck,
        DeckReviewStats,
        DecksService,
        ImageHelper,
        ProgressBar,
        StudyRating,
        SurfaceBorder,
        SurfaceShadow,
        SurfaceShape,
        TextSize,
        TextWeight,
        ThemeHelper,
        surfaceStyle,
        textStyle;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:theme_variants/theme_variants.dart';

class StudyDeckTile extends StatelessWidget {
  const StudyDeckTile({super.key, this.deck, this.stats, this.onPressed});

  final Deck? deck;
  final DeckReviewStats? stats;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final completion = _completionValue(stats);

    void onTap() {
      if (onPressed != null) {
        onPressed!();
        return;
      }

      if (stats == null || stats!.totalDue <= 0) return;
      context.push('/review/${stats!.deckId}/session');
    }

    final titleStyle = textStyle.resolve(tokens, const [
      TextSize.header,
      TextWeight.heavy,
    ]);
    final labelStyle = textStyle.resolve(tokens, const [
      TextSize.label,
      TextWeight.strong,
    ]);

    final easyColorSet = ThemeHelper.getStudyRatingColorSet(
      tokens,
      StudyRating.easy,
    );
    final goodColorSet = ThemeHelper.getStudyRatingColorSet(
      tokens,
      StudyRating.good,
    );
    final hardColorSet = ThemeHelper.getStudyRatingColorSet(
      tokens,
      StudyRating.hard,
    );
    final againColorSet = ThemeHelper.getStudyRatingColorSet(
      tokens,
      StudyRating.again,
    );
    final deckCoverImage = deck == null
        ? null
        : ImageHelper.getImageProviderFromSource(
            DecksService.getCoverImageUrl(deck!),
          );
    final tileStyle = surfaceStyle.resolve(tokens, const [
      SurfaceBorder.none,
      SurfaceShape.roundedSm,
      SurfaceShadow.none,
    ]);
    final tilePadding = tileStyle.padding ?? EdgeInsets.zero;
    final tileSurfaceStyle = tileStyle.copyWith(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    );
    final tileBackgroundColor = tokens.colorSurfaceBackground;

    return GestureDetector(
      onTap: onTap,
      child: Surface(
        style: tileSurfaceStyle,
        child: Stack(
          children: [
            if (deckCoverImage != null)
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: constraints.maxWidth * 0.8,
                        height: constraints.maxHeight,
                        child: Image(
                          image: deckCoverImage,
                          fit: BoxFit.cover,
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    );
                  },
                ),
              ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      tileBackgroundColor.withValues(alpha: 0.4),
                      tileBackgroundColor,
                    ],
                    stops: const [0, 0.6],
                  ),
                ),
              ),
            ),
            Padding(
              padding: tilePadding,
              child: Column(
                spacing: tokens.spaceLayoutGapMd,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    spacing: tokens.spaceLayoutGapSm,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              stats?.deckTitle ?? deck?.title ?? 'Title',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: titleStyle,
                            ),
                          ),
                          SizedBox(width: tokens.spaceLayoutGapMd.w),
                        ],
                      ),
                      RatingStats(
                        entries: [
                          StatEntry(
                            label: 'New',
                            count: stats?.due.dueNew ?? 0,
                            colorSecondary: easyColorSet.colorBorder,
                            colorPrimary: easyColorSet.colorText,
                          ),
                          StatEntry(
                            label: 'Review',
                            count: stats?.due.dueReview ?? 0,
                            colorSecondary: hardColorSet.colorBorder,
                            colorPrimary: hardColorSet.colorText,
                          ),
                          StatEntry(
                            label: 'Due',
                            count: stats?.totalDue ?? 0,
                            colorPrimary: againColorSet.colorBorder,
                            colorSecondary: againColorSet.colorText,
                          ),
                        ],
                      ),
                      RatingStats(
                        entries: [
                          StatEntry(
                            label: 'Again',
                            count: stats?.historical.again ?? 0,
                            colorSecondary: againColorSet.colorBorder,
                            colorPrimary: againColorSet.colorText,
                          ),
                          StatEntry(
                            label: 'Hard',
                            count: stats?.historical.hard ?? 0,
                            colorSecondary: hardColorSet.colorBorder,
                            colorPrimary: hardColorSet.colorText,
                          ),
                          StatEntry(
                            label: 'Good',
                            count: stats?.historical.good ?? 0,
                            colorSecondary: goodColorSet.colorBorder,
                            colorPrimary: goodColorSet.colorText,
                          ),
                          StatEntry(
                            label: 'Easy',
                            count: stats?.historical.easy ?? 0,
                            colorSecondary: easyColorSet.colorBorder,
                            colorPrimary: easyColorSet.colorText,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: tokens.spaceLayoutGapSm,
                    children: [
                      Expanded(child: ProgressBar(value: completion)),
                      Text(
                        '${(completion * 100).round()}%',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: labelStyle,
                      ),
                    ],
                  ),
                  Button(
                    variants: const [ButtonVariant.flat],
                    onPressed: () {},
                    leading: const Text('View Details'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _completionValue(DeckReviewStats? stats) {
    if (stats == null) return 0;

    final reviewed = stats.historical.totalReviews;
    final totalKnown = reviewed + stats.totalDue;
    if (totalKnown == 0) return 0;

    return reviewed / totalKnown;
  }
}

class RatingStats extends StatelessWidget {
  const RatingStats({super.key, required this.entries});

  final List<StatEntry> entries;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final labelStyle = textStyle.resolve(tokens, const [
      TextSize.labelSmall,
      TextWeight.strong,
    ]);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final entry in entries) ...[
          Expanded(
            child: Column(
              children: [
                Text(
                  entry.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: labelStyle.copyWith(color: entry.colorSecondary),
                ),
                Text(
                  entry.count.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: labelStyle.copyWith(color: entry.colorPrimary),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class StatEntry {
  const StatEntry({
    required this.label,
    required this.count,
    required this.colorPrimary,
    required this.colorSecondary,
  });

  final String label;
  final int count;
  final Color colorPrimary;
  final Color colorSecondary;
}

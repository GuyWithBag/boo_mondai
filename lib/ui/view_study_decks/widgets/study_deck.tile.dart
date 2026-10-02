import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        Deck,
        DeckReviewStats,
        DecksDirectoryPaths,
        ImageHelper,
        ProgressBar,
        SessionRatingStatsBlock,
        SessionRatingStatsBlockController,
        SessionRatingStatsMode,
        SurfaceBorder,
        SurfaceColor,
        SurfaceShadow,
        SurfaceShape,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class StudyDeckTile extends SignalHookWidget {
  const StudyDeckTile({super.key, this.deck, this.stats});

  final Deck? deck;
  final DeckReviewStats? stats;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final completion = _completionValue(stats);
    final ratingStatsController = useMemoized(
      () => SessionRatingStatsBlockController(
        showText: false,
        initialMode: SessionRatingStatsMode.ratingStats,
      ),
    );
    useEffect(() => ratingStatsController.dispose, [ratingStatsController]);

    final titleStyle = textStyle.resolve(tokens, const [
      TextSize.header,
      TextWeight.heavy,
    ]);
    final labelStyle = textStyle.resolve(tokens, const [
      TextSize.label,
      TextWeight.strong,
    ]);

    final deckCoverImagePath = deck == null
        ? null
        : DecksDirectoryPaths.coverImage(deckTitle: deck!.title);
    final deckCoverImageSignal = useFutureSignal(
      () => ImageHelper.getImageProviderFromSource(deckCoverImagePath),
      keys: [deckCoverImagePath],
    );
    final deckCoverImage = deckCoverImageSignal.value.map(
      data: (value) => value,
      error: () => null,
      loading: () => null,
    );
    final tileStyle = surfaceStyle.resolve(tokens, const [
      SurfaceBorder.none,
      SurfaceShape.roundedSm,
      SurfaceColor.muted,
      SurfaceShadow.none,
    ]);
    final tilePadding = tileStyle.padding ?? EdgeInsets.zero;
    final tileSurfaceStyle = tileStyle.copyWith(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    );
    final tileBackgroundColor = tokens.colorSurfaceBackground;

    return Surface(
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
                    if (stats != null)
                      SessionRatingStatsBlock(
                        stats: stats!,
                        controller: ratingStatsController,
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
                Row(
                  spacing: tokens.spaceLayoutGapSm,
                  children: [
                    Expanded(
                      child: Button(
                        onPressed: () {},
                        leading: const Text('View Details'),
                      ),
                    ),
                    Expanded(
                      child: Button(
                        onPressed: () {
                          if (stats == null || stats!.totalDue <= 0) return;
                          context.push('/review/${stats!.deckId}/session');
                        },
                        leading: const Text('Review'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _completionValue(DeckReviewStats? stats) {
    if (stats == null) return 0;

    final reviewed = stats.ratingStats.totalReviews;
    final totalKnown = reviewed + stats.totalDue;
    if (totalKnown == 0) return 0;

    return reviewed / totalKnown;
  }
}

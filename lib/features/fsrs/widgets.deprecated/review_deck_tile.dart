import 'package:boo_mondai/features/app_theme/surface.variant.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonDepth,
        ButtonTone,
        Deck,
        DeckTile,
        DeckReviewStats,
        ProgressBar,
        appTextStyle,
        TextSize,
        TextTone,
        TextWeight;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:theme_variants/theme_variants.dart';

class ReviewDeckTile extends StatelessWidget {
  const ReviewDeckTile({super.key, this.deck, this.stats, this.onPressed});

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

    return GestureDetector(
      onTap: onTap,
      child: Surface(
        style: surfaceStyle.resolve(tokens),
        child: Row(
          children: [
            if (deck == null)
              const _DeckCoverPlaceholder()
            else
              DeckTile(deck: deck, width: 108.w),
            SizedBox(width: tokens.spacePanelGapMd.w),
            Expanded(
              child: _ReviewDeckDetails(stats: stats, completion: completion),
            ),
            SizedBox(width: tokens.spacePanelGapMd.w),
            Button.icon(
              onPressed: () {},
              icon: Icons.visibility_outlined,
              tone: ButtonTone.ghost,
              depth: ButtonDepth.flat,
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

class _ReviewDeckDetails extends StatelessWidget {
  const _ReviewDeckDetails({required this.stats, required this.completion});

  final DeckReviewStats? stats;
  final double completion;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final titleStyle = appTextStyle.resolve(tokens, const [
      TextSize.header,
      TextWeight.heavy,
      TextTone.primary,
    ]);
    final labelStyle = appTextStyle.resolve(tokens, const [
      TextSize.label,
      TextWeight.strong,
      TextTone.primary,
    ]);

    final historicalStats = _StatsCluster(
      entries: [
        _StatEntry('Again', stats?.historical.again ?? 0),
        _StatEntry('Hard', stats?.historical.hard ?? 0),
        _StatEntry('Good', stats?.historical.good ?? 0),
        _StatEntry('Easy', stats?.historical.easy ?? 0),
      ],
    );
    final dueStats = _StatsCluster(
      entries: [
        _StatEntry('New', stats?.due.dueNew ?? 0),
        _StatEntry('Review', stats?.due.dueReview ?? 0),
        _StatEntry('Due', stats?.totalDue ?? 0),
      ],
    );
    final completionPanel = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${(completion * 100).round()}% Completion',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: labelStyle,
        ),
        SizedBox(height: tokens.spacePanelGapSm.h),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 120.w),
          child: ProgressBar(value: completion),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 280.w;

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stats?.deckTitle ?? 'Title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: titleStyle,
              ),
              SizedBox(height: tokens.spacePanelGapSm.h),
              historicalStats,
              SizedBox(height: tokens.spacePanelGapMd.h),
              completionPanel,
              SizedBox(height: tokens.spacePanelGapSm.h),
              dueStats,
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    stats?.deckTitle ?? 'Title',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: titleStyle,
                  ),
                ),
                SizedBox(width: tokens.spacePanelGapMd.w),
                Flexible(child: historicalStats),
              ],
            ),
            SizedBox(height: tokens.spacePanelGapMd.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: completionPanel),
                SizedBox(width: tokens.spacePanelGapMd.w),
                Flexible(child: dueStats),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _StatsCluster extends StatelessWidget {
  const _StatsCluster({required this.entries});

  final List<_StatEntry> entries;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final labelStyle = appTextStyle.resolve(tokens, const [
      TextSize.label,
      TextWeight.strong,
      TextTone.primary,
    ]);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : entries.length * 48.w;
        final cellWidth = (maxWidth / entries.length).clamp(32.w, 48.w);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final entry in entries) ...[
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      entry.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: labelStyle,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final entry in entries) ...[
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      entry.count.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: labelStyle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}

class _StatEntry {
  const _StatEntry(this.label, this.count);

  final String label;
  final int count;
}

class _DeckCoverPlaceholder extends StatelessWidget {
  const _DeckCoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return CustomPaint(
      painter: _DeckCoverPlaceholderPainter(color: tokens.textPrimary),
      child: SizedBox(width: 108.w, height: 152.h),
    );
  }
}

class _DeckCoverPlaceholderPainter extends CustomPainter {
  const _DeckCoverPlaceholderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final rect = Offset.zero & size;

    canvas.drawRect(rect.deflate(1), paint);
    canvas.drawLine(rect.topLeft, rect.bottomRight, paint);
    canvas.drawLine(rect.topRight, rect.bottomLeft, paint);
  }

  @override
  bool shouldRepaint(covariant _DeckCoverPlaceholderPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}

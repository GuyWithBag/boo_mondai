import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        DeckReviewStats,
        StudyRating,
        TextSize,
        TextWeight,
        ThemeHelper,
        textStyle;
import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:signals_hooks/signals_hooks.dart' hide signal;
import 'package:theme_variants/theme_variants.dart';

enum SessionRatingStatsMode { due, ratingStats }

class SessionRatingStatsBlockController {
  SessionRatingStatsBlockController({
    SessionRatingStatsMode initialMode = SessionRatingStatsMode.due,
    this.switchModeOnPressed = true,
    this.showText = true,
  }) : mode = signal(initialMode);

  final Signal<SessionRatingStatsMode> mode;
  final bool switchModeOnPressed;
  final bool showText;

  void switchMode() {
    if (!switchModeOnPressed) return;

    mode.value = switch (mode.value) {
      SessionRatingStatsMode.due => SessionRatingStatsMode.ratingStats,
      SessionRatingStatsMode.ratingStats => SessionRatingStatsMode.due,
    };
  }

  void dispose() {
    mode.dispose();
  }
}

class SessionRatingStatsBlock extends SignalWidget {
  const SessionRatingStatsBlock({
    super.key,
    required this.stats,
    required this.controller,
  });

  final DeckReviewStats stats;
  final SessionRatingStatsBlockController controller;

  @override
  Widget build(BuildContext context) {
    final entries = _entries(context, stats, controller.mode.value);

    Widget child = controller.showText
        ? _SessionRatingStatsText(entries: entries)
        : _SessionRatingStatsDots(entries: entries);

    if (controller.switchModeOnPressed) {
      child = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: controller.switchMode,
        child: child,
      );
    }

    return child;
  }

  List<_SessionRatingStatsEntry> _entries(
    BuildContext context,
    DeckReviewStats stats,
    SessionRatingStatsMode mode,
  ) {
    final tokens = context.themeTokens<AppTokens>();
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

    return switch (mode) {
      SessionRatingStatsMode.due => [
        _SessionRatingStatsEntry(
          label: 'New',
          count: stats.due.dueNew,
          colorSecondary: easyColorSet.colorBorder,
          colorPrimary: easyColorSet.colorText,
        ),
        _SessionRatingStatsEntry(
          label: 'Review',
          count: stats.due.dueReview,
          colorSecondary: hardColorSet.colorBorder,
          colorPrimary: hardColorSet.colorText,
        ),
        _SessionRatingStatsEntry(
          label: 'Due',
          count: stats.totalDue,
          colorPrimary: againColorSet.colorBorder,
          colorSecondary: againColorSet.colorText,
        ),
      ],
      SessionRatingStatsMode.ratingStats => [
        _SessionRatingStatsEntry(
          label: 'Again',
          count: stats.ratingStats.again,
          colorSecondary: againColorSet.colorBorder,
          colorPrimary: againColorSet.colorText,
        ),
        _SessionRatingStatsEntry(
          label: 'Hard',
          count: stats.ratingStats.hard,
          colorSecondary: hardColorSet.colorBorder,
          colorPrimary: hardColorSet.colorText,
        ),
        _SessionRatingStatsEntry(
          label: 'Good',
          count: stats.ratingStats.good,
          colorSecondary: goodColorSet.colorBorder,
          colorPrimary: goodColorSet.colorText,
        ),
        _SessionRatingStatsEntry(
          label: 'Easy',
          count: stats.ratingStats.easy,
          colorSecondary: easyColorSet.colorBorder,
          colorPrimary: easyColorSet.colorText,
        ),
      ],
    };
  }
}

class _SessionRatingStatsText extends SignalWidget {
  const _SessionRatingStatsText({required this.entries});

  final List<_SessionRatingStatsEntry> entries;

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
        for (final entry in entries)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  entry.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: labelStyle.copyWith(color: entry.colorPrimary),
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
    );
  }
}

class _SessionRatingStatsDots extends StatelessWidget {
  const _SessionRatingStatsDots({required this.entries});

  final List<_SessionRatingStatsEntry> entries;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final labelStyle = textStyle.resolve(tokens, const [
      TextSize.labelSmall,
      TextWeight.strong,
    ]);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final entry in entries)
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: entry.colorPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox.square(dimension: 8),
                ),
                SizedBox(width: tokens.spaceLayoutGapXsm),
                Flexible(
                  child: Text(
                    entry.count.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: labelStyle.copyWith(color: entry.colorPrimary),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SessionRatingStatsEntry {
  const _SessionRatingStatsEntry({
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

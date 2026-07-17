// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/rating_button.dart
// PURPOSE: Individual button for submitting an FSRS rating
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        ButtonPadding,
        StudyRating,
        StudySessionController,
        TextSize,
        TextWeight,
        buttonStyle,
        textStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class RatingButton extends StatelessWidget {
  final StudyRating type;
  final VoidCallback onTap;
  final StudySessionController ctrl;

  const RatingButton(
    this.type, {
    super.key,
    required this.onTap,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    final reviewTime = ctrl.nextIntervals[type] ?? '-';

    late final String shortcut;
    late final String label;
    late final ButtonColor color;

    switch (type) {
      case StudyRating.again:
      case StudyRating.incorrect: // Fallback just in case
        label = 'Again';
        shortcut = '1';
        color = ButtonColor.again;
      case StudyRating.hard:
        label = 'Hard';
        shortcut = '2';
        color = ButtonColor.hard;
      case StudyRating.good:
        label = 'Good';
        shortcut = '3';
        color = ButtonColor.good;
      case StudyRating.easy:
        label = 'Easy';
        shortcut = '4';
        color = ButtonColor.easy;
    }

    final tokens = context.themeTokens<AppTokens>();
    final variants = [color, ButtonPadding.sm];
    final resolvedButtonStyle = buttonStyle.resolve(tokens, variants);

    return Expanded(
      child: Tooltip(
        message: 'Press $shortcut',
        child: Button(
          onPressed: onTap,
          variants: variants,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: tokens.spaceLayoutGapXsm,
            children: [
              Text(label.toUpperCase(), textAlign: TextAlign.center),
              Opacity(
                opacity: 0.7,
                child: Text(
                  reviewTime,
                  textAlign: TextAlign.center,
                  style: textStyle
                      .resolve(tokens, const [
                        TextSize.labelSmall,
                        TextWeight.heavy,
                      ])
                      .copyWith(
                        color: resolvedButtonStyle.contentStyle.textStyle.color,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

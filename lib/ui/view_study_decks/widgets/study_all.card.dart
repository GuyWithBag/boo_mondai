import 'dart:math';

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        SurfaceColor,
        SurfaceShadow,
        SurfaceShape,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:theme_variants/theme_variants.dart';

class StudyAllDecks extends StatelessWidget {
  const StudyAllDecks({super.key, required this.dueCount});

  final int dueCount;

  static const motivationalPhrases = [
    'Tiny steps still count.',
    'One card at a time.',
    'Future you is grateful.',
    'Keep the streak warm.',
    'A quick win is waiting.',
    'Your memory likes reps.',
    'Make it stick today.',
    'Small review, big payoff.',
    'You are closer already.',
    'Momentum starts here.',
    'Train the recall muscle.',
    'Give your brain a nudge.',
    'Today is a good review day.',
    'Keep your knowledge fresh.',
    'A little practice compounds.',
    'Turn effort into recall.',
    'Your cards missed you.',
    'Sharpen it while it is fresh.',
    'The queue gets lighter now.',
    'One session, cleaner memory.',
    'You know more than you think.',
    'Review now, relax later.',
    'Stack another small victory.',
    'Let recall do its magic.',
    'Warm up the memory engine.',
    'Beat the forgetting curve.',
    'Make the next time easier.',
    'A calm review is enough.',
    'Build fluency by showing up.',
    'Your streak has excellent taste.',
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final canReview = dueCount > 0;
    final phrase =
        motivationalPhrases[Random().nextInt(motivationalPhrases.length)];

    return Surface(
      style: surfaceStyle.resolve(tokens, const [
        SurfaceColor.primarySoft,
        SurfaceShape.roundedSm,
        SurfaceShadow.tactile,
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: tokens.spaceLayoutGapSm,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You have $dueCount card${dueCount == 1 ? '' : 's'} Due',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textStyle.resolve(tokens, const [
              TextSize.header2,
              TextWeight.strong,
            ]),
          ),
          Text(
            phrase,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle.resolve(tokens, const [
              TextSize.label,
              TextWeight.strong,
            ]),
          ),
          Button(
            onPressed: canReview ? () => context.push('/review/session') : null,
            variants: const [ButtonColor.primary],
            child: const Text('REVIEW ALL?'),
          ),
        ],
      ),
    );
  }
}

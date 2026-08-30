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

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final canReview = dueCount > 0;

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
            '{Random Motivational Phrase}',
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

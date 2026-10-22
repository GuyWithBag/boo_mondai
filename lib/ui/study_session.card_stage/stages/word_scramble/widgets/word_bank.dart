import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ScaleHelper, TextColor, TextSize, TextWeight, textStyle;
import 'package:boo_mondai/ui/study_session.card_stage/stages/word_scramble/controllers/word_scramble.controller.dart';
import 'package:boo_mondai/ui/study_session.card_stage/stages/word_scramble/widgets/word_scramble.chip.dart';
import 'package:flutter/material.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class WordBank extends SignalWidget {
  const WordBank({required this.controller, super.key, this.contentScale = 1});

  final WordScrambleController controller;
  final double contentScale;

  static const double preferredHeight = 110;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final words = controller.wordBank.value;
    final isLocked = controller.isLocked;
    final gap = ScaleHelper.getScaledValue(
      tokens.spaceLayoutGapSm,
      contentScale,
    );

    return SizedBox(
      height: ScaleHelper.getScaledValue(
        WordBank.preferredHeight,
        contentScale,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Word Bank'.toUpperCase(),
            style: textStyle.resolve(tokens, const [
              TextSize.labelSmall,
              TextWeight.heavy,
              TextColor.muted,
            ]),
          ),
          SizedBox(height: gap),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final word in words)
                    WordScrambleChip(
                      value: word.text,
                      dragPayload: isLocked
                          ? null
                          : WordScrambleBankWordDragPayload(word),
                      onPressed: isLocked
                          ? null
                          : () => controller.selectWord(word),
                      contentScale: contentScale,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

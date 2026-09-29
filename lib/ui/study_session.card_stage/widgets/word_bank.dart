import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, TextColor, TextSize, TextWeight, textStyle;
import 'package:boo_mondai/ui/study_session.card_stage/widgets/word_scramble.chip.dart';
import 'package:boo_mondai/ui/study_session.card_stage/widgets/word_scramble.controller.dart';
import 'package:flutter/material.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class WordBank extends SignalWidget {
  const WordBank({required this.controller, super.key});

  final WordScrambleController controller;

  static const double preferredHeight = 60;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final words = controller.wordBank.value;
    final isLocked = controller.isLocked;

    return Column(
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
        SizedBox(height: tokens.spaceLayoutGapSm),
        SingleChildScrollView(
          child: Wrap(
            spacing: tokens.spaceLayoutGapSm,
            runSpacing: tokens.spaceLayoutGapSm,
            children: [
              for (final word in words)
                _DraggableBankChip(
                  word: word,
                  enabled: !isLocked,
                  onPressed: () => controller.selectWord(word),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DraggableBankChip extends StatelessWidget {
  const _DraggableBankChip({
    required this.word,
    required this.enabled,
    required this.onPressed,
  });

  final WordScrambleWord word;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final chip = WordScrambleChip(
      value: word.text,
      onPressed: enabled ? onPressed : null,
    );

    if (!enabled) return chip;

    return LongPressDraggable<WordScrambleDragPayload>(
      delay: Duration(milliseconds: 100),
      data: WordScrambleBankWordDragPayload(word),
      feedback: Material(color: Colors.transparent, child: chip),
      childWhenDragging: Opacity(opacity: 0.35, child: chip),
      child: chip,
    );
  }
}
